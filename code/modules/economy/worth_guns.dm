/obj/item/projectile/get_single_monetary_worth()
	. = damage
	. += max(0, 5 - distance_falloff)
	. += penetrating * 0.2
	. += penetration_modifier * 0.1
	. += (stun + weaken + paralyze + irradiate + stutter + eyeblur + drowsy + agony + embed) * 0.2
	. = max(round(.), 1)

// Can't think of a good way to get gun price from projectile (due to 
// firemodes, projectile types, etc) so this'll have to  do for now.
/obj/item/gun/get_base_value()
	. = 100

/obj/item/gun/energy/get_base_value()
	. = 150
