/mob
	var/next_emote
	var/next_emote_refresh
	var/last_emote_summary

/mob/proc/can_emote(emote_type, show_message)
	. = check_mob_can_emote(emote_type)
	if(!. && show_message)
		to_chat(show_message, SPAN_WARNING("You cannot currently [emote_type == AUDIBLE_MESSAGE ? "audibly" : "visually"] emote!"))

/mob/proc/check_mob_can_emote(var/emote_type)
	SHOULD_CALL_PARENT(TRUE)
	return (stat == CONSCIOUS)

/mob/living/check_mob_can_emote(var/emote_type)
	return ..() && !(HAS_STATUS(src, STAT_SILENCE) && emote_type == AUDIBLE_MESSAGE)

/mob/living/brain/check_mob_can_emote(var/emote_type)
	return ..() && istype(get_container(), /obj/item/organ/internal/brain_interface)

#define EMOTE_REFRESH_SPAM_COOLDOWN (5 SECONDS)
/mob/proc/emote(var/act, var/m_type, var/message)
	set waitfor = FALSE

	if(stat == DEAD && act != "deathgasp")
		return

	var/decl/emote/use_emote
	if(ispath(act, /decl/emote))
		use_emote = GET_DECL(act)
		m_type = use_emote.message_type

	var/show_message_to
	if(usr == src) //client-called emote
		if (client?.prefs?.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot send IC messages (muted)."))
			return

		if(world.time < next_emote)
			to_chat(src, SPAN_WARNING("You cannot use another emote yet."))
			return

		if(act == "help")
			if(world.time >= next_emote_refresh)
				var/list/usable_emotes = list()
				next_emote_refresh = world.time + EMOTE_REFRESH_SPAM_COOLDOWN
				for(var/emote in get_default_emotes())
					var/decl/emote/emote_datum = GET_DECL(emote)
					if(emote_datum.mob_can_use(src, assume_available = TRUE))
						usable_emotes[emote_datum.key] = emote_datum
				last_emote_summary = english_list(sortTim(usable_emotes, /proc/cmp_text_asc, associative = TRUE))
			to_chat(src, "<b>Usable emotes:</b> [last_emote_summary].")
			return

		if(act == "me")
			return custom_emote(m_type, message)

		if(act == "custom")
			if(!message)
				message = sanitize(input("Enter an emote to display.") as text|null)
			if(!message)
				return
			if (!m_type)
				if(alert(src, "Is this an audible emote?", "Emote", "Yes", "No") == "No")
					m_type = VISIBLE_MESSAGE
				else
					m_type = AUDIBLE_MESSAGE
			return custom_emote(m_type, message)

		show_message_to = usr

	if(!can_emote(m_type, show_message_to))
		return

	var/splitpoint = findtext(act, " ")
	if(splitpoint > 0)
		var/tempstr = act
		act = copytext(tempstr,1,splitpoint)
		message = copytext(tempstr,splitpoint+1,0)

	if(!use_emote)
		use_emote = get_emote_by_key(act)

	if(!istype(use_emote))
		to_chat(show_message_to, SPAN_WARNING("Unknown emote '[act]'. Type <b>say *help</b> for a list of usable emotes."))
		return

	if(!use_emote.mob_can_use(src))
		to_chat(show_message_to, SPAN_WARNING("You cannot use the emote '[act]'. Type <b>say *help</b> for  a list of usable emotes."))
		return

	if(m_type != use_emote.message_type && use_emote.conscious && stat != CONSCIOUS)
		return

	if(use_emote.message_type == AUDIBLE_MESSAGE && get_item_blocking_speech())
		audible_message("<b>\The [src]</b> [use_emote.emote_message_muffled || "makes a muffled sound."]")
		return

	next_emote = world.time + use_emote.emote_delay
	use_emote.do_emote(src, message)

	for (var/obj/item/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

#undef EMOTE_REFRESH_SPAM_COOLDOWN

/mob/proc/format_emote(var/emoter = null, var/message = null)
	var/pretext
	var/subtext
	var/nametext
	var/end_char
	var/start_char
	var/name_anchor
	var/anchor_char = get_prefix_key(/decl/prefix/visible_emote)

	if(!message || !emoter)
		return

	name_anchor = findtext(message, anchor_char)
	if(name_anchor > 0) // User supplied emote with visible_emote token (default ^)
		pretext = copytext(message, 1, name_anchor)
		subtext = copytext(message, name_anchor + 1, length(message) + 1)
	else
		// No token. Just the emote as usual.
		subtext = message

	// Oh shit, we got this far! Let's see... did the user attempt to use more than one token?
	if(findtext(subtext, anchor_char))
		// abort abort!
		to_chat(emoter, "<span class='warning'>You may use only one \"[anchor_char]\" symbol in your emote.</span>")
		return

	if(pretext)
		// Add a space at the end if we didn't already supply one.
		end_char = copytext(pretext, length(pretext), length(pretext) + 1)
		if(end_char != " ")
			pretext += " "

	handle_autopunctuation(subtext)

	// Add a space to the subtext, unless it begins with an apostrophe or comma.
	if(subtext != ".")
		// First, let's get rid of any existing space, to account for sloppy emoters ("X, ^ , Y")
		subtext = trim_left(subtext)
		start_char = copytext(subtext, 1, 2)
		if(start_char != "," && start_char != "'")
			subtext = " " + subtext

	// Store the player's name in a nice bold, naturalement
	nametext = "<B>[emoter]</B>"
	return capitalize(pretext) + nametext + subtext

/mob/proc/custom_emote(var/m_type = VISIBLE_MESSAGE, var/message = null)
	set waitfor = FALSE
	if(!can_emote(m_type, src))
		return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message

	if(!input)
		return

	message = trim(html_encode(message))
	message = filter_modify_message(message)
	message = format_emote(src, message)
	message = trim(html_decode(message))

	if (message)
		log_emote("[name]/[key] : [message]")
	//do not show NPC animal emotes to ghosts, it turns into hellscape
	var/check_ghosts = client ? /datum/client_preference/ghost_sight : null
	if(m_type == VISIBLE_MESSAGE)
		visible_message(message, check_ghosts = check_ghosts)
	else
		audible_message(message, check_ghosts = check_ghosts)

// Specific mob type exceptions below.
/mob/living/silicon/ai/emote(var/act, var/type, var/message)
	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters[src]) //Is the AI using a holopad?
		src.holopad_emote(message)
		return
	return ..()

/mob/living/captive_brain/emote(var/message)
	return

/mob/observer/ghost/emote(var/act, var/type, var/message)
	if(message && act == "me")
		communicate(/decl/communication_channel/dsay, client, message, /decl/dsay_communication/emote)
