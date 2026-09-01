// A connected sequence of cells (a route through the dungeon)
/datum/mm_path
	var/list/cells
	var/has_origin

/datum/mm_path/New(list/_cells, _origin_templates)
	cells = _cells
	for(var/datum/mm_cell/cell in cells)
		if(cell.template in _origin_templates)
			has_origin = TRUE
		cell.path = src
	..()

/datum/mm_path/Destroy(force)
	cells = null
	return ..()
