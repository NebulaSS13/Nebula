/obj/item/organ/internal/augment/armor
	name = "subdermal armor"
	allowed_organs = list(BP_AUGMENT_CHEST_ARMOUR)
	icon_state = "armor-chest"
	desc = "A flexible composite mesh designed to prevent tearing and puncturing of underlying tissue."
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":4,"engineering":2,"biotech":3}'
	var/brute_mult = 0.8
	var/burn_mult = 1

/obj/item/organ/internal/augment/armor/reset_matter()
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

// override to add armor augment damage mods
/obj/item/organ/external/get_brute_mod(var/damage_flags)
	. = ..()
	var/obj/item/organ/internal/augment/armor/armor_augment = owner?.get_organ(BP_AUGMENT_CHEST_ARMOUR, /obj/item/organ/internal/augment/armor)
	if(armor_augment)
		. *= armor_augment.brute_mult

// override to add armor augment damage mods
/obj/item/organ/external/get_burn_mod(var/damage_flags)
	. = ..()
	var/obj/item/organ/internal/augment/armor/armor_augment = owner?.get_organ(BP_AUGMENT_CHEST_ARMOUR, /obj/item/organ/internal/augment/armor)
	if(armor_augment)
		. *= armor_augment.burn_mult