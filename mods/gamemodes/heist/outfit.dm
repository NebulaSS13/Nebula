/decl/outfit/raider
	name =  "Special Role - Raider"
	l_ear = /obj/item/radio/headset/raider
	id_type = /obj/item/card/id/syndicate
	var/list/raider_uniforms = list(
		/obj/item/clothing/costume/soviet,
		/obj/item/clothing/costume/pirate,
		/obj/item/clothing/costume/redcoat,
		/obj/item/clothing/costume/captain_fly
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
		/obj/item/clothing/suit/jacket/bomber,
		/obj/item/clothing/suit/jacket/leather,
		/obj/item/clothing/suit/jacket/brown,
		/obj/item/clothing/suit/jacket/hoodie,
		/obj/item/clothing/suit/jacket/hoodie/black,
		/obj/item/clothing/suit/poncho,
	)
	var/list/raider_guns = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/projectile/revolver/lasvolver,
		/obj/item/gun/energy/xray,
		/obj/item/gun/energy/toxgun,
		/obj/item/gun/energy/ionrifle,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/crossbow/largecrossbow,
		/obj/item/gun/launcher/bow/crossbow/powered,
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
		/obj/item/clothing/webbing/holster/armpit,
		/obj/item/clothing/webbing/holster/waist,
		/obj/item/clothing/webbing/holster/hip
	)

/decl/outfit/raider/Initialize()
	randomize_clothing()
	. = ..()

/decl/outfit/raider/equip_outfit(mob/living/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	randomize_clothing()
	. = ..()
	if(. && H)
		if(!H.get_equipped_item(slot_shoes_str))
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes_str)

		var/new_gun = pick(raider_guns)
		var/new_holster = pick(raider_holster) //raiders don't start with any backpacks, so let's be nice and give them a holster if they can use it.
		var/turf/T = get_turf(H)

		var/obj/item/primary = new new_gun(T)
		var/obj/item/clothing/webbing/holster/holster = null

		//Give some of the raiders a pirate gun as a secondary
		if(prob(60))
			var/obj/item/secondary = new /obj/item/gun/projectile/zipgun(T)
			if(!(primary.slot_flags & SLOT_HOLSTER))
				holster = new new_holster(T)
				var/datum/extension/holster/holster_extension = get_extension(holster, /datum/extension/holster)
				holster_extension.holstered = secondary
				secondary.forceMove(holster)
			else
				H.equip_to_slot_or_del(secondary, slot_belt_str)

		if(primary.slot_flags & SLOT_HOLSTER)
			holster = new new_holster(T)
			var/datum/extension/holster/holster_extension = get_extension(holster, /datum/extension/holster)
			holster_extension.holstered = primary
			primary.forceMove(holster)
		else if(!H.get_equipped_item(slot_belt_str) && (primary.slot_flags & SLOT_LOWER_BODY))
			H.equip_to_slot_or_del(primary, slot_belt_str)
		else if(!H.get_equipped_item(slot_back_str) && (primary.slot_flags & SLOT_BACK))
			H.equip_to_slot_or_del(primary, slot_back_str)
		else
			H.put_in_hands(primary)

		if(istype(primary, /obj/item/gun/projectile))
			var/obj/item/gun/projectile/bullet_thrower = primary
			if(bullet_thrower.magazine_type)
				H.equip_to_slot_or_del(new bullet_thrower.magazine_type(H), slot_l_store_str)
				if(prob(20)) //don't want to give them too much
					H.equip_to_slot_or_del(new bullet_thrower.magazine_type(H), slot_r_store_str)
			else if(bullet_thrower.ammo_type)
				var/obj/item/box/ammobox = new(get_turf(H.loc))
				for(var/i in 1 to rand(3,5) + rand(0,2))
					new bullet_thrower.ammo_type(ammobox)
				H.put_in_hands(ammobox)

		if(holster)
			var/obj/item/clothing/uniform = H.get_equipped_item(slot_w_uniform_str)
			if(istype(uniform) && uniform.can_attach_accessory(holster))
				uniform.attackby(holster, H)
			else
				H.put_in_hands(holster)

/decl/outfit/raider/proc/randomize_clothing()
	shoes =   pick(raider_shoes)
	uniform = pick(raider_uniforms)
	glasses = pick(raider_glasses)
	head =  pick(raider_helmets)
	suit =    pick(raider_suits)
