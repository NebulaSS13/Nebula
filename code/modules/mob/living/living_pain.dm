/mob/proc/flash_pain(var/target)
	if(pain)
		var/matrix/M
		if(client && max(client.last_view_x_dim, client.last_view_y_dim) > 7)
			M = matrix()
			M.Scale(CEILING(client.last_view_x_dim/7), CEILING(client.last_view_y_dim/7))
		pain.transform = M
		animate(pain, alpha = target, time = 15, easing = ELASTIC_EASING)
		animate(pain, alpha = 0, time = 20)

/mob/living/proc/can_feel_pain(var/check_organ)
	if(check_organ)
		if(!istype(check_organ))
			return FALSE
		return check_organ.can_feel_pain()
	if(!isSynthetic())
		var/decl/species/my_species = get_species()
		return !(my_species?.species_flags & SPECIES_FLAG_NO_PAIN)
	return FALSE

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	set waitfor = FALSE
	if(!message || stat || !can_feel_pain() || has_chemical_effect(CE_PAINKILLER, power))
		return
	power -= GET_CHEMICAL_EFFECT(src, CE_PAINKILLER)/2	//Take the edge off.
	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && power)
		if(affecting)
			affecting.add_pain(CEILING(power/2))
		else
			adjustHalLoss(CEILING(power/2))
	flash_pain(min(round(2*power)+55, 255))

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		if(power >= 70)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 40)
			to_chat(src, "<span class='danger'><font size=2>[message]</font></span>")
		else if(power >= 10)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")
	next_pain_time = world.time + max(30 SECONDS - power, 10 SECONDS)
	do_species_pain_emote(power)

/mob/living/proc/do_species_pain_emote(power)
	var/decl/species/my_species = get_species()
	var/force_emote = my_species?.get_pain_emote(src, power)
		if(force_emote && prob(power))
			var/decl/emote/use_emote = usable_emotes[force_emote]
			if(!(use_emote.message_type == AUDIBLE_MESSAGE &&HAS_STATUS(src, STAT_SILENCE)))
				emote(force_emote)
