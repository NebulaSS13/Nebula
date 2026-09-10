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
	ability_handlers = list(/datum/ability_handler/predator)

/datum/mob_controller/aggressive/bear
	emote_speech = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear   = list("rawrs","grumbles","grawls")
	emote_see    = list("stares ferociously", "stomps")
	speak_chance = 0.25
	turns_per_wander = 10
	ai_flags = (AI_FLAG_AGGRESSIVE | AI_FLAG_ALERTS | AI_FLAG_TIRES | AI_FLAG_ESCAPE_BUCKLES)
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
