/obj/item/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/items/device/tape_recorder.dmi'
	icon_state = "taperecorder"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL

	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/magnetic_tape/mytape = /obj/item/magnetic_tape/random
	var/canprint = 1
	var/datum/wires/taperecorder/wires = null // Wires datum
	var/maintenance = 0
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	throwforce = 2
	throw_speed = 4
	throw_range = 20

/obj/item/taperecorder/Initialize()
	. = ..()
	wires = new(src)
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	if(ispath(mytape))
		mytape = new mytape(src)
	global.listening_objects += src
	update_icon()

/obj/item/taperecorder/empty
	mytape = null

/obj/item/taperecorder/Destroy()
	QDEL_NULL(wires)
	global.listening_objects -= src
	if(mytape)
		qdel(mytape)
		mytape = null
	return ..()


/obj/item/taperecorder/attackby(obj/item/I, mob/user, params)
	if(IS_SCREWDRIVER(I))
		maintenance = !maintenance
		to_chat(user, "<span class='notice'>You [maintenance ? "open" : "secure"] the lid.</span>")
		return
	if(istype(I, /obj/item/magnetic_tape))
		if(mytape)
			to_chat(user, "<span class='notice'>There's already a tape inside.</span>")
			return
		if(!user.try_unequip(I))
			return
		I.forceMove(src)
		mytape = I
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		update_icon()
		return
	..()


/obj/item/taperecorder/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(mytape)
		mytape.ruin() //Fires destroy the tape
	return ..()


/obj/item/taperecorder/attack_hand(mob/user)
	if(user.is_holding_offhand(src) && mytape && user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		eject()
		return TRUE
	return ..()


/obj/item/taperecorder/verb/eject()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, "<span class='notice'>There's no tape in \the [src].</span>")
		return
	if(emagged)
		to_chat(usr, "<span class='notice'>The tape seems to be stuck inside.</span>")
		return

	if(playing || recording)
		stop()
	to_chat(usr, "<span class='notice'>You remove [mytape] from [src].</span>")
	usr.put_in_hands(mytape)
	mytape = null
	update_icon()

/obj/item/taperecorder/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && maintenance)
		to_chat(user, "<span class='notice'>The wires are exposed.</span>")

/obj/item/taperecorder/hear_talk(mob/living/M, msg, var/verb="says", decl/language/speaking=null)
	if(mytape && recording)

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(M, msg)
			mytape.record_speech("[M.name] [speaking.format_message_plain(msg, verb)]")
		else
			mytape.record_speech("[M.name] [verb], \"[msg]\"")


/obj/item/taperecorder/see_emote(mob/M, text, var/emote_type)
	if(emote_type != AUDIBLE_MESSAGE) //only hearable emotes
		return
	if(mytape && recording)
		mytape.record_speech("[strip_html_properly(text)]")


/obj/item/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == AUDIBLE_MESSAGE) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == AUDIBLE_MESSAGE)
		recordedtext = alt
	else
		return
	if(mytape && recording)
		mytape.record_noise("[strip_html_properly(recordedtext)]")

/obj/item/taperecorder/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		recording = 0
		to_chat(user, "<span class='warning'>PZZTTPFFFT</span>")
		update_icon()
		return 1
	else
		to_chat(user, "<span class='warning'>It is already emagged!</span>")

/obj/item/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, "<span class='danger'>\The [src] explodes!</span>")
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	if(!mytape)
		to_chat(usr, "<span class='notice'>There's no tape!</span>")
		return
	if(mytape.ruined || emagged)
		audible_message("<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(recording)
		to_chat(usr, "<span class='notice'>You're already recording!</span>")
		return
	if(playing)
		to_chat(usr, "<span class='notice'>You can't record when playing!</span>")
		return
	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, "<span class='notice'>Recording started.</span>")
		recording = 1
		update_icon()

		mytape.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mytape && recording && mytape.used_capacity < mytape.max_capacity)
			sleep(10)
			mytape.used_capacity++
			if(mytape.used_capacity >= mytape.max_capacity)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, "<span class='notice'>The tape is full.</span>")
				stop_recording()


		update_icon()
		return
	else
		to_chat(usr, "<span class='notice'>The tape is full.</span>")


