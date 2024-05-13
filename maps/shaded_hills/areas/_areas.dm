/area/shaded_hills
	abstract_type = /area/shaded_hills
	icon = 'maps/shaded_hills/areas/icons.dmi'
	icon_state = "area"
	base_turf = /turf/floor/natural/rock/basalt
	fishing_failure_prob = 5
	fishing_results = list(
		/mob/living/simple_animal/aquatic/fish               = 10,
		/mob/living/simple_animal/aquatic/fish/grump         = 10,
		/obj/item/mollusc                                    = 5,
		/obj/item/mollusc/barnacle/fished                    = 5,
		/obj/item/mollusc/clam/fished/pearl                  = 3,
		/obj/item/trash/mollusc_shell/clam                   = 1,
		/obj/item/trash/mollusc_shell/barnacle               = 1,
		/obj/item/remains/mouse                              = 1,
		/obj/item/remains/lizard                             = 1,
		/obj/item/stick                                      = 1,
		/obj/item/trash/mollusc_shell                        = 1,
	)
	var/list/additional_fishing_results

/area/shaded_hills/Initialize()
	if(additional_fishing_results)
		for(var/fish in additional_fishing_results)
			fishing_results[fish] = additional_fishing_results[fish]
	. = ..()

/area/shaded_hills/outside
	name = "\improper Grasslands"
	color = COLOR_GREEN
	is_outside = OUTSIDE_YES
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)
	description = "Birds and insects call from the grasses, and a cool wind gusts from across the river."
	area_blurb_category = /area/shaded_hills/outside
	interior_ambient_light_modifier = -0.3

