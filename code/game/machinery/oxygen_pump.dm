#define TANK_MAX_RELEASE_PRESSURE (3 ATM)
#define TANK_DEFAULT_RELEASE_PRESSURE ONE_ATMOSPHERE

/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/walllocker.dmi'
	desc = "A wall mounted oxygen pump with a retractable face mask that you can pull over your face in case of emergencies."
	icon_state = "emerg"

	anchored = TRUE

	var/obj/item/tank/tank
	var/mob/living/carbon/breather
	var/obj/item/clothing/mask/breath/contained

	var/spawn_type = /obj/item/tank/emergency/oxygen/engi
	var/mask_type = /obj/item/clothing/mask/breath/emergency
	var/icon_state_open = "emerg_open"
	var/icon_state_closed = "emerg"

	power_channel = ENVIRON
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.
	directional_offset = "{'NORTH':{'y':-24}, 'SOUTH':{'y':28}, 'EAST':{'x':24}, 'WEST':{'x':-24}}"

/obj/machinery/oxygen_pump/Initialize()
	. = ..()
	tank = new spawn_type (src)
	contained = new mask_type (src)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		breather.set_internals(null)
	if(tank)
		qdel(tank)
	if(breather)
		breather.drop_from_inventory(contained)
		src.visible_message(SPAN_NOTICE("The mask rapidly retracts just before /the [src] is destroyed!"))
	qdel(contained)
	contained = null
	breather = null
	return ..()

/obj/machinery/oxygen_pump/handle_mouse_drop(var/atom/over, var/mob/user)
	if(ishuman(over) && can_apply_to_target(over, user))
		user.visible_message(SPAN_NOTICE("\The [user] begins placing the mask onto \the [over].."))
		if(do_mob(user, over, 25) && can_apply_to_target(over, user))
			user.visible_message(SPAN_NOTICE("\The [user] has placed \the [src] over \the [over]'s face."))
			attach_mask(over)
			add_fingerprint(user)
		return TRUE
	. = ..()

/obj/machinery/oxygen_pump/physical_attack_hand(mob/user)
	if((stat & MAINT) && tank)
		user.visible_message(SPAN_NOTICE("\The [user] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
		user.put_in_hands(tank)
		src.add_fingerprint(user)
		tank.add_fingerprint(user)
		tank = null
		return TRUE
	if(breather)
		detach_mask(user)
		return TRUE

/obj/machinery/oxygen_pump/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/oxygen_pump/proc/attach_mask(var/mob/living/carbon/C)
	if(C && istype(C))
		contained.dropInto(C.loc)
		C.equip_to_slot(contained, slot_wear_mask_str)
		if(tank)
			tank.forceMove(C)
		breather = C

/obj/machinery/oxygen_pump/proc/set_internals(var/mob/living/carbon/C)
	if(C && istype(C))
		if(!C.internal && tank)
			breather.set_internals(tank)
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/oxygen_pump/proc/detach_mask(mob/user)
	if(tank)
		tank.forceMove(src)
	breather.drop_from_inventory(contained, src)
	if(user)
		visible_message(SPAN_NOTICE("\The [user] detaches \the [contained] and it rapidly retracts back into \the [src]!"))
	else
		visible_message(SPAN_NOTICE("\The [contained] rapidly retracts back into \the [src]!"))
	if(breather.internals)
		breather.internals.icon_state = "internal0"
	breather = null
	update_use_power(POWER_USE_IDLE)

/obj/machinery/oxygen_pump/proc/can_apply_to_target(var/mob/living/carbon/human/target, mob/user)
	if(!user)
		user = target
	// Check target validity
	if(!GET_EXTERNAL_ORGAN(target, BP_HEAD))
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a head."))
		return
	if(!target.check_has_mouth())
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a mouth."))
		return

	var/obj/item/mask = target.get_equipped_item(slot_wear_mask_str)
	if(mask && target != breather)
		to_chat(user, SPAN_WARNING("\The [target] is already wearing a mask."))
		return
	var/obj/item/head = target.get_equipped_item(slot_head_str)
	if(head && (head.body_parts_covered & SLOT_FACE))
		to_chat(user, SPAN_WARNING("Remove their [head] first."))
		return
	if(!tank)
		to_chat(user, SPAN_WARNING("There is no tank in \the [src]."))
		return
	if(stat & MAINT)
		to_chat(user, SPAN_WARNING("Please close the maintenance hatch first."))
		return
	if(!Adjacent(target))
		to_chat(user, SPAN_WARNING("Please stay close to \the [src]."))
		return
	//when there is a breather:
	if(breather && target != breather)
		to_chat(user, SPAN_WARNING("The pump is already in use."))
		return
	//Checking if breather is still valid
	mask = target.get_equipped_item(slot_wear_mask_str)
	if(target == breather && (!mask || mask != contained))
		to_chat(user, SPAN_WARNING("\The [target] is not using the supplied mask."))
		return
	return 1

/obj/machinery/oxygen_pump/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		stat ^= MAINT
		user.visible_message(SPAN_NOTICE("\The [user] [stat & MAINT ? "opens" : "closes"] \the [src]."), SPAN_NOTICE("You [stat & MAINT ? "open" : "close"] \the [src]."))
		if(stat & MAINT)
			icon_state = icon_state_open
		if(!stat)
			icon_state = icon_state_closed
		//TO-DO: Open icon
	if(istype(W, /obj/item/tank) && (stat & MAINT))
		if(tank)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank installed!"))
		else
			if(!user.try_unequip(W, src))
				return
			tank = W
			user.visible_message(SPAN_NOTICE("\The [user] installs \the [tank] into \the [src]."), SPAN_NOTICE("You install \the [tank] into \the [src]."))
			src.add_fingerprint(user)
	if(istype(W, /obj/item/tank) && !stat)
		to_chat(user, SPAN_WARNING("Please open the maintenance hatch first."))

/obj/machinery/oxygen_pump/examine(mob/user)
	. = ..()
	if(tank)
		to_chat(user, "The meter shows [round(tank.air_contents.return_pressure())].")
	else
		to_chat(user, SPAN_WARNING("It is missing a tank!"))


/obj/machinery/oxygen_pump/Process()
	if(breather)
		if(!can_apply_to_target(breather))
			detach_mask()
		else if(!breather.internal && tank)
			set_internals(breather)


//Create rightclick to view tank settings
/obj/machinery/oxygen_pump/verb/settings()
	set src in oview(1)
	set category = "Object"
	set name = "Show Tank Settings"
	ui_interact(usr)

//GUI Tank Setup
/obj/machinery/oxygen_pump/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	if(!tank)
		to_chat(usr, SPAN_WARNING("It is missing a tank!"))
		data["tankPressure"] = 0
		data["releasePressure"] = 0
		data["defaultReleasePressure"] = 0
		data["maxReleasePressure"] = 0
		data["maskConnected"] = 0
		data["tankInstalled"] = 0
	// this is the data which will be sent to the ui
	if(tank)
		data["tankPressure"] = round(tank.air_contents.return_pressure() ? tank.air_contents.return_pressure() : 0)
		data["releasePressure"] = round(tank.distribute_pressure ? tank.distribute_pressure : 0)
		data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
		data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
		data["maskConnected"] = 0
		data["tankInstalled"] = 1

	if(!breather)
		data["maskConnected"] = 0
	if(breather)
		data["maskConnected"] = 1


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "Oxygen_pump.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/oxygen_pump/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			tank.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			tank.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			tank.distribute_pressure += cp
		tank.distribute_pressure = min(max(round(tank.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
		return 1
