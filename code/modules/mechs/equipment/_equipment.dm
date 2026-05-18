// Defining all of this here so it's centralized.
// Used by the exosuit HUD to get a 1-10 value representing charge, ammo, etc.
/obj/item/mech_equipment
	name = "exosuit hardpoint system"
	icon = 'icons/mecha/mech_equipment.dmi'
	icon_state = ""
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/osmium = MATTER_AMOUNT_TRACE
	)
	_base_attack_force = 10

	var/list/restricted_hardpoints
	var/mob/living/exosuit/owner
	var/list/restricted_software
	var/equipment_delay = 0
	var/active_power_use = 1 KILOWATTS // How much does it consume to perform and accomplish usage
	var/passive_power_use = 0          // For gear that for some reason takes up power even if it's supposedly doing nothing (mech will idly consume power)
	var/mech_layer = MECH_GEAR_LAYER //For the part where it's rendered as mech gear
	var/require_adjacent = TRUE
	var/active = FALSE //For gear that has an active state (ie, floodlights)

/obj/item/mech_equipment/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/mech_equipment/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	if(require_adjacent)
		if(!inrange)
			return FALSE
	if (owner && loc == owner && ((user in owner.pilots) || user == owner))
		if(target in owner.contents)
			return FALSE
		if(!(owner.get_cell()?.check_charge(active_power_use * CELLRATE)))
			to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to use \the [src]."))
			return FALSE
		return TRUE
	return FALSE

// Per base attack_self(), return TRUE on an action performed (ie. no further action done) and FALSE to continue action.
/obj/item/mech_equipment/attack_self(var/mob/user)
	if(!owner || loc != owner || (!(user in owner.pilots) && user != owner))
		return TRUE
	if(!(owner.get_cell()?.check_charge(active_power_use * CELLRATE)))
		to_chat(user, SPAN_WARNING("The power indicator flashes briefly as you attempt to use \the [src]."))
		return TRUE
	return FALSE

/obj/item/mech_equipment/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(user.skill_check(SKILL_DEVICES, SKILL_BASIC))
		if(length(restricted_software))
			. += SPAN_SUBTLE("It seems it would require [english_list(restricted_software)] to be used.")
		if(length(restricted_hardpoints))
			. += SPAN_SUBTLE("You figure it could be mounted in the [english_list(restricted_hardpoints)].")

/obj/item/mech_equipment/proc/deactivate()
	active = FALSE
	return

/obj/item/mech_equipment/proc/installed(var/mob/living/exosuit/_owner)
	owner = _owner
	//generally attached. Nothing should be able to grab it
	canremove = FALSE

/obj/item/mech_equipment/proc/uninstalled()
	if(active)
		deactivate()
	owner = null
	canremove = TRUE

/obj/item/mech_equipment/proc/get_effective_obj()
	return src

/obj/item/mech_equipment/proc/MouseDragInteraction()
	return 0

/obj/item/mech_equipment/proc/MouseDownInteraction()
	return 0

/obj/item/mech_equipment/proc/MouseUpInteraction()
	return 0

/obj/item/mech_equipment/mob_can_unequip(mob/user, slot, disable_warning = FALSE, dropping = FALSE)
	. = ..()
	if(. && owner)
		//Installed equipment shall not be unequiped.
		return FALSE

/obj/item/proc/get_hardpoint_status_value()
	return null

/obj/item/proc/get_hardpoint_maptext()
	return null

/obj/item/mech_equipment/mounted_system/get_cell()
	if(owner && loc == owner)
		return owner.get_cell()
	return null
