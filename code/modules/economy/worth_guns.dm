// Can't think of a good way to get gun price from projectile (due to
// firemodes, projectile types, etc) so this'll have to  do for now.

/obj/item/gun/get_base_value()
	. = 0
	if(silenced)
		. += 20
	. += one_hand_penalty * -2
	. += bulk * -5
	. += accuracy * 10
	. += scoped_accuracy * 5
	if(!autofire_enabled)
		for(var/datum/firemode/F in firemodes)
			if(F.settings["autofire_enabled"])
				. += 100
	. *= 10
	. += ..()

/obj/item/gun/energy/get_base_value()
	. = ..()
	if(self_recharge)
		. += 500
	var/projectile_value = 1
	if(projectile_type)
		projectile_value = atom_info_repository.get_combined_worth_for(projectile_type)
	for(var/datum/firemode/F in firemodes)
		if(F.settings["projectile_type"])
			projectile_value = max(projectile_value, atom_info_repository.get_combined_worth_for(F.settings["projectile_type"]))
	. += (!accepts_cell_type ? max_shots : 5) * projectile_value

/obj/item/gun/projectile/get_base_value()
	. = ..()
	if(load_method & (SINGLE_CASING|SPEEDLOADER))
		var/projectile_value = ammo_type ? atom_info_repository.get_combined_worth_for(ammo_type) : 1
		. += 0.5 * projectile_value * max_shells
	else if(load_method & MAGAZINE)
		if(auto_eject)
			. += 20
		var/obj/item/ammo_magazine/mag = magazine_type
		var/mag_type = initial(mag.ammo_type)
		var/projectile_value = mag_type ? atom_info_repository.get_combined_worth_for(mag_type) : 1
		. += 0.5 * projectile_value * initial(mag.max_ammo)

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