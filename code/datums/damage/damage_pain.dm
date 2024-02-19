/decl/damage_handler/pain
	name                               = "pain"
	usable_with_backstab               = TRUE
	causes_limb_damage                 = TRUE
	projectile_damage_divisor          = 3
	projectile_damages_assembly_casing = FALSE
	category_type                      = /decl/damage_handler/pain


/decl/damage_handler/pain/damage_limb(var/obj/item/organ/external/organ, var/damage, var/damage_flags = 0, used_weapon)
	organ.add_pain(damage)
	return TRUE