/obj/item/taperecorder/proc/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = 0
	update_icon()
	mytape.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, "<span class='notice'>Recording stopped.</span>")


/obj/item/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.incapacitated())
		return
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	if(recording)
		stop_recording()
		return
	else if(playing)
		playing = 0
		update_icon()
		to_chat(usr, "<span class='notice'>Playback stopped.</span>")
		return
	else
		to_chat(usr, "<span class='notice'>Stop what?</span>")


/obj/item/taperecorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		return
	if(emagged || mytape.ruined)
		audible_message("<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(recording || playing)
		to_chat(usr, "<span class='notice'>You can't wipe the tape while playing or recording!</span>")
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		to_chat(usr, "<span class='notice'>You wipe the tape.</span>")
		return


/obj/item/taperecorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	play(usr)

/obj/item/taperecorder/proc/play(mob/user)
	if(!mytape)
		to_chat(user, "<span class='notice'>There's no tape!</span>")
		return
	if(mytape.ruined)
		audible_message("<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(recording)
		to_chat(user, "<span class='notice'>You can't playback when recording!</span>")
		return
	if(playing)
		to_chat(user, "<span class='notice'>You're already playing!</span>")
		return
	playing = 1
	update_icon()
	to_chat(user, "<span class='notice'>Audio playback started.</span>")
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	for(var/i=1 , i < mytape.max_capacity , i++)
		if(!mytape || !playing)
			break
		if(mytape.storedinfo.len < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: [playedmessage]"))

		if(mytape.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: End of recording."))
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			break
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]

		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence"))
			playsleepseconds = 1
		sleep(10 * playsleepseconds)


	playing = 0
	update_icon()

	if(emagged)
		var/turf/T = get_turf(src)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: This tape recorder will self-destruct in... Five."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: Four."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: Three."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: Two."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: One."))
		sleep(10)
		explode()


/obj/item/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, "<span class='notice'>There's no tape!</span>")
		return
	if(mytape.ruined || emagged)
		audible_message("<span class='warning'>The tape recorder makes a scratchy noise.</span>")
		return
	if(!canprint)
		to_chat(usr, "<span class='notice'>The recorder can't print that fast!</span>")
		return
	if(recording || playing)
		to_chat(usr, "<span class='notice'>You can't print the transcript while playing or recording!</span>")
		return

	to_chat(usr, "<span class='notice'>Transcript printed.</span>")
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,mytape.storedinfo.len >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.SetName("Transcript")
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/taperecorder/attack_self(mob/user)
	if(maintenance)
		wires.Interact(user)
		return

	if(recording || playing)
		stop()
	else
		record()


/obj/item/taperecorder/on_update_icon()
	. = ..()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(!mytape)
		icon_state = "[bis.base_icon_state]_empty"
	else if(recording)
		icon_state = "[bis.base_icon_state]_recording"
	else if(playing)
		icon_state = "[bis.base_icon_state]_playing"
	else
		icon_state = "[bis.base_icon_state]_idle"

/obj/item/magnetic_tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/items/device/tape_casette.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE
	)
	force = 1
	throwforce = 0
	var/max_capacity = 600
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = 0
	var/doctored = 0

//draw_ribbon: Whether we draw the ruined ribbon overlay. Only used by quantum tape.
//#FIXME: Probably should be handled better.
/obj/item/magnetic_tape/on_update_icon(var/draw_ribbon = TRUE)
	. = ..()
	if(draw_ribbon && ruined && max_capacity)
		add_overlay(overlay_image(icon, "ribbonoverlay", flags = RESET_COLOR))


/obj/item/magnetic_tape/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	ruin()

/obj/item/magnetic_tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, "<span class='notice'>You pull out all the tape!</span>")
		get_loose_tape(user, storedinfo.len)
		ruin()


