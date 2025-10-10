// A single square on the dungeon map grid. Some map templates cover multiple cells.
/datum/mm_cell
	var/cell_x
	var/cell_y
	var/datum/mm_cell/owner
	var/datum/map_template/modular/template
	var/generation
	var/marked_for_cleanup
	var/marked_for_refresh

	VAR_PRIVATE/list/_open_connections

/datum/mm_cell/Destroy()
	LAZYCLEARLIST(_open_connections)
	template = null
	return ..()

/datum/mm_cell/New(datum/mm_run/_run, _x, _y, _template, datum/mm_cell/_owner, _generation, _ox, _oy)
	cell_x      = _x
	cell_y      = _y
	template    = _template
	generation  = _generation
	owner       = _owner
	// Initially assume all non-internal connections are freed; cell placement logic will close connections that are blocked by our placement.
	// Note for future self that dummy connections do need to be considered open/closed in order to avoid unterminated rooms being
	// placed such that they 'connect' to blank walls.
	// Realising after writing this that it might be totally unnecessary as templates already don't generate internal connections. Ough.
	var/ox = _x - _ox
	var/oy = _y - _oy
	var/mx = ox + (template.cell_width-1)
	var/my = oy + (template.cell_height-1)
	for(var/datum/mm_connection/connection in template.cell_connections)
		if(connection.offset_x != _ox || connection.offset_y != _oy)
			continue
		var/tx = _x + connection.target_x
		var/ty = _y + connection.target_y
		if(tx < 0 || tx > _run.g_mx || ty < 0 || ty > _run.g_my)
			continue
		if((tx >= ox && tx < mx && ty >= oy && ty < my))
			continue
		open_connection(connection)

/datum/mm_cell/proc/get_open_connections(exclude_flags)
	if(isnull(exclude_flags))
		return _open_connections
	for(var/datum/mm_connection/connection as anything in _open_connections)
		if(connection.connection_flags & exclude_flags)
			continue
		LAZYADD(., connection)

/datum/mm_cell/proc/close_connection(connection)
	LAZYREMOVE(_open_connections, connection)

/datum/mm_cell/proc/open_connection(connection)
	LAZYDISTINCTADD(_open_connections, connection)
