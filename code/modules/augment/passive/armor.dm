/obj/item/organ/internal/augment/armor
	name = "subdermal armor"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "A flexible composite mesh designed to prevent tearing and puncturing of underlying tissue."
	matter = list(
		MAT_STEEL = MATTER_AMOUNT_PRIMARY,
		MAT_GLASS = MATTER_AMOUNT_REINFORCEMENT
	)
	var/brute_mult = 0.8
	var/burn_mult = 1