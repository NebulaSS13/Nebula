/obj/item/magnetic_tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/items/device/tape_recorder/tape_casette_white.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE
	)
	_base_attack_force = 1
	var/max_capacity = 600
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = FALSE
	var/doctored = FALSE
	/// Whether we draw the ruined ribbon overlay when ruined.
	var/draw_ribbon_if_ruined = TRUE

/obj/item/magnetic_tape/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(draw_ribbon_if_ruined && ruined && max_capacity)
		add_overlay(overlay_image(icon, "[icon_state]_ribbonoverlay", flags = RESET_COLOR))

/obj/item/magnetic_tape/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ruin()
	return ..()

/obj/item/magnetic_tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, SPAN_NOTICE("You pull out all the tape!"))
		get_loose_tape(user, length(storedinfo))
		ruin()


/obj/item/magnetic_tape/proc/ruin()
	ruined = TRUE
	update_icon()


/obj/item/magnetic_tape/proc/fix()
	ruined = FALSE
	update_icon()


/obj/item/magnetic_tape/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[time2text(used_capacity SECONDS,"mm:ss")]\] [text]"


//shows up on the printed transcript as (Unrecognized sound)
/obj/item/magnetic_tape/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[time2text(used_capacity SECONDS,"mm:ss")]\] [text]"


/obj/item/magnetic_tape/attackby(obj/item/used_item, mob/user, params)
	if(user.incapacitated()) // TODO: this may not be necessary since OnClick checks before starting the attack chain
		return TRUE
	if(ruined && IS_SCREWDRIVER(used_item))
		if(!max_capacity)
			to_chat(user, SPAN_NOTICE("There is no tape left inside."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start winding the tape back in..."))
		if(do_after(user, 12 SECONDS, target = src))
			to_chat(user, SPAN_NOTICE("You wound the tape back in."))
			fix()
		return TRUE
	else if(IS_PEN(used_item))
		if(loc == user)
			var/new_name = input(user, "What would you like to label the tape?", "Tape labeling") as null|text
			if(isnull(new_name)) return TRUE
			new_name = sanitize_safe(new_name)
			if(new_name)
				SetName("tape - '[new_name]'")
				to_chat(user, SPAN_NOTICE("You label the tape '[new_name]'."))
			else
				SetName("tape")
				to_chat(user, SPAN_NOTICE("You scratch off the label."))
		return TRUE
	else if(IS_WIRECUTTER(used_item))
		cut(user)
		return TRUE
	else if(istype(used_item, /obj/item/magnetic_tape/loose))
		join(user, used_item)
		return TRUE
	return ..()

/obj/item/magnetic_tape/proc/cut(mob/user)
	if(!LAZYLEN(timestamp))
		to_chat(user, SPAN_NOTICE("There's nothing on this tape!"))
		return
	var/list/output = list("<center>")
	for(var/i in 1 to length(timestamp))
		var/time = "\[[time2text(timestamp[i] SECONDS,"mm:ss")]\]"
		output += "[time]<br><a href='byond://?src=\ref[src];cut_after=[i]'>-----CUT------</a><br>"
	output += "</center>"

	var/datum/browser/popup = new(user, "tape_cutting", "Cutting tape", 170, 600)
	popup.set_content(jointext(output,null))
	popup.open()

/obj/item/magnetic_tape/proc/join(mob/user, obj/item/magnetic_tape/other)
	if(max_capacity + other.max_capacity > initial(max_capacity))
		to_chat(user, SPAN_NOTICE("You can't fit this much tape in!"))
		return
	if(user.try_unequip(other))
		to_chat(user, SPAN_NOTICE("You join ends of the tape together."))
		max_capacity += other.max_capacity
		used_capacity = min(used_capacity + other.used_capacity, max_capacity)
		timestamp += other.timestamp
		storedinfo += other.storedinfo
		doctored = TRUE
		ruin()
		update_icon()
		qdel(other)

/obj/item/magnetic_tape/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["cut_after"])
		var/index = text2num(href_list["cut_after"])
		if(index >= length(timestamp))
			return

		to_chat(user, SPAN_NOTICE("You remove part of the tape."))
		get_loose_tape(user, index)
		cut(user)
		return TOPIC_REFRESH

//Spawns new loose tape item, with data starting from [index] entry
/obj/item/magnetic_tape/proc/get_loose_tape(var/mob/user, var/index)
	var/obj/item/magnetic_tape/loose/newtape = new()
	newtape.timestamp = timestamp.Copy(index+1)
	newtape.storedinfo = storedinfo.Copy(index+1)
	newtape.max_capacity = max_capacity - index
	newtape.used_capacity = max(0, used_capacity - max_capacity)
	newtape.doctored = doctored
	user.put_in_hands(newtape)

	timestamp.Cut(index+1)
	storedinfo.Cut(index+1)
	max_capacity = index
	used_capacity = min(used_capacity,index)

//Random colour tapes
/obj/item/magnetic_tape/random/Initialize()
	icon = pick(list(
		'icons/obj/items/device/tape_recorder/tape_casette_white.dmi',
		'icons/obj/items/device/tape_recorder/tape_casette_blue.dmi',
		'icons/obj/items/device/tape_recorder/tape_casette_red.dmi',
		'icons/obj/items/device/tape_recorder/tape_casette_yellow.dmi',
		'icons/obj/items/device/tape_recorder/tape_casette_purple.dmi'
	))
	. = ..()

/obj/item/magnetic_tape/loose
	name = "magnetic tape"
	desc = "Quantum-enriched self-repairing nanotape, used for magnetic storage of information."
	icon = 'icons/obj/items/device/tape_recorder/tape_casette_loose.dmi'
	ruined = TRUE
	draw_ribbon_if_ruined = FALSE

/obj/item/magnetic_tape/loose/fix()
	return

/obj/item/magnetic_tape/loose/get_loose_tape()
	return

/obj/item/magnetic_tape/loose/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += SPAN_NOTICE("It looks long enough to hold [max_capacity] seconds worth of recording.")
		if(doctored && user.skill_check(SKILL_FORENSICS, SKILL_PROF))
			. += SPAN_WARNING("It has been tampered with...")
