// Used by items calculating worth based on armour.
/obj/item/proc/get_max_weapon_value()
	return force

/obj/item/get_base_value()

	if(holographic)
		return 0

	. = ..()

	if(origin_tech)
		var/largest_tech_val = 0
		var/list/tech = cached_json_decode(origin_tech)
		for(var/t in tech)
			var/next_tech_val = (tech[t]**2) * SSfabrication.tech_level_value
			if(next_tech_val > largest_tech_val)
				largest_tech_val = next_tech_val
			. += largest_tech_val

	if(force)
		var/weapon_value = ((get_max_weapon_value() * SSfabrication.force_weapon_value) * (SSfabrication.edged_weapon_multiplier * (1 + max(sharp, edge))))
		if(attack_cooldown <= FAST_WEAPON_COOLDOWN)
			weapon_value *= SSfabrication.fast_weapon_value
		else if(attack_cooldown >= SLOW_WEAPON_COOLDOWN)
			weapon_value *= SSfabrication.slow_weapon_value
		. += round(weapon_value)
	. += (base_parry_chance * SSfabrication.parry_value_multiplier)
	. += melee_accuracy_bonus * SSfabrication.accuracy_value_multiplier

	var/total_coverage = get_percentage_body_cover(body_parts_covered)
	var/cold_value = (SSfabrication.heat_protection_multiplier * (-(min_cold_protection_temperature)/T20C) * get_percentage_body_cover(cold_protection))
	var/heat_value = (SSfabrication.heat_protection_multiplier *   (max_heat_protection_temperature/T20C)  * get_percentage_body_cover(heat_protection))
	var/additional_value = cold_value + heat_value

	if(total_coverage > 0)

		var/shock_protection  =  ((1-siemens_coefficient) * SSfabrication.general_protection_value_multiplier) * total_coverage
		var/gas_leak_value =     ((1-gas_transfer_coefficient) * SSfabrication.general_protection_value_multiplier) * total_coverage
		var/permeability_value = ((1-permeability_coefficient) * SSfabrication.general_protection_value_multiplier) * total_coverage
		var/pressure_protection = Floor(abs(max_pressure_protection - min_pressure_protection)/ONE_ATMOSPHERE)

		additional_value += shock_protection + gas_leak_value + permeability_value + pressure_protection

		if(LAZYLEN(armor))
			var/armour_value
			for(var/atype in armor)
				var/adding_armour_value = SSfabrication.base_armour_worth * (armor[atype]/SSfabrication.mundane_armour_value)
				armour_value += adding_armour_value
			if(armour_value)
				// TODO; use armor_degradation_speed as a negative coefficient
				additional_value += (armour_value*total_coverage)

		if(item_flags)
			if(item_flags & ITEM_FLAG_THICKMATERIAL)
				additional_value += (SSfabrication.item_flag_value * total_coverage)
			if(item_flags & ITEM_FLAG_AIRTIGHT)
				additional_value += (SSfabrication.item_flag_value * total_coverage)

	if(item_flags)
		for(var/flag in list(ITEM_FLAG_PADDED, ITEM_FLAG_NOSLIP, ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT, ITEM_FLAG_SILENT, ITEM_FLAG_NOCUFFS))
			if(item_flags & flag)
				additional_value += SSfabrication.item_flag_value

	. = round(. + additional_value)
