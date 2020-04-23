/obj/item/projectile/get_single_monetary_worth()
	if(!holographic)
		. = damage
		. += max(0, SSfabrication.distance_falloff_base_value - distance_falloff)
		. += penetrating * SSfabrication.projectile_penetration_multiplier
		. += penetration_modifier * SSfabrication.projectile_penetration_modifier_multiplier
		. += (stun + weaken + paralyze + irradiate + stutter + eyeblur + drowsy + agony + embed) * SSfabrication.projectile_status_multiplier
		. = max(round(.), 1)

// Can't think of a good way to get gun price from projectile (due to 
// firemodes, projectile types, etc) so this'll have to  do for now.
/obj/item/gun/get_base_value()
	. = 100

/obj/item/gun/energy/get_base_value()
	. = 150
