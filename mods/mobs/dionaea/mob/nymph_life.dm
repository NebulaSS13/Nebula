//Dionaea regenerate health and nutrition in light.
/mob/living/carbon/alien/diona/handle_environment(datum/gas_mixture/environment)

	..()

	if(stat == DEAD)
		return

	var/turf/checking = get_turf(src)
	if(!checking)
		return

	var/light_amount = checking.get_lumcount() * 5

	var/rads = get_damage(IRRADIATE)
	if(rads <= 20)
		if(last_glow)
			set_light(0)
			last_glow = 0
	else
		var/mult = clamp(rads/200, 0.5, 1)
		if(last_glow != mult)
			set_light((5 * mult), mult, "#55ff55")
			last_glow = mult

	set_nutrition(clamp(nutrition + FLOOR(rads/100) + light_amount, 0, 500))

	if(rads >= 50 || light_amount > 2) //if there's enough light, heal
		var/update_health = FALSE
		if(get_damage(BRUTE))
			update_health = TRUE
			heal_damage(1, BRUTE, skip_update_health = TRUE)
		if(get_damage(BURN))
			update_health = TRUE
			heal_damage(1, BURN, skip_update_health = TRUE)
		if(get_damage(TOX))
			update_health = TRUE
			heal_damage(1, TOX, skip_update_health = TRUE)
		if(get_damage(OXY))
			update_health = TRUE
			heal_damage(1, OXY, skip_update_health = TRUE)
		if(update_health)
			update_health()