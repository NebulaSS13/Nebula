// A single square on the dungeon map grid. Some map templates cover multiple cells.
/datum/mm_cell
	var/cell_x
	var/cell_y
	var/offset_x
	var/offset_y
	var/datum/mm_cell/owner
	var/datum/map_template/modular/template
	var/generation
	var/marked_for_cleanup
	var/marked_for_refresh

	VAR_PRIVATE/list/_open_connections
	VAR_PRIVATE/list/_all_connections

/datum/mm_cell/Destroy()
	LAZYCLEARLIST(_open_connections)
	template = null
	return ..()

/datum/mm_cell/New(datum/mm_run/_run, _x, _y, _template, datum/mm_cell/_owner, _generation, _ox, _oy)
	cell_x      = _x
	cell_y      = _y
	offset_x    = _ox
	offset_y    = _oy
	template    = _template
	generation  = _generation
	owner       = _owner
	// Initially assume all non-internal connections are freed; cell placement logic will close connections that are blocked by our placement.
	for(var/datum/mm_connection/connection in template.cell_connections)
		if(connection.offset_x == _ox && connection.offset_y == _oy)
			LAZYDISTINCTADD(_all_connections, connection)
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
	if(connection in _all_connections)
		LAZYDISTINCTADD(_open_connections, connection)
