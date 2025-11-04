/datum/mm_run

	var/decl/modular_map_generator/generator
	/// Pseudo-linear/2D list of cell coord to cell.
	var/list/_grid
	/// Pending connections from cells used in building the next iteration.
	var/list/_nodes
	/// What is our maximum cell X-dimension (not turf)?
	var/g_mx = 0
	/// What is our maximum cell Y-dimension (not turf)?
	var/g_my = 0
	/// What level are we placing on?
	var/g_pz = 0
	/// Assoc list of target turf to map template for final loading.
	var/list/load_operations = list()
	/// Counter for progress reporting.
	var/gen_started = 0
	/// Data type to use for individual cells.
	var/cell_type = /datum/mm_cell
	/// Upper bound for loop iteration to avoid infinite loops.
	var/const/LOOP_SANITY = 100000
	/// How many trailing connection passes to do before giving up.
	var/const/MAX_TRAILING_PASS = 100

/datum/mm_run/New(_gen, _x, _y, _z)
	// Keep track of our source generator.
	generator = _gen
	g_mx = _x
	g_my = _y
	g_pz = _z
	// Declare a list for tracking our occupied space and pre-build our graph.
	_grid = new /list(TRANSLATE_MODMAP_COORD(g_mx, g_my, g_mx))

/datum/mm_run/proc/generate_initial_map()
	gen_started = world.time
	// Placing our initial templates (either hardcoded or a single random template)
	_nodes = place_mandatory_templates(generator.get_initial_templates(src))
	if(!length(_nodes))
		log_debug("No initial nodes from template placement, generation failed.")
		return FALSE
	log_debug("Starting with [length(_nodes)] node\s and bounds [g_mx],[g_my] on z[g_pz].")
	// Main meat of the generator is in this proc.
	try
		build_from_nodes(permit_cycles = FALSE)
		log_debug("Initial run finished with [length(_nodes)] pending node\s, [get_dangling_connection_count(ignore_origin_cells = FALSE)] dangling connection\s, and [get_grid_count()] occupied cells.")
	catch(var/exception/E)
		log_error("Exception during modular map run: [EXCEPTION_TEXT(E)]")
		return FALSE
	return TRUE

/datum/mm_run/proc/perform_map_cleanup()
	// Clean up any dangling connections (gaps in the generated grid)
	if(generator.do_trim_trailing_connections)
		var/sanity = 0
		while(get_dangling_connection_count(TRUE) && sanity <= MAX_TRAILING_PASS)
			trim_dangling_connections(++sanity)
		if(sanity > MAX_TRAILING_PASS)
			log_debug("Failed to generate [generator.name] in [(world.time - gen_started)/10] second\s: exceeded trailing connection pruning max pass.")
			//return FALSE

	var/list/paths = resolve_isolated_paths()
	var/failure_reason = validate_run(paths)
	if(failure_reason)
		log_debug("Failed to generate [generator.name] in [(world.time - gen_started)/10] second\s: [failure_reason]")
		return FALSE

	log_debug("Cleanup finished with [length(_nodes)] pending nodes, [get_dangling_connection_count()] dangling connection\s, [length(paths)] discrete paths, and [get_grid_count()] occupied cells.")
	return TRUE

