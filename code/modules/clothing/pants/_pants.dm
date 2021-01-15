/obj/item/clothing/pants
	name = "pants"
	icon = 'icons/clothing/under/pants/pants.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	body_parts_covered = SLOT_LOWER_BODY|SLOT_LEGS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY // SLOT_LOWER_BODY when pants slot exists
	w_class = ITEM_SIZE_NORMAL
	force = 0
	made_of_cloth = TRUE
	valid_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_DECOR,
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_OVER
	)
	restricted_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_OVER
	)

/obj/item/clothing/pants/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform(0)
		M.update_inv_wear_id()
