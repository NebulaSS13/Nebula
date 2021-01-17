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

	id_type = /obj/item/card/id/syndicate

	faction = "pirate"
	base_to_load = /datum/map_template/ruin/antag_spawn/heist
	default_outfit = /decl/hierarchy/outfit/raider
	id_title = "Visitor"

	var/list/outfits_per_species

/decl/special_role/raider/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
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
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		global_objectives |= O

		i++

	global_objectives |= new /datum/objective/heist/preserve_crew
	return 1

/decl/special_role/raider/proc/is_raider_crew_safe()

	if(!current_antagonists || current_antagonists.len == 0)
		return 0

	for(var/datum/mind/player in current_antagonists)
		if(!player.current || get_area(player.current) != locate(/area/map_template/skipjack_station/start))
			return 0
	return 1

/decl/special_role/raider/create_id(mob/living/carbon/human/player, equip)
	var/obj/item/card/id/id = ..()
	if(player && id)
		var/obj/item/storage/wallet/W = new(player)
		W.handle_item_insertion(id)
		if(player.equip_to_slot_or_del(W, slot_wear_id_str))
			var/obj/item/cash/cash = new(get_turf(player))
			cash.adjust_worth(rand(50,150)*10)
			player.put_in_hands(cash)

/decl/special_role/raider/equip(var/mob/living/carbon/human/player)
	default_outfit = LAZYACCESS(outfits_per_species, player.species.name) || initial(default_outfit)
	. = ..()
	if(.)
		create_radio(RAID_FREQ, player)
