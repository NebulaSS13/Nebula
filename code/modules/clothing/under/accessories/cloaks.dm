/obj/item/clothing/accessory/cloak // A colorable cloak
	name = "plain cloak"
	desc = "A simple, bland cloak."
	icon = 'icons/clothing/suit/cloaks/_cloak.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER
	slot_flags = SLOT_OVER_BODY
	allowed = list(/obj/item/tank/emergency/oxygen)
	high_visibility = TRUE
	made_of_cloth = TRUE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS
	siemens_coefficient = 0.9
	on_mob_use_spritesheets = TRUE

/obj/item/clothing/accessory/cloak/on_update_icon()
	. = ..()
	underlays = list(image(icon, "[icon_state]-underlay"))

/obj/item/clothing/accessory/cloak/random
	name = "cloak"
	desc = "A simple cloak."

/obj/item/clothing/accessory/cloak/random/Initialize()
	color = get_random_colour(TRUE)
	. = ..()

// Cloaks should layer over and under everything, so set the layer directly rather 
// than relying on overlay order. This also overlays over inhands but it looks ok.
/obj/item/clothing/accessory/cloak/apply_overlays(mob/user_mob, bodytype, image/overlay, slot)

	if(slot == slot_wear_suit_str || slot == slot_tie_str || slot == slot_w_uniform_str)

		var/image/underlay
		var/image/cloverlay

		var/bodyicon = get_icon_for_bodytype(bodytype)
		if(bodytype != lowertext(user_mob.get_bodytype()))
			var/mob/living/carbon/human/H = user_mob
			underlay =  H.species.get_offset_overlay_image(FALSE, bodyicon, "[bodytype]-underlay", color, slot)
			cloverlay = H.species.get_offset_overlay_image(FALSE, bodyicon, "[bodytype]-overlay", color, slot)
		else
			underlay = image(bodyicon, "[bodytype]-underlay")
			cloverlay = image(bodyicon, "[bodytype]-overlay")

		underlay.layer = MOB_LAYER-0.01
		overlay.underlays = list(underlay)
		cloverlay.layer = MOB_LAYER+0.01
		overlay.overlays = list(cloverlay)

	. = overlay

/obj/item/clothing/accessory/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the captain."
	icon = 'icons/clothing/suit/cloaks/cloak_captain.dmi'

/obj/item/clothing/accessory/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon = 'icons/clothing/suit/cloaks/cloak_ce.dmi'

/obj/item/clothing/accessory/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon = 'icons/clothing/suit/cloaks/cloak_cmo.dmi'

/obj/item/clothing/accessory/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon = 'icons/clothing/suit/cloaks/cloak_hop.dmi'

/obj/item/clothing/accessory/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon = 'icons/clothing/suit/cloaks/cloak_rd.dmi'

/obj/item/clothing/accessory/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon = 'icons/clothing/suit/cloaks/cloak_qm.dmi'

/obj/item/clothing/accessory/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the head of security."
	icon = 'icons/clothing/suit/cloaks/cloak_hos.dmi'

/obj/item/clothing/accessory/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_cargo.dmi'

/obj/item/clothing/accessory/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_mining.dmi'

/obj/item/clothing/accessory/cloak/security
	name = "red cloak"
	desc = "A simple red and black cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_security.dmi'

/obj/item/clothing/accessory/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_service.dmi'

/obj/item/clothing/accessory/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_engineer.dmi'

/obj/item/clothing/accessory/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_atmospherics.dmi'

/obj/item/clothing/accessory/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_research.dmi'

/obj/item/clothing/accessory/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak."
	icon = 'icons/clothing/suit/cloaks/cloak_medical.dmi'

/obj/item/clothing/accessory/cloak/hide
	name = "cloak"
	desc = "A ragged cloak made of some sort of thick hide."
	icon = 'icons/clothing/suit/cloaks/cloak_hide.dmi'
	material = /decl/material/solid/leather
	applies_material_colour = TRUE
	applies_material_name = TRUE
	armor_type = /datum/extension/armor/ablative
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	material_armor_multiplier = 0.5

/obj/item/clothing/accessory/cloak/hide/set_material(var/new_material)
	..()
	if(istype(material))
		desc = "A ragged cloak made of [material.solid_name]."
