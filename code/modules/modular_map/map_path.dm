// A connected sequence of cells (a route through the dungeon)
/datum/mm_path
	var/list/cells

/datum/mm_path/New(list/_cells)
	cells = _cells
	..()

/datum/mm_path/Destroy(force)
	cells = null
	return ..()
