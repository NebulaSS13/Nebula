/obj/item/projectile/get_base_value()
	. = -5 * distance_falloff
	. += damage
	. += armor_penetration
	. += penetration_modifier * 20
	if(nodamage)
		. -= 100
	if(damage_flags & DAM_BULLET)
		. += 50
	var/effects_value = 0
	effects_value += stun	   * 5
	effects_value += weaken    * 5
	effects_value += paralyze  * 10
	effects_value += irradiate * 1.5
	effects_value += agony
	effects_value += stutter
	effects_value += eyeblur
	effects_value += drowsy
	. += effects_value
	if(embed)
		. += 50
	if(hitscan)
		. += 100
	. = max(round(. * 0.1)+..(), 1)

/obj/item/projectile/ion/get_base_value()
	. = ..() + (heavy_effect_range * 10) + (light_effect_range * 5)