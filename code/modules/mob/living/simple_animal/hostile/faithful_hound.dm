/mob/living/simple_animal/faithful_hound
	name = "spectral hound"
	desc = "A spooky looking ghost dog. Does not look friendly."
	icon = 'icons/mob/simple_animal/corgi_ghost.dmi'
	blend_mode = BLEND_SUBTRACT
	max_health = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	density = FALSE
	anchored = TRUE
	faction = "cute ghost dogs"
	supernatural = 1
	ai = /datum/mob_controller/faithful_hound

/datum/mob_controller/faithful_hound
	do_wander = FALSE
	var/last_check = 0
	var/password

/datum/mob_controller/faithful_hound/check_memory(mob/speaker, message)
	return password && message && findtext(lowertext(message), lowertext(password))

/datum/mob_controller/faithful_hound/memorise(mob/speaker, message)
	password = message

/datum/mob_controller/faithful_hound/do_process()
	if(!(. = ..()) || body.client || world.time <= last_check)
		return
	last_check = world.time + 5 SECONDS
	var/aggressiveness = 0 //The closer somebody is to us, the more aggressive we are
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(get_turf(body), 5, mobs, objs, 0)
	for(var/mob/living/mailman in mobs)
		if((mailman == body) || is_friend(mailman) || mailman.faction == body.faction)
			continue
		body.face_atom(mailman)
		var/new_aggress = 1
		var/dist = get_dist(mailman, body)
		if(dist < 2) //Attack! Attack!
			body.a_intent = I_HURT
			body.ClickOn(mailman)
			return
		if(dist == 2)
			new_aggress = 3
		else if(dist == 3)
			new_aggress = 2
		else
			new_aggress = 1
		aggressiveness = max(aggressiveness, new_aggress)

	switch(aggressiveness)
		if(1)
			body.audible_message("\The [body] growls.")
		if(2)
			body.audible_message(SPAN_WARNING("\The [body] barks threateningly!"))
		if(3)
			body.visible_message(SPAN_DANGER("\The [body] snaps at the air!"))

/mob/living/simple_animal/faithful_hound/get_death_message(gibbed)
	return "disappears!"

/mob/living/simple_animal/faithful_hound/death(gibbed)
	. = ..()
	if(. && !gibbed)
		new /obj/item/ectoplasm(get_turf(src))
		qdel(src)

/mob/living/simple_animal/faithful_hound/Destroy()
	return ..()

/mob/living/simple_animal/faithful_hound/hear_say(var/message, var/verb = "says", var/decl/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	set waitfor = FALSE
	if(!ai?.check_memory(speaker, message))
		return
	ai.add_friend(speaker)
	sleep(1 SECOND)
	if(!QDELETED(src) && !QDELETED(speaker) && ai?.is_friend(speaker))
		visible_message(SPAN_NOTICE("\The [src] nods in understanding towards \the [speaker]."))
