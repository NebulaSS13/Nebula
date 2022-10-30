/mob/living/exosuit/premade/light/exploration
	name = "exploration mech"
	desc = "It looks a bit charred."

/obj/item/mech_component/manipulators/powerloader/exploration
	color = COLOR_PURPLE

/obj/item/mech_component/chassis/pod/exploration
	color = COLOR_GUNMETAL

/obj/item/mech_component/propulsion/tracks/exploration
	color = COLOR_GUNMETAL

/mob/living/exosuit/premade/light/exploration/Initialize()
	if(!body)
		body = new /obj/item/mech_component/chassis/pod/exploration(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/tracks/exploration(src)
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/powerloader/exploration(src)

	. = ..()

	//Damage it
	var/list/parts = list(arms,legs,head,body)
	var/obj/item/mech_component/damaged = pick(parts)
	damaged.take_burn_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)
	if(prob(33))
		parts -= damaged
		damaged = pick(parts)
		damaged.take_burn_damage((damaged.max_damage / 4 ) * MECH_COMPONENT_DAMAGE_DAMAGED)

/mob/living/exosuit/premade/light/exploration/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma(src), HARDPOINT_LEFT_HAND)

/obj/structure/mech_wreckage/exploration
	name = "exploration exosuit wreckage"
	loot_pool = list(
		/obj/item/mech_component/manipulators/powerloader/exploration = 40,
		/obj/item/mech_component/chassis/pod/exploration =              40,
		/obj/item/mech_component/propulsion/tracks/exploration =        40,
		/obj/item/mech_component/sensors/light/painted =                40,
		/obj/item/mech_equipment/light =                                50,
		/obj/item/mech_equipment/clamp =                                80,
		/obj/item/mech_equipment/mounted_system/taser/plasma =          80
	)