/obj/item/magnetic_tape/proc/ruin()
	ruined = TRUE
	update_icon()


/obj/item/magnetic_tape/proc/fix()
	ruined = FALSE
	update_icon()


/obj/item/magnetic_tape/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


//shows up on the printed transcript as (Unrecognized sound)
/obj/item/magnetic_tape/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


/obj/item/magnetic_tape/attackby(obj/item/I, mob/user, params)
	if(user.incapacitated())
		return
	if(ruined && IS_SCREWDRIVER(I))
		if(!max_capacity)
			to_chat(user, "<span class='notice'>There is no tape left inside.</span>")
			return
		to_chat(user, "<span class='notice'>You start winding the tape back in...</span>")
		if(do_after(user, 120, target = src))
			to_chat(user, "<span class='notice'>You wound the tape back in.</span>")
			fix()
		return
	else if(IS_PEN(I))
		if(loc == user)
			var/new_name = input(user, "What would you like to label the tape?", "Tape labeling") as null|text
			if(isnull(new_name)) return
			new_name = sanitize_safe(new_name)
			if(new_name)
				SetName("tape - '[new_name]'")
				to_chat(user, "<span class='notice'>You label the tape '[new_name]'.</span>")
			else
				SetName("tape")
				to_chat(user, "<span class='notice'>You scratch off the label.</span>")
		return
	else if(IS_WIRECUTTER(I))
		cut(user)
	else if(istype(I, /obj/item/magnetic_tape/loose))
		join(user, I)
	..()

/obj/item/magnetic_tape/proc/cut(mob/user)
	if(!LAZYLEN(timestamp))
		to_chat(user, "<span class='notice'>There's nothing on this tape!</span>")
		return
	var/list/output = list("<center>")
	for(var/i=1, i < timestamp.len, i++)
		var/time = "\[[time2text(timestamp[i]*10,"mm:ss")]\]"
		output += "[time]<br><a href='?src=\ref[src];cut_after=[i]'>-----CUT------</a><br>"
	output += "</center>"

	var/datum/browser/popup = new(user, "tape_cutting", "Cutting tape", 170, 600)
	popup.set_content(jointext(output,null))
	popup.open()

/obj/item/magnetic_tape/proc/join(mob/user, obj/item/magnetic_tape/other)
	if(max_capacity + other.max_capacity > initial(max_capacity))
		to_chat(user, "<span class='notice'>You can't fit this much tape in!</span>")
		return
	if(user.try_unequip(other))
		to_chat(user, "<span class='notice'>You join ends of the tape together.</span>")
		max_capacity += other.max_capacity
		used_capacity = min(used_capacity + other.used_capacity, max_capacity)
		timestamp += other.timestamp
		storedinfo += other.storedinfo
		doctored = 1
		ruin()
		update_icon()
		qdel(other)

/obj/item/magnetic_tape/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["cut_after"])
		var/index = text2num(href_list["cut_after"])
		if(index >= timestamp.len)
			return

		to_chat(user, "<span class='notice'>You remove part of the tape off.</span>")
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
	. = ..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"

/obj/item/magnetic_tape/loose
	name = "magnetic tape"
	desc = "Quantum-enriched self-repairing nanotape, used for magnetic storage of information."
	icon = 'icons/obj/items/device/tape_casette.dmi'
	icon_state = "magtape"
	ruined = TRUE

/obj/item/magnetic_tape/loose/fix()
	return

/obj/item/magnetic_tape/loose/on_update_icon()
	. = ..(FALSE)

/obj/item/magnetic_tape/loose/get_loose_tape()
	return

/obj/item/magnetic_tape/loose/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "<span class='notice'>It looks long enough to hold [max_capacity] seconds worth of recording.</span>")
		if(doctored && user.skill_check(SKILL_FORENSICS, SKILL_PROF))
			to_chat(user, "<span class='notice'>It has been tampered with...</span>")