/datum/mm_run/proc/build_from_nodes(permit_dangling_connections = TRUE, permit_cycles = TRUE)

	var/sanity = LOOP_SANITY
	while(length(_nodes))

		var/list/nodes_to_iterate = list()
		var/node_gen = null
		var/node_index = 1

		while(node_index <= length(_nodes))
			var/datum/mm_node/node = _nodes[node_index++]
			if(isnull(node_gen) || node.generation == node_gen)
				nodes_to_iterate += node
				_nodes -= node
			else
				break

		while(length(nodes_to_iterate) && sanity)

			// Pick one of our remaining connections.
			var/datum/mm_node/node             = nodes_to_iterate[1]
			var/datum/mm_connection/connection = node.connection
			var/datum/mm_cell/cell             = node.cell
			nodes_to_iterate.Cut(1, 2)


			// We do not apply terminators on the first run.
			var/list/terminators = list()

			// Try to find a template that we can connect to this spot.
			for(var/connection_flag in shuffle(global._mcf_flags))
				// Flag not present in this connection's flags.
				if(!(connection.connection_flags & connection_flag))
					continue
				// Determine the bottom-left corner of the space needed to fit this template from this connection.
				var/list/templates = generator.templates_by_category[num2text(connection_flag)]
				if(!islist(templates))
					continue
				// Randomise template order to avoid always placing a northeast corner or whatever.
				templates = shuffle(templates)
				for(var/datum/map_template/modular/template in templates)
					if(template.is_terminator)
						terminators += template
						templates -= terminators
				connection = attempt_place_templates(templates, connection, cell, node, permit_dangling_connections, permit_cycles)
				if(!connection)
					break
				CHECK_TICK

			// Connection is not null and we have terminators, so try to place one of those.
			if(connection && length(terminators))
				connection = attempt_place_templates(shuffle(terminators), connection, cell, node, permit_dangling_connections, permit_cycles)
			sanity--

			if(!QDELETED(node))
				qdel(node)
			CHECK_TICK

/datum/mm_run/proc/attempt_place_templates(list/templates, datum/mm_connection/connection, datum/mm_cell/cell, datum/mm_node/node, permit_dangling_connections, permit_cycles)

	// The cell is the origin point of the cell, so don't add offset.
	var/connection_x = (cell.cell_x + connection.target_x)
	var/connection_y = (cell.cell_y + connection.target_y)

	var/sanity = LOOP_SANITY
	while(length(templates) && sanity)

		sanity--
		var/datum/map_template/modular/template = templates[1]
		templates.Cut(1, 2)
		CHECK_TICK

		// Coarse parse; find all connections in this template that are facing the right way
		// and have the right connection type to match up with our outgoing connection.
		var/list/possible_connections = list()
		for(var/datum/mm_connection/possible_connection in template.cell_connections)
			if(connection.can_connect_to(possible_connection))
				// Nominally compatible; it will fail placement if it overlaps with an existing cell.
				possible_connections += possible_connection
			CHECK_TICK

		// Not even remotely possible.
		if(!length(possible_connections))
			continue

		possible_connections = shuffle(possible_connections)
		for(var/datum/mm_connection/possible_connection in possible_connections)
			// Get base template origin coords, then adjust for template size.
			var/place_x = connection_x
			var/place_y = connection_y
			// Note to future self: cell width/height are absolute, not an offset, hence -1.
			switch(connection.direction_string)
				if("SOUTH")
					place_y -= (template.cell_height-1)
				if("WEST")
					place_x -= (template.cell_width-1)

			// Immediately out of bounds, no thank you.
			if(place_x < 0 || place_y < 0)
				continue

			CHECK_TICK

			// Actually try to place this template from our connection.
			var/list/placement_results = place_on_grid(cell, template, place_x, place_y, node.generation, permit_dangling_connections, permit_cycles)
			if(length(placement_results))
				_nodes.Insert(1, shuffle(placement_results))
				connection = null
				sanity = LOOP_SANITY // reset our failure counter
				break
		// Connection is null, we're done.
		if(!connection)
			break
		CHECK_TICK
	return connection

