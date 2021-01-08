//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon = 'icons/obj/items/tanks/jetpack.dmi'
	gauge_icon = null
	w_class = ITEM_SIZE_HUGE
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect/effect/system/trail/ion/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = "{'materials':1,'engineering':3}"

/obj/item/tank/jetpack/Initialize()
	. = ..()
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)

/obj/item/tank/jetpack/Destroy()
	QDEL_NULL(ion_trail)
	. = ..()

/obj/item/tank/jetpack/examine(mob/living/user)
	. = ..()
	if(air_contents.total_moles < 5)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas!</span>")

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	to_chat(usr, "You toggle the stabilization [stabilization_on? "on":"off"].")

/obj/item/tank/jetpack/on_update_icon(override)
	cut_overlays()
	if(on)
		add_overlay("[icon_state]-on")

/obj/item/tank/jetpack/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/I = ..()
	if(I && slot == slot_back_str && on)
		I.icon_state = "[I.icon_state]-on"
	return I

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	if(on)
		ion_trail.start()
	else
		ion_trail.stop()
	update_icon()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	to_chat(usr, "You toggle the thrusters [on? "on":"off"].")

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user)
	if(!(src.on))
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = remove_air(num)

	if(G.total_moles >= 0.005)
		return 1

	qdel(G)

/obj/item/tank/jetpack/ui_action_click()
	toggle()


/obj/item/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon = 'icons/obj/items/tanks/jetpack_void.dmi'
	starting_pressure = list(/decl/material/gas/oxygen = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	starting_pressure = list(/decl/material/gas/oxygen = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	icon = 'icons/obj/items/tanks/jetpack_co2.dmi'
	distribute_pressure = 0
	starting_pressure = list(/decl/material/gas/carbon_dioxide = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/rig
	name = "jetpack"
	var/obj/item/rig/holder

/obj/item/tank/jetpack/rig/examine()
	. = ..()
	CRASH("A [name] was examined")

/obj/item/tank/jetpack/rig/allow_thrust(num, mob/living/user)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.remove_air(num)

	if(G.total_moles >= 0.005)
		return 1
	qdel(G)
