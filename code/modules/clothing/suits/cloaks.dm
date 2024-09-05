/obj/item/clothing/suit/cloak // A colorable cloak
	name = "plain cloak"
	desc = "A simple, bland cloak."
	icon = 'icons/clothing/suits/cloaks/_cloak.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_OVER_BODY
	allowed = list(/obj/item/tank/emergency/oxygen)
	armor = list(ARMOR_MELEE = 0, ARMOR_BULLET = 0, ARMOR_LASER = 0,ARMOR_ENERGY = 0, ARMOR_BOMB = 0, ARMOR_BIO = 0, ARMOR_RAD = 0)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	siemens_coefficient = 0.9
	accessory_slot = ACCESSORY_SLOT_OVER
	accessory_visibility = ACCESSORY_VISIBILITY_ATTACHMENT

/obj/item/clothing/suit/cloak/on_update_icon()
	. = ..()
	underlays = list(image(icon, "[icon_state]-underlay"))

/obj/item/clothing/suit/cloak/random
	name = "cloak"
	desc = "A simple cloak."

/obj/item/clothing/suit/cloak/random/Initialize()
	color = get_random_colour(TRUE)
	. = ..()

// Takes material colour. TODO: Crafting recipe for cloth, fur, leather, etc. cloaks.
/obj/item/clothing/suit/cloak/crafted
	material = /decl/material/solid/organic/cloth
	color = /decl/material/solid/organic/cloth::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

// Cloaks should layer over and under everything, so set the layer directly rather
// than relying on overlay order. This also overlays over inhands but it looks ok.
/obj/item/clothing/suit/cloak/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)

	if(slot == slot_wear_suit_str || slot == slot_w_uniform_str)

		var/image/underlay
		var/image/cloverlay

		var/bodyicon = get_icon_for_bodytype(bodytype)
		var/decl/bodytype/root_bodytype = user_mob?.get_bodytype()
		if(root_bodytype && bodytype != root_bodytype.bodytype_category)
			underlay =  root_bodytype.get_offset_overlay_image(user_mob, bodyicon, "[bodytype]-underlay", color, slot)
			cloverlay = root_bodytype.get_offset_overlay_image(user_mob, bodyicon, "[bodytype]-overlay", color, slot)
		else
			underlay = image(bodyicon, "[bodytype]-underlay")
			cloverlay = image(bodyicon, "[bodytype]-overlay")

		underlay.layer = MOB_LAYER-0.01
		overlay.underlays = list(underlay)
		cloverlay.layer = MOB_LAYER+0.01
		overlay.overlays = list(cloverlay)

	. = overlay

/obj/item/clothing/suit/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the captain."
	icon = 'icons/clothing/suits/cloaks/cloak_captain.dmi'

/obj/item/clothing/suit/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon = 'icons/clothing/suits/cloaks/cloak_ce.dmi'

/obj/item/clothing/suit/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon = 'icons/clothing/suits/cloaks/cloak_cmo.dmi'

/obj/item/clothing/suit/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon = 'icons/clothing/suits/cloaks/cloak_hop.dmi'

/obj/item/clothing/suit/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon = 'icons/clothing/suits/cloaks/cloak_rd.dmi'

/obj/item/clothing/suit/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon = 'icons/clothing/suits/cloaks/cloak_qm.dmi'

/obj/item/clothing/suit/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon = 'icons/clothing/suits/cloaks/cloak_hos.dmi'

/obj/item/clothing/suit/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_cargo.dmi'

/obj/item/clothing/suit/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_mining.dmi'

/obj/item/clothing/suit/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_security.dmi'

/obj/item/clothing/suit/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_service.dmi'

/obj/item/clothing/suit/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_engineer.dmi'

/obj/item/clothing/suit/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_atmospherics.dmi'

/obj/item/clothing/suit/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_research.dmi'

/obj/item/clothing/suit/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon = 'icons/clothing/suits/cloaks/cloak_medical.dmi'

/obj/item/clothing/suit/cloak/hide
	name = "cloak"
	desc = "A ragged cloak made of some sort of thick hide."
	icon = 'icons/clothing/suits/cloaks/cloak_hide.dmi'
	material = /decl/material/solid/organic/leather
	color = /decl/material/solid/organic/leather::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	armor_type = /datum/extension/armor/ablative
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	material_armor_multiplier = 0.5

/obj/item/clothing/suit/cloak/hide/set_material(var/new_material)
	..()
	if(istype(material))
		desc = "A ragged cloak made of [material.solid_name]."