/datum/mm_run/proc/place_on_grid(datum/mm_cell/origin, datum/map_template/modular/placing, place_x, place_y, generation, permit_dangling_connections = TRUE, permit_cycles = FALSE)

	// TODO: move this into initial template selection for this placement
	if(generator.max_generation > 0 && generation >= generator.max_generation && !placing.is_terminator)
		return null
	if(generator.min_generation > 0 && generation < generator.min_generation && placing.is_terminator)
		return null

	// We will be returning a list of connections resulting from this placement.
	// An empty/null return means a failed placement.
	// Cell width/height are absolute, not an offset.
	var/place_x_m = place_x + (placing.cell_width-1)
	var/place_y_m = place_y + (placing.cell_height-1)

	// We always go bottom left to top right, and will never be given a negative origin, so only check the top right bound.
	if(place_x_m > g_mx || place_y_m > g_my)
		return null

	// Quick check to make sure there's actually room for us to be placed here.
	for(var/x = place_x to place_x_m)
		for(var/y = place_y to place_y_m)
			if(!isnull(_grid[TRANSLATE_MODMAP_COORD(x, y, g_mx)]))
				return null

	// Check what connections will be free after this tile is placed.
	// Connection targets with no corresponding cell are valid.
	// Connection targets which match the type and orientation of the corresponding cell are valid.
	var/list/template_connections
	for(var/datum/mm_connection/connection in placing.cell_connections)

		// Work out the coords for the cell we're trying to connect to.
		var/target_x = place_x + connection.offset_x + connection.target_x
		var/target_y = place_y + connection.offset_y + connection.target_y

		var/dummy_connection = !!(connection.connection_flags & MCF_BLOCKER)
		// Can't leave a dangling connection facing the void.
		if(!dummy_connection && (target_x < 0 || target_y < 0 || target_x > g_mx || target_y > g_my))
			return null

		// Connection target is outside of map bounds - this room cannot be placed here if we want our map to be complete.
		var/target_index = TRANSLATE_MODMAP_COORD(target_x, target_y, g_mx)
		if(target_index <= 0 || target_index > length(_grid))
			return null

		// What is in the cell we're targeting?
		var/datum/mm_cell/target_cell = _grid[target_index]

		// DEBUG: banning cells that cause cycles.
		if(!permit_cycles && !dummy_connection && !isnull(target_cell) && target_cell != origin)
			return null

		// Connection target is free, we don't need to check existing connections...
		if(isnull(target_cell))
			if(permit_dangling_connections || (connection.connection_flags & (MCF_BLOCKER)))
				// It's unoccupied and we aren't blocking a connection, we can use this spot.
				LAZYADD(template_connections, connection)
				continue
			// We're trying to backfill the graph or something, do not permit a placement that would leave an open connection
			return null

		// Connection target has no connections (all connections used)
		var/list/target_conns = target_cell.get_open_connections()
		if(!length(target_conns))
			return null

		// We need to find a potential match for all our connections in the target connections.
		var/found_cell = FALSE
		for(var/datum/mm_connection/target_connection in target_conns)
			if(!connection.can_connect_to(target_connection))
				continue
			// This one is possible! Mark it down for later and continue evaluation.
			found_cell = TRUE
			LAZYSET(template_connections, connection, target_connection)
			break

		// No partner/space for this connection, so this template is unplacable.
		if(!found_cell)
			return null

	// We have not been able to find a partner or empty cell for all of our outgoing connections.
	if(length(template_connections) != length(placing.cell_connections))
		return null

	// This room is placable - populate the cells in the grid with it.
	var/datum/mm_cell/root_cell = new cell_type(src, place_x, place_y, placing, null, generation+1, 0, 0)
	var/list/placed_cells = list(root_cell)
	if(place_x < place_x_m || place_y < place_y_m)
		for(var/x = place_x to place_x_m)
			for(var/y = place_y to place_y_m)
				if(x == place_x && y == place_y)
					continue
				placed_cells += new cell_type(src, x, y, placing, root_cell, generation+1, x-place_x, y-place_y)

	for(var/datum/mm_cell/placed_cell as anything in placed_cells)
		_grid[TRANSLATE_MODMAP_COORD(placed_cell.cell_x, placed_cell.cell_y, g_mx)] = placed_cell

	for(var/datum/mm_connection/connection in template_connections)
		var/datum/mm_connection/target_connection = template_connections[connection]
		var/dangling_x = place_x + connection.offset_x
		var/dangling_y = place_y + connection.offset_y
		if(istype(target_connection))
			// Retrieve our target cell and remove the now-linked connection from the list.
			var/target_x = dangling_x + connection.target_x
			var/target_y = dangling_y + connection.target_y
			var/datum/mm_cell/target_cell = _grid[TRANSLATE_MODMAP_COORD(target_x, target_y, g_mx)]
			target_cell.close_connection(target_connection)
			for(var/datum/mm_cell/placed_cell as anything in placed_cells)
				placed_cell.close_connection(connection)
		else if(!(connection.connection_flags & (MCF_BLOCKER)))
			var/datum/mm_node/node = new(_grid[TRANSLATE_MODMAP_COORD(dangling_x, dangling_y, g_mx)], connection, generation+1)
			LAZYADD(., node)

