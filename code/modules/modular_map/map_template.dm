/datum/map_template/modular
	abstract_type = /datum/map_template/modular
	is_spawnable = FALSE // Do not bloat out the map placement list.

	/// A list of cell coordinates linking to directions linking to connection types from that point.
	/// ex. "1_1" = list("NORTH" = (MCF_ROOM))
	var/list/cell_connections
	/// A bitflag indicating the type of connections that can be formed to this room.
	var/connection_flag = MCF_ROOM
	/// How many cells wide is this room?
	var/cell_width = 1
	/// How many cells long is this room?
	var/cell_height = 1
	/// Whether or not this template caps off a path (has one or less non-dummy connections)
	var/is_terminator = FALSE

/datum/map_template/modular/New()

	..()

	var/conn_count = 0
	for(var/datum/mm_connection/connection in cell_connections)
		if(!(connection.connection_flags & (MCF_BLOCKER)))
			conn_count++
	is_terminator = conn_count <= 1

	var/list/existing_coords = list()
	for(var/datum/mm_connection/connection in cell_connections)
		connection.template = src
		var/coord = "[connection.offset_x]_[connection.offset_y]"
		LAZYINITLIST(existing_coords[coord])
		LAZYDISTINCTADD(existing_coords[coord], connection.direction_string)

	// Fill in any outward-facing cell faces with dummy
	// connections to enable connection logic later.
	var/w = cell_width-1
	var/z = cell_height-1
	for(var/x = 0 to w)

		if(x != 0 && x != w)
			continue

		for(var/y = 0 to z)

			if(y != 0 && y != z)
				continue

			var/list/connection_dirs = list()
			if(x == 0)
				connection_dirs += "WEST"
			if(x == w)
				connection_dirs += "EAST"
			if(y == 0)
				connection_dirs += "SOUTH"
			if(y == z)
				connection_dirs += "NORTH"

			var/coord = "[x]_[y]"
			for(var/connection_dir in connection_dirs)
				if(connection_dir in existing_coords[coord])
					continue
				var/datum/mm_connection/new_conn = new(connection_dir, x, y, (MCF_BLOCKER))
				new_conn.template = src
				cell_connections += new_conn
