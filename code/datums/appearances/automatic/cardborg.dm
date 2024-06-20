/decl/appearance_handler/cardborg
	var/static/list/appearances

/decl/appearance_handler/cardborg/proc/item_equipped(var/obj/item/item, var/mob/user, var/slot)
	if(!(slot == slot_head_str || slot == slot_wear_suit_str || slot == slot_back_str))
		return
	if(!ishuman(user))
		return
	if(!(istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg) || istype(item, /obj/item/backpack)))
		return
	if(user in appearance_sources)
		return

	var/mob/living/human/H = user
	if(!(istype(H.get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/cardborg) && istype(H.get_equipped_item(slot_head_str), /obj/item/clothing/head/cardborg) && istype(H.get_equipped_item(slot_back_str), /obj/item/backpack)))
		return

	var/image/I = get_image_from_backpack(H)
	AddAltAppearance(H, I, global.silicon_mob_list+H) //you look like a robot to robots! (including yourself because you're totally a robot)
	events_repository.register_global(/decl/observ/logged_in, src, TYPE_PROC_REF(/decl/appearance_handler/cardborg, mob_joined))	// Duplicate registration request are handled for us

/decl/appearance_handler/cardborg/proc/item_removed(var/obj/item/item, var/mob/user)
	if((istype(item, /obj/item/clothing/suit/cardborg) || istype(item, /obj/item/clothing/head/cardborg)) || istype(item, /obj/item/backpack))
		RemoveAltAppearance(user)
		if(!appearance_sources.len)
			events_repository.unregister_global(/decl/observ/logged_in, src)	// Only listen to the logged in event for as long as it's relevant

/decl/appearance_handler/cardborg/proc/mob_joined(var/mob/user)
	if(issilicon(user))
		DisplayAllAltAppearancesTo(user)

/decl/appearance_handler/cardborg/proc/get_image_from_backpack(var/mob/living/human/H)
	init_appearances()
	var/obj/item/back = H.get_equipped_item(slot_back_str)
	if(!istype(back))
		return
	var/decl/cardborg_appearance/ca = appearances[back.type]
	if(!ca) ca = appearances[/obj/item/backpack]

	var/image/I = image(icon = ca.icon, icon_state = ca.icon_state, loc = H)
	I.override = 1
	I.overlays += image(icon = ca.icon, icon_state = "[ca.icon_state]-eyes") //gotta look realistic
	return I

/decl/appearance_handler/cardborg/proc/init_appearances()
	if(!appearances)
		appearances = list()
		for(var/decl/cardborg_appearance/ca in init_subtypes(/decl/cardborg_appearance))
			appearances[ca.backpack_type] = ca

/decl/cardborg_appearance
	var/backpack_type
	var/icon_state = ICON_STATE_WORLD
	var/icon = 'icons/mob/robots/robot.dmi'
	backpack_type = /obj/item/backpack

/decl/cardborg_appearance/standard

/decl/cardborg_appearance/standard/satchel1
	backpack_type = /obj/item/backpack/satchel

/decl/cardborg_appearance/standard/satchel2
	backpack_type = /obj/item/backpack/satchel/grey

/decl/cardborg_appearance/engineering
	icon = 'icons/mob/robots/robot_engineer_old.dmi'
	backpack_type = /obj/item/backpack/industrial

/decl/cardborg_appearance/engineering/satchel
	backpack_type = /obj/item/backpack/satchel/eng

/decl/cardborg_appearance/medical
	icon = 'icons/mob/robots/robot_medical_old.dmi'
	backpack_type = /obj/item/backpack/medic

/decl/cardborg_appearance/medical/satchel
	backpack_type = /obj/item/backpack/satchel/med

/decl/cardborg_appearance/science
	icon = 'icons/mob/robots/robot_droid_science.dmi'
	backpack_type = /obj/item/backpack/toxins

/decl/cardborg_appearance/security
	icon = 'icons/mob/robots/robot_security_old.dmi'
	backpack_type = /obj/item/backpack/security

/decl/cardborg_appearance/security/satchel
	backpack_type = /obj/item/backpack/satchel/sec

/decl/cardborg_appearance/centcom
	icon = 'icons/mob/robots/robot_centcomm.dmi'
	backpack_type = /obj/item/backpack/captain

/decl/cardborg_appearance/centcom/satchel
	backpack_type = /obj/item/backpack/satchel/cap

/decl/cardborg_appearance/syndicate
	icon = 'icons/mob/robots/robot_combat.dmi'
	backpack_type = /obj/item/backpack/dufflebag/syndie

/decl/cardborg_appearance/syndicate/med
	backpack_type = /obj/item/backpack/dufflebag/syndie/med

/decl/cardborg_appearance/syndicate/ammo
	backpack_type = /obj/item/backpack/dufflebag/syndie/ammo
