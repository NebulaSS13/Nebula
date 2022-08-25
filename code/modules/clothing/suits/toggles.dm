///Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/hood
	var/suittoggled = 0

/obj/item/clothing/suit/storage/hooded/Initialize()
	. = ..()
	if(ispath(hood))
		hood = new hood(src)

/obj/item/clothing/suit/storage/hooded/Destroy()
	if(istype(hood))
		QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/ui_action_click()
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit_str)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	if(!hood)
		return
	suittoggled = 0
	update_icon()
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.drop_from_inventory(hood)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/dropped()
	. = ..()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/proc/ToggleHood()
	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing \the [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood, slot_head_str, 0, 0, 1)
				suittoggled = 1
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/on_update_icon()
	if(suittoggled)
		icon_state = "[initial(icon_state)]_t"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/clothing/suit/storage/hooded/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && suittoggled)
		overlay.icon_state += "_t"
	. = ..()

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon = 'icons/clothing/suit/wintercoat/coat.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	action_button_name = "Toggle Winter Hood"
	hood = /obj/item/clothing/head/winterhood
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/chems/drinks/flask)
	siemens_coefficient = 0.6
	protects_against_weather = TRUE

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/clothing/head/hood_winter.dmi'
	body_parts_covered = SLOT_HEAD
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCKHEADHAIR
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	protects_against_weather = TRUE

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "captain's winter coat"
	icon = 'icons/clothing/suit/wintercoat/captain.dmi'
	hood = /obj/item/clothing/head/winterhood/captain
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/captain
	icon = 'icons/clothing/head/hood_winter_captain.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	icon = 'icons/clothing/suit/wintercoat/sec.dmi'
	hood = /obj/item/clothing/head/winterhood/security
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/security
	icon = 'icons/clothing/head/hood_winter_sec.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	icon = 'icons/clothing/suit/wintercoat/med.dmi'
	hood = /obj/item/clothing/head/winterhood/medical
	armor = list(
		bio = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/head/winterhood/medical
	icon = 'icons/clothing/head/hood_winter_med.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	icon = 'icons/clothing/suit/wintercoat/sci.dmi'
	hood = /obj/item/clothing/head/winterhood/science
	armor = list(
		bomb = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/science
	icon = 'icons/clothing/head/hood_winter_sci.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon = 'icons/clothing/suit/wintercoat/eng.dmi'
	hood = /obj/item/clothing/head/winterhood/engineering
	armor = list(
		rad = ARMOR_RAD_MINOR
	)

/obj/item/clothing/head/winterhood/engineering
	icon = 'icons/clothing/head/hood_winter_eng.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	hood = /obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/suit/wintercoat/atmos.dmi'

/obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/head/hood_winter_atmos.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	hood = /obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/suit/wintercoat/hydro.dmi'

/obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/head/hood_winter_hydro.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	hood = /obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/suit/wintercoat/cargo.dmi'

/obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/head/hood_winter_cargo.dmi'

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	hood = /obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/suit/wintercoat/mining.dmi'
	armor = list(
		melee = ARMOR_MELEE_SMALL
	)

/obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/head/hood_winter_mining.dmi'

/obj/item/clothing/suit/storage/hooded/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon = 'icons/clothing/suit/hoodie.dmi'
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	action_button_name = "Toggle Hood"
	hood = /obj/item/clothing/head/hoodiehood

/obj/item/clothing/head/hoodiehood
	name = "hoodie hood"
	desc = "A hood attached to a warm sweatshirt."
	icon = 'icons/clothing/head/hood.dmi'
	body_parts_covered = SLOT_HEAD
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCKHEADHAIR
