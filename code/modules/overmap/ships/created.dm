/obj/effect/overmap/visitable/ship/landable/created/Initialize(mapload, ship_name, ship_color, ship_dir)
	if(ship_name)
		name = ship_name
		shuttle = ship_name

	if(ship_color)
		color = ship_color

	if(ship_dir)
		fore_dir = ship_dir

	. = ..(mapload)