/obj/item/clothing/head/champhelm
	name = "champion's crown"
	desc = "A spiky, golden crown. It's probably worth more than your bank account."

	icon = 'icons/clothing/head/champion.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
		)
	bodytype_restricted = list(BODYTYPE_HUMANOID)

/obj/item/clothing/suit/champarmor
	name = "champion's armor"
	desc = "A mighty suit of silver and gold armor, with a gleaming blue crystal inlaid into its left gaunlet."
	icon = 'icons/clothing/suit/wizard/servant/champion.dmi'
	siemens_coefficient = 0.5
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/bluetunic
	name = "blue tunic"
	desc = "A royal blue tunic. Beautifully archaic."
	icon_state = "bluetunic"
	siemens_coefficient = 0.8
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		melee = ARMOR_MELEE_MINOR
	)
	bodytype_restricted = list(BODYTYPE_HUMANOID)

/obj/item/clothing/shoes/jackboots/medievalboots
	name = "leather boots"
	desc = "Old-fashioned leather boots. Probably not something you want to get kicked with."
	material = /decl/material/solid/leather
	force = 5
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	artificail_shine = 0

/obj/item/sword/excalibur
	name = "champion's blade"
	desc = "<i>For at his belt hung Excalibur, the finest sword that there was, which sliced through iron as through wood.</i>"
	icon = 'icons/obj/items/weapon/swords/excalibur.dmi'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "cleaved", "sundered")
	applies_material_colour = FALSE
	applies_material_name = FALSE

/obj/item/sword/excalibur/pickup(var/mob/living/user)
	if(user.mind)
		var/decl/special_role/wizard/wizards = decls_repository.get_decl(/decl/special_role/wizard)
		if(!wizards.is_antagonist(user.mind) || user.mind.assigned_special_role != "Spellbound Servant")
			START_PROCESSING(SSobj, src)
			to_chat(user,"<span class='danger'>\The [src] heats up in your hands, burning you!</span>")

/obj/item/sword/excalibur/Process()
	if(isliving(loc))
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			var/obj/item/organ/external/E = H.get_organ(H.get_active_held_item_slot())
			E?.take_external_damage(burn=2,used_weapon="stovetop")
		else
			var/mob/living/M = loc
			M.adjustFireLoss(2)
		if(prob(2))
			to_chat(loc,"<span class='danger'>\The [src] is burning you!</span>")
	return 1

/obj/item/sword/excalibur/dropped()
	STOP_PROCESSING(SSobj, src)