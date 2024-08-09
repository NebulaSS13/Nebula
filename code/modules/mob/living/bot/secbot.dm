#define SECBOT_WAIT_TIME	5		//number of in-game seconds to wait for someone to surrender
#define SECBOT_THREAT_ARREST 4		//threat level at which we decide to arrest someone
#define SECBOT_THREAT_ATTACK 8		//threat level at which was assume immediate danger and attack right away

/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot. It looks less than thrilled."
	icon = 'icons/mob/bot/secbot.dmi'
	icon_state = "secbot0"
	layer = MOB_LAYER
	max_health = 50
	req_access = list(list(access_security, access_forensics_lockers))
	light_strength = 0 //stunbaton makes it's own light
	RequiresAccessToToggle = 1 // Haha no
	ai = /datum/mob_controller/bot/security

	var/will_patrol
	var/attack_state = "secbot-c"
	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.

	var/obj/item/baton/stun_baton
	var/obj/item/handcuffs/cyborg/handcuffs
	var/list/preparing_arrest_sounds = list('sound/voice/bfreeze.ogg')

/mob/living/bot/secbot/get_initial_bot_access()
	var/static/list/bot_access = list(
		access_security,
		access_sec_doors,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels
	)
	return bot_access.Copy()

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	will_patrol = 1

/mob/living/bot/secbot/Initialize()
	stun_baton = new /obj/item/baton/infinite(src)
	handcuffs = new(src)
	. = ..()

/mob/living/bot/secbot/Destroy()
	qdel(stun_baton)
	qdel(handcuffs)
	stun_baton = null
	handcuffs = null
	return ..()

/mob/living/bot/secbot/turn_on()
	..()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/turn_off()
	..()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/on_update_icon()
	..()
	icon_state = "secbot[on]"

/mob/living/bot/secbot/GetInteractTitle()
	. = "<head><title>Securitron controls</title></head>"
	. += "<b>Automatic Security Unit</b>"

/mob/living/bot/secbot/GetInteractPanel()
	. = "Check for weapon authorization: <a href='byond://?src=\ref[src];command=idcheck'>[idcheck ? "Yes" : "No"]</a>"
	. += "<br>Check security records: <a href='byond://?src=\ref[src];command=ignorerec'>[check_records ? "Yes" : "No"]</a>"
	. += "<br>Check arrest status: <a href='byond://?src=\ref[src];command=ignorearr'>[check_arrest ? "Yes" : "No"]</a>"
	. += "<br>Report arrests: <a href='byond://?src=\ref[src];command=declarearrests'>[declare_arrests ? "Yes" : "No"]</a>"
	. += "<br>Auto patrol: <a href='byond://?src=\ref[src];command=patrol'>[will_patrol ? "On" : "Off"]</a>"

/mob/living/bot/secbot/GetInteractMaintenance()
	. = "Threat identifier status: "
	switch(emagged)
		if(0)
			. += "<a href='byond://?src=\ref[src];command=emag'>Normal</a>"
		if(1)
			. += "<a href='byond://?src=\ref[src];command=emag'>Scrambled (DANGER)</a>"
		if(2)
			. += "ERROROROROROR-----"

/mob/living/bot/secbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("idcheck")
				idcheck = !idcheck
			if("ignorerec")
				check_records = !check_records
			if("ignorearr")
				check_arrest = !check_arrest
			if("patrol")
				will_patrol = !will_patrol
			if("declarearrests")
				declare_arrests = !declare_arrests

	if(CanAccessMaintenance(user))
		switch(command)
			if("emag")
				if(emagged < 2)
					emagged = !emagged

/mob/living/bot/secbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "<span class='notice'>You short out [src]'s threat identifier.</span>")
			ai?.add_friend(user)
		emagged = 2
		return 1

/mob/living/bot/secbot/proc/begin_arrest(mob/target, var/threat)
	var/suspect_name = (target?.get_id_name(ishuman(target) ? "unidentified person" : "unidentified lifeform") || "unidentified lifeform")
	if(declare_arrests)
		broadcast_security_hud_message("[src] is arresting a level [threat] suspect <b>[suspect_name]</b> in <b>[get_area_name(src)]</b>.", src)
	say("Down on the floor, [suspect_name]! You have [SECBOT_WAIT_TIME] seconds to comply.")
	playsound(src.loc, pick(preparing_arrest_sounds), 50)
	events_repository.register(/decl/observ/moved, target, src, TYPE_PROC_REF(/mob/living/bot/secbot, target_moved))

/mob/living/bot/secbot/proc/target_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if(get_dist(get_turf(src), get_turf(ai?.get_target())) >= 1)
		var/datum/mob_controller/bot/security/bot_ai = ai
		if(istype(bot_ai))
			bot_ai.awaiting_surrender = INFINITY
		events_repository.unregister(/decl/observ/moved, moving_instance, src)

/mob/living/bot/secbot/proc/cuff_target(var/mob/living/target)
	if(istype(target) && !target.get_equipped_item(slot_handcuffed_str))
		handcuffs.place_handcuffs(target, src)
	ai?.lose_target() //we're done, failed or not. Don't want to get stuck if target is not

/mob/living/bot/secbot/UnarmedAttack(var/mob/M, var/proximity)

	. = ..()
	if(.)
		return

	if(!istype(M))
		return FALSE

	var/mob/living/human/H = M
	if(istype(H) && H.current_posture.prone)
		cuff_target(H)
		return TRUE

	if(isanimal(M))
		a_intent = I_HURT
	else
		a_intent = I_GRAB

	stun_baton.use_on_mob(M, src) //robots and turrets aim for center of mass
	flick(attack_state, src)
	return TRUE


/mob/living/bot/secbot/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..()
	if(. && my_turf)
		new /obj/item/assembly/prox_sensor(my_turf)
		new /obj/item/baton(my_turf)
		if(prob(50))
			new /obj/item/robot_parts/l_arm(my_turf)
