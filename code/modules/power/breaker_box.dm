// Updated version of old powerswitch by Atlantis
// Has better texture, and is now considered electronic device
// Requires 5 seconds to toggle and can be toggled once a minute
// Used for advanced grid control (read: Substations)

/obj/machinery/power/breakerbox
	name = "breaker box"
	icon = 'icons/obj/power.dmi'
	icon_state = "bbox_off"
	desc = "A large machine with heavy-duty switching circuits used for advanced grid control."
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = 0
	uncreated_component_parts = null
	base_type = /obj/machinery/power/breakerbox

	var/icon_state_on = "bbox_on"
	var/icon_state_off = "bbox_off"
	var/on = FALSE
	var/busy = FALSE
	var/RCon_tag = "NO_TAG"
	/// If world.time < lock_time, system is locked for interactions.
	var/lock_time = 0

/obj/machinery/power/breakerbox/activated
	icon_state = parent_type::icon_state_on

	// Enabled on server startup. Used in substations to keep them in bypass mode.
/obj/machinery/power/breakerbox/activated/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/breakerbox/activated/LateInitialize()
	set_state(TRUE)
	. = ..()

/obj/machinery/power/breakerbox/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(on)
		. += SPAN_GOOD("It seems to be online.")
	else
		. += SPAN_WARNING("It seems to be offline.")

/obj/machinery/power/breakerbox/proc/try_toggle_state(mob/living/user, digital = FALSE)
	if(lock_time < world.time)
		to_chat(user, SPAN_WARNING("System locked. Please try again later."))
		return TRUE

	if(busy)
		to_chat(user, SPAN_WARNING("System is busy. Please wait until current operation is finished before changing power settings."))
		return TRUE

	busy = TRUE
	if(digital)
		to_chat(user, SPAN_GOOD("Updating power settings..."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] starts reprogramming \the [src]!"))
	if(do_after(user, 5 SECONDS, src))
		set_state(!on)
		if(digital)
			to_chat(user, SPAN_GOOD("Update completed. New setting:[on ? "on": "off"]"))
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] [on ? "enabled" : "disabled"] \the [src]!"),\
				SPAN_NOTICE("You [on ? "enabled" : "disabled"] \the [src]!"))
		lock_time = world.time + 1 MINUTE
	busy = FALSE
	return TRUE

/obj/machinery/power/breakerbox/attack_ai(mob/living/silicon/ai/user)
	return try_toggle_state(user, digital = TRUE)

/obj/machinery/power/breakerbox/physical_attack_hand(mob/user)
	return try_toggle_state(user, digital = FALSE)

/obj/machinery/power/breakerbox/attackby(obj/item/used_item, mob/user)
	if(IS_MULTITOOL(used_item))
		var/newtag = input(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system") as text
		if(!CanPhysicallyInteract(user))
			return TRUE
		if(newtag)
			RCon_tag = newtag
			to_chat(user, SPAN_NOTICE("You changed the RCON tag to: [newtag]"))
		return TRUE
	return ..()

/obj/machinery/power/breakerbox/on_update_icon()
	. = ..()
	icon_state = on ? icon_state_on : icon_state_off

/obj/machinery/power/breakerbox/proc/set_state(state)
	on = state
	update_icon()
	if(on)
		var/list/connection_dirs = list()
		for(var/direction in global.alldirs)
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.update_icon()
			C.breaker_box = src

			var/datum/powernet/PN = new()
			PN.add_cable(C)

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

			if(!IS_POWER_OF_TWO(C.d2))// if the cable is layed diagonally, check the others 2 possible directions
				C.mergeDiagonalsNetworks(C.d2)

	else
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)

// Used by RCON to toggle the breaker box.
/obj/machinery/power/breakerbox/proc/auto_toggle()
	if(lock_time > world.time)
		return FALSE // still on cooldown
	set_state(!on)
	lock_time = world.time + 1 MINUTE
