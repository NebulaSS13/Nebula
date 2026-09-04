/obj/item/clothing/suit/armor/forged
	abstract_type             = /obj/item/clothing/suit/armor/forged
	icon_state                = ICON_STATE_WORLD
	material                  = /decl/material/solid/metal/steel
	color                     = /decl/material/solid/metal/steel::color
	material_alteration       = MAT_FLAG_ALTERATION_ALL
	armor_degradation_speed   = 1
	armor_type                = /datum/extension/armor/ablative
	material_armor_multiplier = 1
	valid_accessory_slots = list(
		ACCESSORY_SLOT_OVER,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_ARMOR_A,
		ACCESSORY_SLOT_ARMOR_L,
		ACCESSORY_SLOT_GREAVES,
		ACCESSORY_SLOT_GAUNTLETS
	)
	restricted_accessory_slots = list(
		ACCESSORY_SLOT_OVER,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_ARMOR_A,
		ACCESSORY_SLOT_ARMOR_L,
		ACCESSORY_SLOT_GREAVES,
		ACCESSORY_SLOT_GAUNTLETS
	)
	armor = list(
		ARMOR_MELEE  = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER  = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB   = ARMOR_BOMB_PADDED
	)
	var/decl/material/strap_material  = /decl/material/solid/organic/leather
	var/decl/material/detail_material = /decl/material/solid/metal/bronze

/obj/item/clothing/suit/armor/forged/Initialize()
	if(strap_material)
		strap_material = GET_DECL(strap_material)
		LAZYSET(matter, strap_material.type, MATTER_AMOUNT_TRACE)
	if(detail_material)
		detail_material = GET_DECL(detail_material)
		LAZYSET(matter, detail_material.type, MATTER_AMOUNT_TRACE)
	. = ..()
	update_icon()

/obj/item/clothing/suit/armor/forged/on_update_icon()
	. = ..()
	if(strap_material)
		add_overlay(overlay_image(icon, "[icon_state]-straps", strap_material.color, RESET_COLOR))
	if(detail_material)
		add_overlay(overlay_image(icon, "[icon_state]-detail", detail_material.color, RESET_COLOR))

/obj/item/clothing/suit/armor/forged/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(strap_material)
			overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-straps", strap_material.color, RESET_COLOR)
		if(detail_material)
			overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-detail", detail_material.color, RESET_COLOR)
	return ..()
