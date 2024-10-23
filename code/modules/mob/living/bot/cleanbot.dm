/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon = 'icons/mob/bot/cleanbot.dmi'
	icon_state = "cleanbot0"
	req_access = list(list(access_janitor, access_robotics))
	ai = /datum/mob_controller/bot/clean
	wait_if_pulled = 1

	var/will_patrol
	var/screwloose = 0
	var/oddbutton = 0
	var/blood = 1

/mob/living/bot/cleanbot/get_initial_bot_access()
	var/static/list/bot_access = list(
		access_janitor,
		access_maint_tunnels
	)
	return bot_access.Copy()

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)

	. = ..()
	if(.)
		return

	if(!istype(D))
		return TRUE

	if(D.loc != loc)
		return FALSE

	ai?.set_stance(STANCE_BUSY)
	visible_message("\The [src] begins to clean up \the [D].")
	update_icon()
	var/cleantime = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	if(do_after(src, cleantime, progress = 0) && !QDELETED(D))
		if(D == ai?.get_target())
			ai.set_target(null)
		qdel(D)
	playsound(src, 'sound/machines/boop2.ogg', 30)
	ai?.set_stance(STANCE_IDLE)
	update_icon()
	return TRUE

/mob/living/bot/cleanbot/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..()
	if(. && my_turf)
		new /obj/item/chems/glass/bucket(my_turf)
		new /obj/item/assembly/prox_sensor(my_turf)
		if(prob(50))
			new /obj/item/robot_parts/l_arm(my_turf)

/mob/living/bot/cleanbot/on_update_icon()
	..()
	if(istype(ai) && ai.get_stance() == STANCE_BUSY)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/GetInteractTitle()
	. = "<head><title>Cleanbot controls</title></head>"
	. += "<b>Automatic Cleaner v1.0</b>"

/mob/living/bot/cleanbot/GetInteractPanel()
	. = "Cleans blood: <a href='byond://?src=\ref[src];command=blood'>[blood ? "Yes" : "No"]</a>"
	. += "<br>Patrol station: <a href='byond://?src=\ref[src];command=patrol'>[will_patrol ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/GetInteractMaintenance()
	. = "Odd looking screw twiddled: <a href='byond://?src=\ref[src];command=screw'>[screwloose ? "Yes" : "No"]</a>"
	. += "<br>Weird button pressed: <a href='byond://?src=\ref[src];command=oddbutton'>[oddbutton ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("blood")
				blood = !blood
				ai?.find_target()
			if("patrol")
				will_patrol = !will_patrol
				ai?.clear_paths()

	if(CanAccessMaintenance(user))
		switch(command)
			if("screw")
				screwloose = !screwloose
			if("oddbutton")
				oddbutton = !oddbutton

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!screwloose || !oddbutton)
		if(user)
			to_chat(user, "<span class='notice'>\The [src] buzzes and beeps.</span>")
		oddbutton = 1
		screwloose = 1
		return 1
