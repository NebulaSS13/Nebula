/decl/damage_handler/genetic
	name                 = "genetic"
	usable_with_backstab = TRUE
	causes_limb_damage   = TRUE
	category_type        = /decl/damage_handler/genetic

/decl/damage_handler/genetic/damage_limb(var/obj/item/organ/external/organ, var/damage, var/damage_flags = 0, used_weapon)
	organ.add_genetic_damage(damage)
	return TRUE
