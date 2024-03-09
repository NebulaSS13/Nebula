/obj/item/organ/internal/augment/armor
	name = "subdermal armor"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "A flexible composite mesh designed to prevent tearing and puncturing of underlying tissue."
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":4,"engineering":2,"biotech":3}'
	var/brute_mult = 0.8
	var/burn_mult = 1