//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon = 'icons/mob/simple_animal/crab.dmi'
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 0.5
	turns_per_move = 5
	response_harm = "stamps on"
	stop_automated_movement = 1
	possession_candidate = 1
	can_escape = TRUE //snip snip
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
		)
	ai = /datum/ai/crab
	butchery_data = /decl/butchery_data/animal/arthropod/crab

/mob/living/simple_animal/crab/get_bodytype()
	return GET_DECL(/decl/bodytype/animal/crab)

/decl/bodytype/animal/crab/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list(-1, -10),
			"[SOUTH]" = list(-1, -10),
			"[EAST]" =  list(-1, -10),
			"[WEST]" =  list(-1, -10)
		)
	)
	. = ..()

/datum/ai/crab
	expected_type = /mob/living/simple_animal/crab

/datum/ai/crab/do_process(time_elapsed)
	. = ..()
	var/mob/living/simple_animal/crab/crab = body
	if(!isturf(crab.loc) || crab.current_posture.prone || crab.buckled)
		return
	crab.turns_since_move++
	if(crab.turns_since_move >= crab.turns_per_move)
		crab.Move(get_step(crab,pick(4,8)))
		crab.turns_since_move = 0

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"
