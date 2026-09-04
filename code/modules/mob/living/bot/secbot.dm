#define SECBOT_WAIT_TIME	5		//number of in-game seconds to wait for someone to surrender
#define SECBOT_THREAT_ARREST 4		//threat level at which we decide to arrest someone
#define SECBOT_THREAT_ATTACK 8		//threat level at which was assume immediate danger and attack right away

/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/mob/bot/secbot.dmi'
	icon_state = "secbot0"
	layer = MOB_LAYER
	max_health = 50
	req_access = list(list(access_security, access_forensics_lockers))
	botcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)

	patrol_speed = 2
	target_speed = 3
	light_strength = 0 //stunbaton makes it's own light

	RequiresAccessToToggle = 1 // Haha no

	var/attack_state = "secbot-c"
	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.

	var/awaiting_surrender = 0

	var/obj/item/baton/stun_baton
	var/obj/item/handcuffs/cyborg/handcuffs

	var/list/threat_found_sounds = list('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = list('sound/voice/bfreeze.ogg')

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
	stun_baton.set_cell_status(on, null)

/mob/living/bot/secbot/turn_off()
	..()
	stun_baton.set_cell_status(on, null)

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

/mob/living/bot/secbot/attackby(var/obj/item/used_item, var/mob/user)
	var/curhealth = current_health
	. = ..()
	if(current_health < curhealth)
		react_to_attack(user)

/mob/living/bot/secbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "<span class='notice'>You short out [src]'s threat identificator.</span>")
			ignore_list |= user
		emagged = 2
		return 1

/mob/living/bot/secbot/bullet_act(var/obj/item/projectile/P)
	var/curhealth = current_health
	var/mob/shooter = P.firer
	. = ..()
	//if we already have a target just ignore to avoid lots of checking
	if(!target && current_health < curhealth && istype(shooter) && (shooter in view(world.view, src)))
		react_to_attack(shooter)

/mob/living/bot/secbot/proc/begin_arrest(mob/target, var/threat)
	var/suspect_name = target_name(target)
	if(declare_arrests)
		broadcast_security_hud_message("[src] is arresting a level [threat] suspect <b>[suspect_name]</b> in <b>[get_area_name(src)]</b>.", src)
	say("Down on the floor, [suspect_name]! You have [SECBOT_WAIT_TIME] seconds to comply.")
	playsound(src.loc, pick(preparing_arrest_sounds), 50)
	events_repository.register(/decl/observ/moved, target, src, TYPE_PROC_REF(/mob/living/bot/secbot, target_moved))

/mob/living/bot/secbot/proc/target_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if(get_dist(get_turf(src), get_turf(target)) >= 1)
		awaiting_surrender = INFINITY
		events_repository.unregister(/decl/observ/moved, moving_instance, src)

/mob/living/bot/secbot/proc/react_to_attack(mob/attacker)
	if(!target)
		playsound(src.loc, pick(threat_found_sounds), 50)
		broadcast_security_hud_message("[src] was attacked by a hostile <b>[target_name(attacker)]</b> in <b>[get_area_name(src)]</b>.", src)
	target = attacker
	awaiting_surrender = INFINITY

/mob/living/bot/secbot/resetTarget()
	..()
	events_repository.unregister(/decl/observ/moved, target, src)
	awaiting_surrender = -1
	stop_automove()

/mob/living/bot/secbot/startPatrol()
	if(!locked) // Stop running away when we set you up
		return
	..()

/mob/living/bot/secbot/confirmTarget(atom/target)
	if(!..())
		return 0
	return (check_threat(target) >= SECBOT_THREAT_ARREST)

/mob/living/bot/secbot/lookForTargets()
	for(var/mob/living/M in view(src))
		if(M.stat == DEAD)
			continue
		if(confirmTarget(M))
			var/threat = check_threat(M)
			target = M
			awaiting_surrender = -1
			say("Level [threat] infraction alert!")
			custom_emote(1, "points at [M.name]!")
			return

/mob/living/bot/secbot/handleAdjacentTarget()
	var/mob/living/human/H = target
	var/threat = check_threat(target)
	if(awaiting_surrender < SECBOT_WAIT_TIME && istype(H) && !H.current_posture.prone && threat < SECBOT_THREAT_ATTACK)
		if(awaiting_surrender == -1)
			begin_arrest(target, threat)
		++awaiting_surrender
	else
		UnarmedAttack(target, TRUE)

/mob/living/bot/secbot/proc/cuff_target(var/mob/living/target)
	if(istype(target) && !target.get_equipped_item(slot_handcuffed_str))
		handcuffs.place_handcuffs(target, src)
	resetTarget() //we're done, failed or not. Don't want to get stuck if target is not

/mob/living/bot/get_target_zone()
	if(!client)
		return BP_CHEST
	return ..()

/mob/living/bot/secbot/ResolveUnarmedAttack(var/mob/M)
	if(!istype(M))
		return FALSE

	var/mob/living/human/H = M
	if(istype(H) && H.current_posture.prone)
		cuff_target(H)
		return TRUE

	if(isanimal(M))
		set_intent(I_FLAG_HARM)
	else
		set_intent(I_FLAG_GRAB)

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

/mob/living/bot/secbot/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

/mob/living/bot/secbot/proc/check_threat(var/mob/living/M)
	if(!M || !istype(M) || M.stat == DEAD || src == M)
		return 0

	if(emagged && !M.incapacitated()) //check incapacitated so emagged secbots don't keep attacking the same target forever
		return 10

	return M.assess_perp(access_scanner, 0, idcheck, check_records, check_arrest)
