/mob/living/exosuit/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."

/mob/living/exosuit/premade/combat/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/combat/painted(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/combat/painted(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/combat/painted(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/combat/painted(src)

	. = ..()

/mob/living/exosuit/premade/combat/spawn_mech_equipment()
	..()
	install_system(new /obj/item/mech_equipment/mounted_system/taser(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/projectile/assault_rifle(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/flash(src), HARDPOINT_LEFT_SHOULDER)
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_RIGHT_SHOULDER)

/mob/living/exosuit/premade/combat/military
	decal = "cammo1"

/mob/living/exosuit/premade/combat/military/alpine
	decal = "cammo2"

/mob/living/exosuit/premade/combat/military/Initialize()
	. = ..()
	for(var/obj/thing in list(arms,legs,head,body))
		thing.color = COLOR_WHITE

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "combat_arms"
	melee_damage = 5
	action_delay = 10
	power_use = 50

/obj/item/mech_component/manipulators/combat/painted
	color = COLOR_DARK_GUNMETAL

/obj/item/mech_component/propulsion/combat
	name = "combat legs"
	exosuit_desc_string = "sleek hydraulic legs"
	icon_state = "combat_legs"
	move_delay = 3
	turn_delay = 3
	power_use = 20

/obj/item/mech_component/propulsion/combat/painted
	color = COLOR_DARK_GUNMETAL

/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution thermal sensors"
	icon_state = "combat_head"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 200
	material = /decl/material/solid/metal/steel

/obj/item/mech_component/sensors/combat/painted
	color = COLOR_DARK_GUNMETAL

/obj/item/mech_component/sensors/combat/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	exosuit_desc_string = "an armoured chassis"
	icon_state = "combat_body"
	power_use = 40
	material = /decl/material/solid/metal/steel

/obj/item/mech_component/chassis/combat/painted
	color = COLOR_DARK_GUNMETAL

/obj/item/mech_component/chassis/combat/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/combat/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()

/obj/structure/mech_wreckage/military
	name = "military exosuit wreckage"
	loot_pool = list(
		/obj/item/mech_equipment/mounted_system/taser =        80,
		/obj/item/mech_equipment/mounted_system/taser/ion =    80,
		/obj/item/mech_equipment/flash =                       50,
		/obj/item/mech_equipment/light =                       50,
		/obj/item/mech_component/manipulators/combat/painted = 40,
		/obj/item/mech_component/propulsion/combat/painted =   40,
		/obj/item/mech_component/sensors/combat/painted =      40,
		/obj/item/mech_component/chassis/combat/painted =      40
	)
