/obj/effect/overmap/visitable/ship/landable/created/Initialize(mapload, ship_name, ship_color)
	name = ship_name
	shuttle = ship_name

	if(ship_color) color = ship_color
	. = ..(mapload)
	