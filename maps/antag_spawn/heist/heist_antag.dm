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

	var/list/raider_uniforms = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/pirate,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/color/brown,
		)

	var/list/raider_shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/clothing/shoes/dress
		)

	var/list/raider_glasses = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/thermal/plain/eyepatch,
		/obj/item/clothing/glasses/thermal/plain/monocle
		)

	var/list/raider_helmets = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/mask/bandana/red,
		/obj/item/clothing/head/hgpiratecap,
		)

	var/list/raider_suits = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/hoodie,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/poncho/colored,
		)

	var/list/raider_guns = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/projectile/revolver/lasvolver,
		/obj/item/gun/energy/xray,
		/obj/item/gun/energy/toxgun,
		/obj/item/gun/energy/ionrifle,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/crossbow/largecrossbow,
		/obj/item/gun/launcher/crossbow,
		/obj/item/gun/launcher/grenade/loaded,
		/obj/item/gun/launcher/pneumatic,
		/obj/item/gun/projectile/automatic/smg,
		/obj/item/gun/projectile/automatic/assault_rifle,
		/obj/item/gun/projectile/shotgun/pump,
		/obj/item/gun/projectile/shotgun/doublebarrel,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/gun/projectile/pistol/holdout,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/zipgun
		)

	var/list/raider_holster = list(
		/obj/item/clothing/accessory/storage/holster/armpit,
		/obj/item/clothing/accessory/storage/holster/waist,
		/obj/item/clothing/accessory/storage/holster/hip
		)

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

/decl/special_role/raider/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	var/new_shoes =   pick(raider_shoes)
	var/new_uniform = pick(raider_uniforms)
	var/new_glasses = pick(raider_glasses)
	var/new_helmet =  pick(raider_helmets)
	var/new_suit =    pick(raider_suits)

	player.equip_to_slot_or_del(new new_shoes(player),slot_shoes_str)
	if(!player.shoes)
		//If equipping shoes failed, fall back to equipping sandals
		var/fallback_type = pick(/obj/item/clothing/shoes/sandal)
		player.equip_to_slot_or_del(new fallback_type(player), slot_shoes_str)

	player.equip_to_slot_or_del(new new_uniform(player),slot_w_uniform_str)
	player.equip_to_slot_or_del(new new_glasses(player),slot_glasses_str)
	player.equip_to_slot_or_del(new new_helmet(player),slot_head_str)
	player.equip_to_slot_or_del(new new_suit(player),slot_wear_suit_str)
	equip_weapons(player)

	var/obj/item/card/id/id = create_id("Visitor", player, equip = 0)
	id.SetName("[player.real_name]'s Passport")
	id.assignment = "Visitor"
	var/obj/item/storage/wallet/W = new(player)
	W.handle_item_insertion(id)
	if(player.equip_to_slot_or_del(W, slot_wear_id_str))
		var/obj/item/cash/cash = new(get_turf(player))
		cash.adjust_worth(rand(50,150)*10)
		player.put_in_hands(cash)
	create_radio(RAID_FREQ, player)

	return 1

/decl/special_role/raider/proc/equip_weapons(var/mob/living/carbon/human/player)
	var/new_gun = pick(raider_guns)
	var/new_holster = pick(raider_holster) //raiders don't start with any backpacks, so let's be nice and give them a holster if they can use it.
	var/turf/T = get_turf(player)

	var/obj/item/primary = new new_gun(T)
	var/obj/item/clothing/accessory/storage/holster/holster = null

	//Give some of the raiders a pirate gun as a secondary
	if(prob(60))
		var/obj/item/secondary = new /obj/item/gun/projectile/zipgun(T)
		if(!(primary.slot_flags & SLOT_HOLSTER))
			holster = new new_holster(T)
			var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
			H.holstered = secondary
			secondary.forceMove(holster)
		else
			player.equip_to_slot_or_del(secondary, slot_belt_str)

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new new_holster(T)
		var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
		H.holstered = primary
		primary.forceMove(holster)
	else if(!player.belt && (primary.slot_flags & SLOT_LOWER_BODY))
		player.equip_to_slot_or_del(primary, slot_belt_str)
	else if(!player.back && (primary.slot_flags & SLOT_BACK))
		player.equip_to_slot_or_del(primary, slot_back_str)
	else
		player.put_in_hands(primary)

	//If they got a projectile gun, give them a little bit of spare ammo
	equip_ammo(player, primary)

	if(holster)
		var/obj/item/clothing/under/uniform = player.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, player)
		else
			player.put_in_hands(holster)

/decl/special_role/raider/proc/equip_ammo(var/mob/living/carbon/human/player, var/obj/item/gun/gun)
	if(istype(gun, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/bullet_thrower = gun
		if(bullet_thrower.magazine_type)
			player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_l_store_str)
			if(prob(20)) //don't want to give them too much
				player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_r_store_str)
		else if(bullet_thrower.ammo_type)
			var/obj/item/storage/box/ammobox = new(get_turf(player.loc))
			for(var/i in 1 to rand(3,5) + rand(0,2))
				new bullet_thrower.ammo_type(ammobox)
			player.put_in_hands(ammobox)
		return
