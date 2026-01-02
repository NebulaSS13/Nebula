
/obj/item/gun/energy/gun/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	if(!istype(src,/obj/item/gun/energy/gun/nuclear))
		return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)
	else return ..()

/obj/item/gun/energy/laser/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)

/obj/item/gun/energy/ionrifle/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)

/obj/item/gun/energy/taser/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)

/obj/item/gun/energy/sniperrifle/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)

/obj/item/gun/energy/captain/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell/unremovable, charge_value)

/obj/item/gun/energy/gun/nuclear/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell/unremovable, charge_value)


/obj/item/gun
	wieldsound = null
	unwieldsound = null

/obj/item/cell/gun
	desc = "A high-density battery, expected to deplete after a few hundred complete charge cycles."
	maxcharge = 2400 //Increased for more granularity + longer charge times

/obj/item/cell/gun/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "gunbattery_charge", gradient("#e2111c", "#9cdb43", clamp(percent(), 0, 100) )))

//Cell charge costs and refluff for base Neb types

/obj/item/gun/energy/gun
	desc = "Another bestseller of Lawson Arms, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: Stun, Shock or Kill."
	charge_cost = 240
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN, charge_cost = 240), //10
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW, charge_cost = 340), //7
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, indicator_color=COLOR_RED,charge_cost = 480), //5
		)

/obj/item/gun/energy/gun/small
	name = "subcompact energy gun"
	desc = "The LAEP90-C Perunika is a subcompact variant of the versatile Perun energy sidearm, for use by plainclothes security personnel with a desire for concealability."
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN, charge_cost = 240), // 10
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW, charge_cost = 340), //7
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/smalllaser,indicator_color=COLOR_RED,charge_cost = 480), //5
		)

/obj/item/gun/energy/sniperrifle
	name = "marksman energy rifle"
	desc = "The HI DMR 9E is an older design of Hephaestus Industries. A designated marksman rifle capable of shooting powerful \
	ionized beams, this is a weapon to kill from a distance."
	charge_cost = 600 //4


/obj/item/gun/energy/laser
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficient but weaker 'suppressive' fire."
	charge_cost = 240 //10
	firemodes = list(
		list(mode_name = "normal", fire_delay = 6, accuracy = 0, projectile_type = /obj/item/projectile/beam/midlaser, charge_cost = 240),
		list(mode_name = "suppressive", fire_delay = 0.6 SECONDS, accuracy = -2, projectile_type = /obj/item/projectile/beam/smalllaser, charge_cost = 60),
	)

/obj/item/gun/energy/laser/practice
	firemodes = list(
		list(mode_name = "normal", fire_delay = 6, accuracy = 0, projectile_type = /obj/item/projectile/beam/practice, charge_cost = 48),
		list(mode_name = "suppressive", fire_delay = 0.6 SECONDS, accuracy = -2, projectile_type = /obj/item/projectile/beam/practice, charge_cost = 12),
	)

/obj/item/gun/energy/laser/practice/handle_post_fire(atom/movable/firer, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(hacked())
		max_shots--
		if(!max_shots) //uh hoh gig is up
			to_chat(firer, SPAN_DANGER("\The [src] sizzles in your hands, acrid smoke rising from the firing end!"))
			desc += " The optical pathway is melted and useless."
			projectile_type = null
			firemodes = null

/obj/item/gun/energy/captain
	desc = "A rare weapon, produced by the Lunar Arms Company around 2105 - one of humanity's first wholly extra-terrestrial weapon designs. It's certainly aged well."
	charge_cost = 480 //5

/obj/item/gun/energy/lasercannon
	charge_cost = 600 //4

/obj/item/gun/energy/ionrifle
	desc = "The RayZar Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
	charge_cost = 240 //10

/obj/item/gun/energy/taser
	charge_cost = 480 //5
	desc = "The NT Mk30 NL is a small gun used for non-lethal takedowns. Produced by NT, it's actually a licensed version of a W-T RayZar design."