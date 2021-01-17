/decl/special_role/paramount
	name = "Paramount"
	name_plural = "Paramounts"
	landmark_id = "ninjastart"
	welcome_text = "<span class='info'>You were once one of the finest minds of your culture, now driven to madness by the whispers of the howling dark and blessed with psychic faculties that defy understanding. Using your C-E rig and your twisted knowledge of psionics, advance your agenda in human space.</span>"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_RANDSPAWN | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudwizard"
	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 1
	hard_cap_round = 3
	min_player_age = 18
	id_type = /obj/item/card/id/syndicate
	faction = "paramount"
	default_outfit = /decl/hierarchy/outfit/paramount

/decl/hierarchy/outfit/paramount
	name =    "Special Role - Paramount Grandmaster"
	head =    /obj/item/clothing/head/helmet/space/psi_amp
	uniform = /obj/item/clothing/under/psysuit
	suit =    /obj/item/clothing/suit/wizrobe/psypurple
	shoes =   /obj/item/clothing/shoes/jackboots
	back =    /obj/item/storage/backpack/satchel
	gloves =  /obj/item/clothing/gloves/color/grey

/decl/special_role/paramount/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		player.set_psi_rank(PSI_REDACTION, 3,     defer_update = TRUE)
		player.set_psi_rank(PSI_COERCION, 3,      defer_update = TRUE)
		player.set_psi_rank(PSI_PSYCHOKINESIS, 3, defer_update = TRUE)
		player.set_psi_rank(PSI_ENERGISTICS, 3,   defer_update = TRUE)
		player.psi.update(TRUE)

/decl/special_role/paramount/create_objectives(var/datum/mind/player)

	if(!..())
		return
	// Copied from ninja for now.
	var/objective_list = list(1,2,3)
	for(var/i=rand(2,3),i>0,i--)
		switch(pick(objective_list))
			if(1)//Kill
				var/datum/objective/assassinate/objective = new
				objective.owner = player
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					player.objectives += objective
				else
					i++
				objective_list -= 1 // No more than one kill objective
			if(2)//Protect
				var/datum/objective/protect/objective = new
				objective.owner = player
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					player.objectives += objective
				else
					i++
					objective_list -= 3
			if(3)//Harm
				var/datum/objective/harm/objective = new
				objective.owner = player
				objective.target = objective.find_target()
				if(objective.target != "Free Objective")
					player.objectives += objective
				else
					i++
					objective_list -= 4

	var/datum/objective/survive/objective = new
	objective.owner = player
	player.objectives += objective
