/obj/item/organ/internal/augment/armor
	name = "subdermal armor"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "A flexible composite mesh designed to prevent tearing and puncturing of underlying tissue."
	material_composition = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/glass = MATTER_AMOUNT_TERTIARY
	)
	origin_tech = "{'materials':4,'engineering':2,'biotech':3}"
	var/brute_mult = 0.8
	var/burn_mult = 1