/datum/mm_run/proc/place_mandatory_templates(list/initial_templates)
	for(var/template in initial_templates)
		var/list/coords = initial_templates[template]
		log_debug("Got initial template: [template], [json_encode(coords)] (map template: [istype(template, /datum/map_template)], modular template: [istype(template, /datum/map_template/modular)])")

	for(var/datum/map_template/modular/template in initial_templates)
		var/list/coords = initial_templates[template]
		log_debug("Trying to place [template] at [coords[1]], [coords[2]]")
		var/list/new_nodes = place_on_grid(null, template, coords[1], coords[2], permit_dangling_connections = TRUE, permit_cycles = TRUE)
		if(length(new_nodes))
			LAZYDISTINCTADD(., new_nodes)
		else
			log_debug("Failed to place mandatory template [template] from [coords[1]],[coords[2]] to [coords[1]+template.cell_width-1],[coords[1]+template.cell_height-1].")

/datum/mm_run/proc/get_dangling_connection_count(bool_return, ignore_origin_cells = TRUE)
	. = 0
	for(var/datum/mm_cell/cell in _grid)
		if(ignore_origin_cells && cell.generation <= 1)
			continue
		for(var/datum/mm_connection/connection in cell.get_open_connections(exclude_flags = MCF_BLOCKER))
			.++
			if(bool_return)
				break

/datum/mm_run/proc/has_dangling_connections(ignore_origin_cells = TRUE)
	for(var/datum/mm_cell/cell in _grid)
		// Origin cells typically don't count.
		if(ignore_origin_cells && cell.generation <= 1)
			continue
		// Find unlinked connections on this cell that indicate it needs to be cleaned up.
		for(var/datum/mm_connection/connection in cell.get_open_connections(exclude_flags = MCF_BLOCKER))
			return TRUE
	return FALSE

/datum/mm_run/proc/trim_dangling_connections(iteration)

	var/list/actual_cells = list()
	for(var/datum/mm_cell/cell in _grid)
		actual_cells += cell

	log_debug("Trimming dangling connections from [length(actual_cells)] cell\s - run #[iteration]")

	// Try to clean up dangling connections.
	_nodes = list()
	var/list/clear_cells = list()
	for(var/datum/mm_cell/cell as anything in actual_cells)
		// Find unlinked connections on this cell that indicate it needs to be cleaned up.
		for(var/datum/mm_connection/connection in cell.get_open_connections(exclude_flags = MCF_BLOCKER))
			cell = cell.owner || cell
			if(cell.generation <= 1) // Do not remove our origins even if we can't connect them to anything. Leave that for validation failure.
				continue
			clear_cells |= cell
			break

	if(!length(clear_cells))
		log_debug("No cells to clear.")
		return

	// Try to avoid clearing too many cells in one pass (resulting in tons of tiny truncated paths),
	// we mostly just want to shake things up so non-terminating connections might be placable.
	var/total_clear_cells = length(clear_cells)
	if(total_clear_cells > generator.trailing_connection_trim_threshold && generator.trailing_connection_trim_multiplier < 1)
		clear_cells = shuffle(clear_cells)
		clear_cells.Cut(1, 1+max(ceil(length(clear_cells) * generator.trailing_connection_trim_multiplier),1))

	log_debug("Clearing [length(clear_cells)]/[total_clear_cells] cell\s...")

	// Do the actual cleanup.
	for(var/datum/mm_cell/cell in clear_cells)
		var/list/freed_nodes = clear_cell(cell)
		if(length(freed_nodes))
			_nodes |= freed_nodes

	// If we generated new nodes, build out from them.
	if(length(_nodes) <= 0)
		return

	log_debug("Rebuilding [length(_nodes)] node\s...")
	build_from_nodes(permit_dangling_connections = FALSE)

