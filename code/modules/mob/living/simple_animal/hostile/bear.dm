//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon = 'icons/mob/simple_animal/bear_space.dmi'
	speak_emote  = list("growls", "roars")
	see_in_dark = 6
	response_harm = "pokes"
	max_health = 60
	natural_weapon = /obj/item/natural_weapon/claws/strong
	faction = "russian"
	base_animal_type = /mob/living/simple_animal/hostile/bear

	//Space bears aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	butchery_data = /decl/butchery_data/animal/space_bear
	ai = /datum/mob_controller/aggressive/bear

/datum/mob_controller/aggressive/bear
	emote_speech = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear   = list("rawrs","grumbles","grawls")
	emote_see    = list("stares ferociously", "stomps")
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/bear/on_update_icon()
	. = ..()
	if(isspaceturf(loc))
		var/check_icon_state = "[initial(icon_state)]-space"
		if(check_state_in_icon(check_icon_state, icon))
			icon_state = check_icon_state

//SPACE BEARS! SQUEEEEEEEE~	 OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_harm = "pokes"

/datum/mob_controller/aggressive/bear/find_target()
	. = ..()
	if(.)
		body.custom_emote(VISIBLE_MESSAGE,"stares alertly at [.]")
		set_stance(STANCE_ALERT)

/datum/mob_controller/aggressive/bear/do_process()

	if(!(. = ..()) || body.stat)
		return

	var/atom/target = get_target()
	if(!istype(target))
		return

	switch(stance)

		if(STANCE_TIRED)
			stop_wandering()
			stance_step++
			if(stance_step >= 20)
				if(target && (target in list_targets(10)))
					set_stance(STANCE_ATTACK) //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					set_stance(STANCE_IDLE)

		if(STANCE_ALERT)
			stop_wandering()
			var/found_mob = 0
			if(target && (target in list_targets(10)))
				if(!attackable(target))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					body.set_dir(get_dir(body, target))	//Keep staring at the mob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at [target]", "stares angrily at [target]", "prepares to attack [target]", "closely watches [target]" ) )
						if(action)
							body.custom_emote(VISIBLE_MESSAGE, action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -40)
				set_stance(STANCE_IDLE)
			if(stance_step >= 14)
				set_stance(STANCE_ATTACK)

		if(STANCE_ATTACKING)
			if(stance_step >= 40)
				body.custom_emote(VISIBLE_MESSAGE, "is worn out and needs to rest." )
				set_stance(STANCE_TIRED)
				stance_step = 0
				body.stop_automove()
				return

/mob/living/simple_animal/hostile/bear/attackby(var/obj/item/O, var/mob/user)
	if(istype(ai))
		var/stance = ai.get_stance()
		if(stance != STANCE_ATTACK && stance != STANCE_ATTACKING)
			ai.set_stance(STANCE_ALERT)
			if(istype(ai, /datum/mob_controller/aggressive/bear))
				var/datum/mob_controller/aggressive/bear/bearbrain = ai
				bearbrain.stance_step = 12
			ai.set_target(user)
	..()

/mob/living/simple_animal/hostile/bear/attack_hand(mob/user)
	if(istype(ai))
		var/stance = ai.get_stance()
		if(stance != STANCE_ATTACK && stance != STANCE_ATTACKING)
			ai.set_stance(STANCE_ALERT)
			if(istype(ai, /datum/mob_controller/aggressive/bear))
				var/datum/mob_controller/aggressive/bear/bearbrain = ai
				bearbrain.stance_step = 12
			ai.set_target(user)
	return ..()
