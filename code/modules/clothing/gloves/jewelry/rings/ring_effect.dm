/obj/item/clothing/gloves/ring/effect
	icon                = 'icons/clothing/accessories/jewelry/rings/ring_band_thick.dmi'
	can_inscribe        = FALSE
	material            = /decl/material/solid/metal/silver
	abstract_type       = /obj/item/clothing/gloves/ring/effect
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	var/granted_effect

/obj/item/clothing/gloves/ring/effect/update_name()
	return

/obj/item/clothing/gloves/ring/effect/Initialize()
	if(granted_effect)
		add_item_effect(granted_effect, list(
			(IE_CAT_EXAMINE),
			(IE_CAT_WIELDED)
		))
	. = ..()