/datum/mm_run/proc/clear_cell(datum/mm_cell/cell)

	if(!istype(cell) || QDELETED(cell))
		return

	// If this is a filler cell, remove the entire chunk.
	if(cell.owner)
		return clear_cell(cell.owner)

	// Clear our indicated cells off the grid.
	var/list/cleared_cells = list()
	for(var/x = cell.cell_x to (cell.cell_x+cell.template.cell_width-1))
		for(var/y = cell.cell_y to (cell.cell_y+cell.template.cell_height-1))
			var/ci = TRANSLATE_MODMAP_COORD(x, y, g_mx)
			if(ci > 0 && ci <= length(_grid))
				var/datum/mm_cell/clear = _grid[ci]
				_grid[ci] = null // IMPORTANT: not Remove() or -=, grid index is position.
				if(!isnull(clear) && clear.generation > 1) // Don't remove our origin cells please.
					cleared_cells |= clear

	// Get a list of all cells bordering a removed cell.
	var/list/neighbors = list()
	for(var/datum/mm_cell/cleared_cell in cleared_cells)
		cleared_cell.marked_for_cleanup = TRUE
		cleared_cell.marked_for_refresh = FALSE
		for(var/datum/mm_connection/connection in cleared_cell.template.cell_connections)
			var/nx = cleared_cell.cell_x + connection.offset_x + connection.target_x
			var/ny = cleared_cell.cell_y + connection.offset_y + connection.target_y
			var/ni = TRANSLATE_MODMAP_COORD(nx, ny, g_mx)
			if(ni <= 0 || ni > length(_grid))
				continue
			var/datum/mm_cell/neighbor = _grid[ni]
			if(!istype(neighbor) || (neighbor in cleared_cells))
				continue
			neighbors |= neighbor

	// Rebuild connections for all neighboring cells.
	for(var/datum/mm_cell/neighbor in neighbors)
		var/mark_cells = FALSE
		var/list/neighbor_conns = neighbor.get_open_connections()
		for(var/datum/mm_connection/connection in neighbor.template.cell_connections)
			if(connection in neighbor_conns)
				continue
			var/cx = neighbor.cell_x + connection.offset_x + connection.target_x
			var/cy = neighbor.cell_y + connection.offset_y + connection.target_y
			var/ci = TRANSLATE_MODMAP_COORD(cx, cy, g_mx)
			if(ci <= 0 || ci > length(_grid))
				continue
			var/datum/mm_cell/conn_target = _grid[ci]
			if(!istype(conn_target) || conn_target.marked_for_cleanup)
				neighbor.open_connection(connection)
				mark_cells = TRUE
			if(!(connection.connection_flags & (MCF_BLOCKER)))
				LAZYADD(., new /datum/mm_node(neighbor, connection, neighbor.generation+1))

		if(mark_cells)
			// Mark all cells related to this one as marked for refresh.
			var/datum/mm_cell/mark_from_cell = neighbor.owner || neighbor
			for(var/nx in mark_from_cell.cell_x to mark_from_cell.cell_x+mark_from_cell.template.cell_width-1)
				for(var/ny in mark_from_cell.cell_y to mark_from_cell.cell_y+mark_from_cell.template.cell_height-1)
					var/ni = TRANSLATE_MODMAP_COORD(nx, ny, g_mx)
					if(ni > 0 && ni <= length(_grid))
						var/datum/mm_cell/subneighbor = _grid[ni]
						if(istype(subneighbor) && !subneighbor.marked_for_cleanup)
							subneighbor.marked_for_refresh = TRUE

	// Clean up the removed cells.
	QDEL_NULL_LIST(cleared_cells)

