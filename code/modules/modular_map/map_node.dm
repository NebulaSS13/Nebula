// A node represents an outgoing connection from a cell.
// The cell is the 'source' cell, whose position the connection will offset to reach the target cell.
/datum/mm_node
	var/generation
	var/datum/mm_cell/cell
	var/datum/mm_connection/connection

/datum/mm_node/New(_cell, _conn, _gen)
	cell       = _cell
	connection = _conn
	generation = _gen

/datum/mm_node/Destroy(force)
	cell = null
	connection = null
	return ..()
