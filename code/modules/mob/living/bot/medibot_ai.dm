/datum/mob_controller/bot/medical
	var/last_newpatient_speak = 0
	var/static/list/message_options = list(
		"Radar, put a mask on!" = 'sound/voice/medbot/mradar.ogg',
		"There's always a catch, and it's the best there is." = 'sound/voice/medbot/mcatch.ogg',
		"I knew it, I should've been a plastic surgeon." = 'sound/voice/medbot/msurgeon.ogg',
		"What kind of medbay is this? Everyone's dropping like flies." = 'sound/voice/medbot/mflies.ogg',
		"Delicious!" = 'sound/voice/medbot/mdelicious.ogg'
	)
	var/static/list/seeking_message_options= list(
		"Hey, $NAME$! Hold on, I'm coming." = 'sound/voice/medbot/mcoming.ogg',
		"Wait $NAME$! I want to help!" = 'sound/voice/medbot/mhelp.ogg',
		"$NAME$, you appear to be injured!" = 'sound/voice/medbot/minjured.ogg'
	)

/datum/mob_controller/bot/medical/find_target()
	var/mob/living/bot/medbot/bot = body
	if(!istype(bot) || body.current_posture?.prone) // Don't look for targets if we're incapacitated!
		return
	for(var/mob/living/human/patient as anything in list_targets()) // Time to find a patient!
		set_target(patient)
		if(bot.vocal && world.time >= (last_newpatient_speak + 30 SECONDS))
			var/message_text = pick(message_options)
			body.say(capitalize(replacetext(message_text, "$NAME$", patient.name)))
			playsound(body, message_options[message_text], 50, 0)
			body.custom_emote(1, "points at \the [patient].")
			last_newpatient_speak = world.time
		return

/datum/mob_controller/bot/medical/handle_bot_adjacent_target()
	var/mob/living/bot/medbot/bot = body
	if(!istype(bot) || body.current_posture?.prone) // Don't handle targets if we're incapacitated!
		return
	var/atom/target = get_target()
	if(target)
		body.UnarmedAttack(target)

/datum/mob_controller/bot/medical/handle_bot_idle()
	var/mob/living/bot/medbot/bot = body
	if(!istype(bot) || !bot.vocal || !prob(1))
		return
	var/message = pick(message_options)
	bot.say(message)
	playsound(bot, message_options[message], 50, 0)

/datum/mob_controller/bot/medical/handle_general_bot_ai(mob/living/bot/bot)
	var/mob/living/bot/medbot/medbot = bot
	if(istype(medbot) && body.current_posture?.prone)
		medbot.handle_panic()
	return ..()

/datum/mob_controller/bot/medical/valid_target(atom/A)
	var/mob/living/bot/medbot/bot = body
	if(!istype(bot) || !(. = ..()))
		return FALSE
	if(!ishuman(A))
		return FALSE
	var/mob/living/human/patient = A
	if(patient.stat == DEAD) // He's dead, Jim
		return FALSE
	if(bot.emagged)
		return bot.treatment_emag
	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker
	if(bot.reagent_glass && bot.use_beaker && ((patient.get_damage(BRUTE) >= bot.heal_threshold) || (patient.get_damage(TOX) >= bot.heal_threshold) || (patient.get_damage(TOX) >= bot.heal_threshold) || (patient.get_damage(OXY) >= (bot.heal_threshold + 15))))
		for(var/reagent_id in bot.reagent_glass.reagents.reagent_volumes)
			if(!patient.reagents.has_reagent(reagent_id))
				return TRUE
			continue
	if((patient.get_damage(BRUTE) >= bot.heal_threshold) && (!patient.reagents.has_reagent(bot.treatment_brute)))
		return bot.treatment_brute //If they're already medicated don't bother!
	if((patient.get_damage(OXY) >= (15 + bot.heal_threshold)) && (!patient.reagents.has_reagent(bot.treatment_oxy)))
		return bot.treatment_oxy
	if((patient.get_damage(BURN) >= bot.heal_threshold) && (!patient.reagents.has_reagent(bot.treatment_fire)))
		return bot.treatment_fire
	if((patient.get_damage(TOX) >= bot.heal_threshold) && (!patient.reagents.has_reagent(bot.treatment_tox)))
		return bot.treatment_tox
	return FALSE