/datum/mm_run/proc/resolve_isolated_paths()

	// Get our existing cells (discard nulls)
	var/list/ungrouped_cells = list()
	for(var/datum/mm_cell/cell in _grid)
		ungrouped_cells += cell

	var/last_longest_path = 0
	var/datum/mm_path/longest_path

	// Identify connected paths.
	var/list/grouped_cells = list()
	while(length(ungrouped_cells))

		var/list/connected_cells = list()
		var/current_cell = ungrouped_cells[1]
		ungrouped_cells -= current_cell

		var/list/potential_cells = list(current_cell)
		while(length(potential_cells))

			// Update tracking lists.
			var/datum/mm_cell/check_cell = potential_cells[1]
			potential_cells -= check_cell
			ungrouped_cells -= check_cell
			connected_cells |= check_cell
			grouped_cells   |= check_cell

			// Multicell templates behave oddly in terms of connections, treat them as a block.
			if(check_cell.owner && (check_cell.owner.template.cell_width > 1 || check_cell.owner.template.cell_height > 1))
				for(var/cx = check_cell.owner.cell_x to check_cell.owner.cell_x + check_cell.owner.template.cell_width-1)
					for(var/cy = check_cell.owner.cell_y to check_cell.owner.cell_y + check_cell.owner.template.cell_height-1)
						var/ci = TRANSLATE_MODMAP_COORD(cx, cy, g_mx)
						var/datum/mm_cell/block_cell = _grid[ci]
						if(istype(block_cell) && !(block_cell in grouped_cells))
							potential_cells |= block_cell

			// Check our non-dummy connections for accessible cells.
			for(var/datum/mm_connection/connection in check_cell.all_connections)
				// Ignore dummy connections.
				if(connection.connection_flags & MCF_BLOCKER)
					continue
				var/nx = check_cell.cell_x + connection.offset_x + connection.target_x
				var/ny = check_cell.cell_y + connection.offset_y + connection.target_y
				var/ni = TRANSLATE_MODMAP_COORD(nx, ny, g_mx)
				if(nx >= 0 && ny >= 0 && nx <= g_mx && ny <= g_my && ni > 0 && ni <= length(_grid))
					var/datum/mm_cell/neighbor = _grid[ni]
					if(istype(neighbor))
						LAZYSET(check_cell.finalized_connections, connection.direction_string, neighbor)
						LAZYSET(neighbor.finalized_connections, connection.reverse_direction_string, check_cell)
						if(!(neighbor in grouped_cells))
							potential_cells |= neighbor

		var/datum/mm_path/path = new(connected_cells, generator.mandatory_templates)
		LAZYADD(., path)
		if(length(connected_cells) > last_longest_path)
			longest_path = path
			last_longest_path = length(connected_cells)

	for(var/datum/mm_path/path in .)
		if(path.has_origin || path == longest_path)
			continue
		for(var/datum/mm_cell/cell in path.cells)
			clear_cell(cell)
		LAZYREMOVE(., path)
		qdel(path)

// Returns a string indicating the reason for failing validation.
/datum/mm_run/proc/validate_run(list/_paths)
	if(generator.do_trim_trailing_connections && get_dangling_connection_count())
		return "Map has dangling connections after cleanup passes."
	if(generator.min_path_length > 0)
		var/has_long_path = FALSE
		for(var/datum/mm_path/path in _paths)
			if(length(path.cells) >= generator.min_path_length)
				has_long_path = TRUE
				break
		if(!has_long_path)
			return "Map has no path of sufficient length ([generator.min_path_length] cell\s)"
	if(length(_paths) > generator.maximum_paths)
		return "Map has [length(_paths)]/[generator.maximum_paths] path\s.)"
	return null

/datum/mm_run/proc/finalize_run()

	log_debug("Built [generator.name] in [(world.time - gen_started)/10] second\s.")
	gen_started = world.time

	if(!apply_to_game_world())
		log_debug("Failed to place and finalize [generator.name] in [(world.time - gen_started)/10] second\s.")
		return FALSE

	log_debug("Placed [generator.name] in [(world.time - gen_started)/10] second\s.")
	gen_started = world.time
	post_run()
	log_debug("Finalized [generator.name] in [(world.time - gen_started)/10] second\s.")
	return TRUE

