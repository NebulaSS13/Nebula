/obj/item/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/items/device/tape_recorder/tape_recorder.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	throw_speed = 4
	throw_range = 20

	var/emagged = FALSE
	var/recording = FALSE
	var/playing = FALSE
	var/playsleepseconds = 0
	var/obj/item/magnetic_tape/mytape = /obj/item/magnetic_tape/random
	var/const/TRANSCRIPT_PRINT_COOLDOWN = 5 MINUTES
	/// (FLOAT) The minimum world.time before a transcript can be printed again.
	var/next_print_time = 0
	var/datum/wires/taperecorder/wires = null // Wires datum
	/// (BOOL) If TRUE, wire datum is accessible for interactions.
	var/wires_accessible = FALSE

/obj/item/taperecorder/Initialize()
	. = ..()
	wires = new(src)
	if(ispath(mytape))
		mytape = new mytape(src)
	global.listening_objects += src
	update_icon()

/obj/item/taperecorder/empty
	mytape = null

/obj/item/taperecorder/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(mytape)
	return ..()

/obj/item/taperecorder/attackby(obj/item/used_item, mob/user, params)
	if(IS_SCREWDRIVER(used_item))
		wires_accessible = !wires_accessible
		to_chat(user, SPAN_NOTICE("You [wires_accessible ? "open" : "secure"] the lid."))
		return TRUE
	if(istype(used_item, /obj/item/magnetic_tape))
		if(mytape)
			to_chat(user, SPAN_NOTICE("There's already a tape inside."))
			return TRUE
		if(!user.try_unequip(used_item))
			return TRUE
		used_item.forceMove(src)
		mytape = used_item
		to_chat(user, SPAN_NOTICE("You insert [used_item] into [src]."))
		update_icon()
		return TRUE
	return ..()


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
		to_chat(usr, SPAN_NOTICE("There's no tape in \the [src]."))
		return
	if(emagged)
		to_chat(usr, SPAN_NOTICE("The tape seems to be stuck inside."))
		return

	if(playing || recording)
		stop()
	to_chat(usr, SPAN_NOTICE("You remove [mytape] from [src]."))
	usr.put_in_hands(mytape)
	mytape = null
	update_icon()

/obj/item/taperecorder/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 && wires_accessible)
		. += SPAN_NOTICE("The wires are exposed.")

/obj/item/taperecorder/hear_talk(mob/living/M, msg, var/verb="says", decl/language/speaking=null)
	if(mytape && recording)

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(M, msg)
			mytape.record_speech("[M.name] [speaking.format_message_plain(msg, verb)]")
		else
			mytape.record_speech("[M.name] [verb], \"[msg]\"")

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
	if(!emagged)
		emagged = TRUE
		recording = FALSE
		to_chat(user, SPAN_WARNING("PZZTTPFFFT"))
		update_icon()
		return 1
	else
		to_chat(user, SPAN_WARNING("It is already emagged!"))

/obj/item/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DANGER("\The [src] explodes!"))
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
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined || emagged)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, SPAN_NOTICE("You're already recording!"))
		return
	if(playing)
		to_chat(usr, SPAN_NOTICE("You can't record when playing!"))
		return
	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = TRUE
		update_icon()

		mytape.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mytape && recording && mytape.used_capacity < mytape.max_capacity)
			sleep(1 SECOND)
			mytape.used_capacity++
			if(mytape.used_capacity >= mytape.max_capacity)
				to_chat(usr, SPAN_NOTICE("The tape is full."))
				stop_recording()


		update_icon()
		return
	else
		to_chat(usr, SPAN_NOTICE("The tape is full."))


/obj/item/taperecorder/proc/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = FALSE
	update_icon()
	mytape.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_NOTICE("Recording stopped."))


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
		playing = FALSE
		update_icon()
		to_chat(usr, SPAN_NOTICE("Playback stopped."))
		return
	else
		to_chat(usr, SPAN_NOTICE("Stop what?"))


/obj/item/taperecorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		return
	if(emagged || mytape.ruined)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't wipe the tape while playing or recording!"))
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		to_chat(usr, SPAN_NOTICE("You wipe the tape."))
		return


/obj/item/taperecorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	play(usr)

/obj/item/taperecorder/proc/play(mob/user)
	if(!mytape)
		to_chat(user, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(user, SPAN_NOTICE("You can't playback when recording!"))
		return
	if(playing)
		to_chat(user, SPAN_NOTICE("\The [src] is already playing its recording!"))
		return
	playing = TRUE
	update_icon()
	to_chat(user, SPAN_NOTICE("Audio playback started."))
	playsound(src, 'sound/machines/click.ogg', 10, 1)
	for(var/i=1 , i < mytape.max_capacity , i++)
		if(!mytape || !playing)
			break
		if(length(mytape.storedinfo) < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message(SPAN_MAROON("<B>Tape Recorder</B>: [playedmessage]"))

		if(length(mytape.storedinfo) < i+1)
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
		sleep(playsleepseconds SECONDS)


	playing = FALSE
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
		to_chat(usr, SPAN_NOTICE("There's no tape!"))
		return
	if(mytape.ruined || emagged)
		audible_message(SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(next_print_time < world.time)
		to_chat(usr, SPAN_NOTICE("The recorder can't print that fast!"))
		return
	if(recording || playing)
		to_chat(usr, SPAN_NOTICE("You can't print the transcript while playing or recording!"))
		return

	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i in 1 to length(mytape.storedinfo))
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.SetName("Transcript")
	next_print_time = world.time + TRANSCRIPT_PRINT_COOLDOWN

/obj/item/taperecorder/attack_self(mob/user)
	if(wires_accessible)
		wires.Interact(user)
		return
	if(recording || playing)
		stop()
	else
		record()

/obj/item/taperecorder/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(!mytape)
		icon_state = "[icon_state]_empty"
	else if(recording)
		icon_state = "[icon_state]_recording"
	else if(playing)
		icon_state = "[icon_state]_playing"
	else
		icon_state = "[icon_state]_idle"
