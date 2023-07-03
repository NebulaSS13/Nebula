/obj/machinery/street
	layer = ABOVE_HUMAN_LAYER
	light_range = 4
	light_power = 2
	light_color = "#59ff9b"

/obj/machinery/street/traffic
	name = "traffic light"
	anchored = 1
	density = 1
	luminosity = 3

	icon = 'mods/content/modern_nights/icons/obj/traffic.dmi'
	icon_state = "streetlight-ani"


/obj/machinery/street/pedestrian
	name = "pedestrian signal"
	anchored = 1
	density = 1
	luminosity = 3
	icon = 'mods/content/modern_nights/icons/obj/pedestrian.dmi'
	icon_state = "pede-ani"

/obj/vehicle/bike/electric/street
	engine_type = /obj/item/engine/electric
	prefilled = 1
	land_speed = 1.5
	space_speed = 0
	trail = null