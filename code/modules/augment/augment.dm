/obj/item/organ/internal/augment
	name = "embedded augment"
	desc = "An embedded augment."
	icon = 'icons/obj/augment.dmi'
	//By default these fit on both flesh and robotic organs and are robotic
	status = ORGAN_PROSTHETIC
	default_action_type = /datum/action/item_action/organ/augment
	material = /decl/material/solid/metal/steel
	origin_tech = "{'materials':1,'magnets':2,'engineering':2,'biotech':1}"

	var/descriptor = ""
	var/known = TRUE
	var/augment_flags = AUGMENTATION_MECHANIC | AUGMENTATION_ORGANIC
	var/list/allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)

/obj/item/organ/internal/augment/Initialize()
	. = ..()
	organ_tag = pick(allowed_organs)
	update_parent_organ()

//General expectation is onInstall and onRemoved are overwritten to add effects to augmentee
/obj/item/organ/internal/augment/on_add_effects()
	if(..() && istype(owner))
		onInstall()

/obj/item/organ/internal/augment/on_remove_effects(mob/living/last_owner)
	onRemove()
	. = ..()

//#FIXME: merge those with removal/install functions
/obj/item/organ/internal/augment/proc/onInstall()
	return
/obj/item/organ/internal/augment/proc/onRemove()
	return

/obj/item/organ/internal/augment/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W) && allowed_organs.len > 1)
		//Here we can adjust location for implants that allow multiple slots
		organ_tag = input(user, "Adjust installation parameters") as null|anything in allowed_organs
		update_parent_organ()
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return
	..()

/obj/item/organ/internal/augment/proc/update_parent_organ()
	//This tries to match a parent organ to an augment slot
	//This is intended to match the possible positions to a parent organ

	if(organ_tag == BP_AUGMENT_L_LEG)
		parent_organ = BP_L_LEG
		descriptor = "left leg."
	else if(organ_tag == BP_AUGMENT_R_LEG)
		parent_organ = BP_R_LEG
		descriptor = "right leg."
	else if(organ_tag == BP_AUGMENT_L_HAND)
		parent_organ = BP_L_HAND
		descriptor = "left hand."
	else if(organ_tag == BP_AUGMENT_R_HAND)
		parent_organ = BP_R_HAND
		descriptor = "right hand."
	else if(organ_tag == BP_AUGMENT_L_ARM)
		parent_organ = BP_L_ARM
		descriptor = "left arm."
	else if(organ_tag == BP_AUGMENT_R_ARM)
		parent_organ = BP_R_ARM
		descriptor = "right arm."
	else if(organ_tag == BP_AUGMENT_HEAD)
		parent_organ = BP_HEAD
		descriptor = "head."
	else if(organ_tag == BP_AUGMENT_CHEST_ACTIVE || organ_tag == BP_AUGMENT_CHEST_ARMOUR)
		parent_organ = BP_CHEST
		descriptor = "chest."


/obj/item/organ/internal/augment/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "It is configured to be attached to the [descriptor].")
		if(augment_flags & AUGMENTATION_MECHANIC && augment_flags & AUGMENTATION_ORGANIC)
			to_chat(user, "It can interface with both prosthetic and fleshy organs.")
		else
			if(augment_flags & AUGMENTATION_MECHANIC)
				to_chat(user, "It can interface with prosthetic organs.")
			else if(augment_flags & AUGMENTATION_ORGANIC)
				to_chat(user, "It can interface with fleshy organs.")
