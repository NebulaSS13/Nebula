//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon = 'icons/mob/simple_animal/crab.dmi'
	mob_size = MOB_SIZE_SMALL
	speak_emote = list("clicks")
	response_harm = "stamps on"
	possession_candidate = 1
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
		)
	ai = /datum/mob_controller/crab
	butchery_data = /decl/butchery_data/animal/arthropod/crab

/datum/mob_controller/crab
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 0.25
	turns_per_wander = 10
	wander_directions = list(EAST, WEST) // they only go sideways...
	can_escape_buckles = TRUE //snip snip

// TODO
/decl/bodytype/hexapod
	abstract_type = /decl/bodytype/hexapod

/decl/bodytype/hexapod/animal
	abstract_type = /decl/bodytype/hexapod/animal
	name = "hexapod animal"
	bodytype_flag = 0
	bodytype_category = "hexapodal animal body"

/decl/bodytype/hexapod/get_ignited_icon_state(mob/living/victim)
	return "Generic_mob_burning"

/mob/living/simple_animal/crab/get_bodytype()
	return GET_DECL(/decl/bodytype/hexapod/animal/crab)

/decl/bodytype/hexapod/animal/crab
	uid = "bodytype_animal_crab"

/decl/bodytype/hexapod/animal/crab/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list(-1, -10),
			"[SOUTH]" = list(-1, -10),
			"[EAST]" =  list(-1, -10),
			"[WEST]" =  list(-1, -10)
		)
	)
	. = ..()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"
