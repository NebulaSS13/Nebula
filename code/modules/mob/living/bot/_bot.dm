/mob/living/bot
	name = "Bot"
	max_health = 20
	icon = 'icons/mob/bot/placeholder.dmi'
	universal_speak = TRUE
	density = FALSE
	butchery_data = null
	ai = /datum/mob_controller/bot
	abstract_type = /mob/living/bot
	layer = HIDING_MOB_LAYER

	var/obj/item/card/id/botcard = null
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = 0
	var/light_strength = 3
	var/obj/access_scanner = null
	var/list/req_access = list()
	var/RequiresAccessToToggle = 0 // If 1, will check access to be turned on/off
	var/wait_if_pulled = 0 // Only applies to moving to the target

/mob/living/bot/Initialize()
	. = ..()
	update_icon()

	botcard = new /obj/item/card/id(src)
	botcard.access = get_initial_bot_access()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access?.Copy()

	if(on)
		turn_on() // Update lights and other stuff
	else
		turn_off()

/mob/living/bot/proc/get_initial_bot_access()
	return list()

/mob/living/bot/handle_regular_status_updates()
	. = ..()
	if(.)
		set_status(STAT_WEAK, 0)
		set_status(STAT_STUN, 0)
		set_status(STAT_PARA, 0)

/mob/living/bot/get_life_damage_types()
	var/static/list/life_damage_types = list(
		BURN,
		BRUTE
	)
	return life_damage_types

/mob/living/bot/get_dusted_remains()
	return /obj/effect/decal/cleanable/blood/oil

/mob/living/bot/gib(do_gibs = TRUE)
	if(stat != DEAD)
		death(gibbed = TRUE)
	if(stat == DEAD)
		turn_off()
		visible_message(SPAN_DANGER("\The [src] blows apart!"))
		spark_at(src, cardinal_only = TRUE)
	return ..()

/mob/living/bot/death(gibbed)
	. = ..()
	if(. && !gibbed)
		gib()

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)

	if(O.GetIdCard())
		if(access_scanner.allowed(user) && !open)
			locked = !locked
			to_chat(user, SPAN_NOTICE("Controls are now [locked ? "locked" : "unlocked"]."))
			Interact(usr)
		else if(open)
			to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	if(IS_SCREWDRIVER(O))
		if(!locked)
			open = !open
			to_chat(user, SPAN_NOTICE("Maintenance panel is now [open ? "opened" : "closed"]."))
			Interact(usr)
		else
			to_chat(user, SPAN_WARNING("You need to unlock the controls first."))
		return TRUE

	if(IS_WELDER(O))
		if(current_health < get_max_health())
			if(open)
				heal_overall_damage(10)
				user.visible_message(
					SPAN_NOTICE("\The [user] repairs \the [src]."),
					SPAN_NOTICE("You repair \the [src].")
				)
			else
				to_chat(user, SPAN_WARNING("Unable to repair with the maintenance panel closed."))
		else
			to_chat(user, SPAN_WARNING("\The [src] does not need a repair."))
		return TRUE

	return ..()

/mob/living/bot/attack_ai(var/mob/living/user)
	Interact(user)

/mob/living/bot/default_help_interaction(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	Interact(user)
	return TRUE

/mob/living/bot/default_interaction(mob/user)
	. = ..()
	if(!.)
		Interact(user)
		return TRUE

/mob/living/bot/proc/Interact(var/mob/user)
	add_fingerprint(user)
	var/dat

	var/curText = GetInteractTitle()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = GetInteractStatus()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessPanel(user)) ? GetInteractPanel() : "The access panel is locked."
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessMaintenance(user)) ? GetInteractMaintenance() : "The maintenance panel is locked."
	if(curText)
		dat += curText

	var/datum/browser/popup = new(user, "botpanel", "[src] controls")
	popup.set_content(dat)
	popup.open()

/mob/living/bot/DefaultTopicState()
	return global.default_topic_state

/mob/living/bot/OnTopic(mob/user, href_list)
	if(href_list["command"])
		ProcessCommand(user, href_list["command"], href_list)
	Interact(user)

/mob/living/bot/proc/GetInteractTitle()
	return

/mob/living/bot/proc/GetInteractStatus()
	. = "Status: <A href='byond://?src=\ref[src];command=toggle'>[on ? "On" : "Off"]</A>"
	. += "<BR>Behaviour controls are [locked ? "locked" : "unlocked"]"
	. += "<BR>Maintenance panel is [open ? "opened" : "closed"]"

/mob/living/bot/proc/GetInteractPanel()
	return

/mob/living/bot/proc/GetInteractMaintenance()
	return

/mob/living/bot/proc/ProcessCommand(var/mob/user, var/command, var/href_list)
	if(command == "toggle" && CanToggle(user))
		if(on)
			turn_off()
		else
			turn_on()
	return

/mob/living/bot/proc/CanToggle(var/mob/user)
	return (!RequiresAccessToToggle || access_scanner.allowed(user) || issilicon(user))

/mob/living/bot/proc/CanAccessPanel(var/mob/user)
	return (!locked || issilicon(user))

/mob/living/bot/proc/CanAccessMaintenance(var/mob/user)
	return (open || issilicon(user))

// Overrides default verb to 'beeps' instead of 'says'.
/mob/living/bot/say(message, decl/language/speaking, verb = "beeps", alt_name = "", whispering)
	return ..()

/mob/living/bot/Bump(var/atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/emag_act(var/remaining_charges, var/mob/user)
	return 0

/mob/living/bot/proc/turn_on()
	if(stat)
		return FALSE
	on = TRUE
	set_light(light_strength)
	if(ai)
		ai.clear_paths()
		ai.lose_target()
		ai.clear_friends()
	update_icon()
	return TRUE

/mob/living/bot/proc/turn_off()
	on = FALSE
	set_light(0)
	update_icon()

/mob/living/bot/GetIdCards(list/exceptions)
	. = ..()
	if(istype(botcard) && !is_type_in_list(botcard, exceptions))
		LAZYDISTINCTADD(., botcard)
