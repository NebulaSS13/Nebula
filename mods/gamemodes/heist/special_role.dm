/decl/special_role/raider
	name = "Raider"
	name_plural = "Raiders"
	antag_indicator = "hudraider"
	landmark_id = "raiderstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudraider"
	hard_cap = 6
	hard_cap_round = 10
	initial_spawn_req = 4
	initial_spawn_target = 6
	min_player_age = 14
	default_access = list(access_raider)
	faction = "pirate"
	base_to_load = "Heist Base"
	default_outfit = /decl/outfit/raider
	id_title = "Visitor"

	var/list/outfits_per_species

/decl/special_role/raider/update_access(var/mob/living/player)
	for(var/obj/item/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.SetName("[player.real_name]'s Passport")
			id.registered_name = player.real_name
			W.SetName("[initial(W.name)] ([id.name])")

/decl/special_role/raider/create_global_objectives()

	if(!..())
		return 0

	var/i = 1
	var/max_objectives = pick(2,2,2,2,3,3,3,4)
	global_objectives = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/loot()
		else
			O = new /datum/objective/salvage()
		O.find_target()
		global_objectives |= O

		i++

	global_objectives |= new /datum/objective/preserve_crew
	return 1

/decl/special_role/raider/equip_role(var/mob/living/human/player)
	default_outfit = LAZYACCESS(outfits_per_species, player.species.name) || initial(default_outfit)
	. = ..()
