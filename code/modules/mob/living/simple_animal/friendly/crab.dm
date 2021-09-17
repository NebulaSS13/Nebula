//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon = 'icons/mob/simple_animal/crab.dmi'
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 1
	turns_per_move = 5
	response_harm = "stamps on"
	stop_automated_movement = 1
	friendly = "pinches"
	possession_candidate = 1
	can_escape = TRUE //snip snip
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

	meat_amount =   3
	skin_material = /decl/material/solid/skin/insect
	skin_amount =   10
	bone_material = null
	bone_amount =   0

/mob/living/simple_animal/crab/Initialize()
	if(isnull(hat_offsets))
		hat_offsets = list("[SOUTH]" = list(-1, -10))
	. = ..()

/mob/living/simple_animal/crab/Life()
	. = ..()
	if(!.)
		return FALSE
	//CRAB movement
	if(!ckey && !stat)
		if(isturf(src.loc) && !resting && !buckled)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				Move(get_step(src,pick(4,8)))
				turns_since_move = 0
	update_icon()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"
