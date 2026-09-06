// Essentially a bare platform that moves up and down.
/obj/abstract/turbolift_spawner/tradeship
	name = "Tradeship cargo elevator placeholder"
	icon = 'mods/content/turbolift/icons/turbolift_preview_nowalls_4x4.dmi'
	depth = 4
	lift_size_x = 3
	lift_size_y = 3
	door_type =     null
	wall_type =     null
	firedoor_type = null
	light_type =    null
	floor_type =  /turf/floor/tiled/steel_grid
	button_type = /obj/structure/lift/button/standalone
	panel_type =  /obj/structure/lift/panel/standalone
	areas_to_use = list(
		/area/turbolift/tradeship_enclave,
		/area/turbolift/tradeship_cargo,
		/area/turbolift/tradeship_upper,
		/area/turbolift/tradeship_roof
	)
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound =   'sound/effects/lift_heavy_stop.ogg'