// Returns the z-level the map was applied to.
/datum/mm_run/proc/apply_to_game_world()


	// Increase the world height if needed.
	while(world.maxz < g_pz)
		SSmapping.increment_world_z_size(generator.level_data_type)

	// Keep track of load operations to run after we finalize our map.
	load_operations = list()
	var/g_cs = generator.grid_cell_size
	var/list/debug_targets = list()

	for(var/gx = 0 to g_mx)
		for(var/gy = 0 to g_my)

			var/index = TRANSLATE_MODMAP_COORD(gx, gy, g_mx)
			if(index < 1 || index > length(_grid) || !istype(_grid[index], /datum/mm_cell))

				if(generator.place_debug_markers)
					var/turf/debug_turf = locate(
						generator.border_x + (gx * g_cs) + (g_cs / 2),
						generator.border_y + (gy * g_cs) + (g_cs / 2),
						g_pz
					)
					if(istype(debug_turf) && !(debug_turf in debug_targets))
						var/obj/map_debug_holder/marker = new
						marker.maptext = "<center>[gx],[gy] - no cell</center>"
						marker.color = COLOR_PURPLE

				continue

			var/datum/mm_cell/cell = _grid[index]
			if(!istype(cell) || !cell.template)
				continue

			var/turf/cell_origin  = locate(
				generator.border_x + (cell.cell_x * g_cs),
				generator.border_y + (cell.cell_y * g_cs),
				g_pz
			)

			if(istype(cell_origin))
				if(!cell.owner) // Don't try to load filler cells.
					load_operations[cell_origin] = cell.template
				if(generator.place_debug_markers)
					var/turf/debug_turf = locate(
						cell_origin.x + (g_cs / 2),
						cell_origin.y + (g_cs / 2),
						g_pz
					)
					if(istype(debug_turf) && !(debug_turf in debug_targets))
						var/obj/map_debug_holder/marker = new(null, cell)
						marker.maptext = "<center>[cell.cell_x],[cell.cell_y] - #[cell.generation]</center>"
						if(cell.marked_for_refresh)
							marker.icon_state = "x2"
						else if(cell.marked_for_cleanup)
							marker.icon_state = "x3"
						debug_targets[debug_turf] = marker

		CHECK_TICK

	if(!length(load_operations))
		log_debug("No load operations (grid count is [get_grid_count()]).")
		return FALSE

	global._gag_report_progress++ // disable template load subsystem spam.
	try
		var/announced = FALSE
		for(var/turf/load_turf in load_operations)
			var/datum/map_template/template = load_operations[load_turf]
			template.load(load_turf)
			if(!announced)
				announced = TRUE
				admin_notice("<span class='boldannounce'>Placed modular generated map (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[load_turf.x];Y=[load_turf.y];Z=[load_turf.z]'>JMP</a>)</span>", R_DEBUG)
				log_debug("Placed modular generated map at [load_turf.x],[load_turf.y],[load_turf.z]")
	catch(var/exception/E)
		log_error("Exception during final DMMS load of [type]: [EXCEPTION_TEXT(E)]")
	global._gag_report_progress-- // enable subsystem spam.

	if(length(debug_targets))
		for(var/turf/mark_turf in debug_targets)
			var/obj/marker = debug_targets[mark_turf]
			marker.forceMove(mark_turf)
		debug_targets.Cut()

	return g_pz

/datum/mm_run/proc/post_run()
	//QDEL_NULL_LIST(grid)

	// Apply 'dumb' random maps.
	for(var/gen_type in generator.post_run_generators)
		new gen_type(1, 1, g_pz, world.maxx, world.maxy, FALSE, TRUE)

	// DMMS and mapload alters wall connection behavior, give it a poke to ensure they blend correctly.
	for(var/turf/turf as anything in block(locate(generator.border_x, generator.border_y, g_pz), locate(world.maxx-generator.border_x, world.maxy-generator.border_y, g_pz)))
		if(!turf.simulated)
			continue
		if(istype(turf, /turf/wall))
			var/turf/wall/wall = turf
			wall.update_material(FALSE)
		else
			turf.update_icon()

/datum/mm_run/proc/get_grid_count()
	. = 0
	for(var/datum/mm_cell/cell in _grid)
		.++
