/obj/item/clothing/head/hood/cloak
	icon = 'icons/clothing/head/hood_cloak.dmi'

/obj/item/clothing/suit/hooded_cloak
	name = "hooded cloak"
	desc = "A voluminous hooded cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_hooded.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_OVER_BODY
	allowed = list(/obj/item/tank/emergency/oxygen)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	accessory_slot = ACCESSORY_SLOT_OVER
	accessory_visibility = ACCESSORY_VISIBILITY_ATTACHMENT
	hood = /obj/item/clothing/head/hood/cloak
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/clothing/suit/hooded_cloak/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/buttons),
		GET_DECL(/decl/clothing_state_modifier/hood)
	)
	return expected_state_modifiers
