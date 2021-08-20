// Used by items calculating worth based on armour.
#define MUNDANE_ARMOUR_VALUE 20
#define BASE_ARMOUR_WORTH    50

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
			var/next_tech_val = (tech[t]**2) * 5
			if(next_tech_val > largest_tech_val)
				largest_tech_val = next_tech_val
			. += largest_tech_val

	if(force)
		var/weapon_value = ((get_max_weapon_value() * 15) * (1 + max(sharp, edge)))
		if(attack_cooldown <= FAST_WEAPON_COOLDOWN)
			weapon_value *= 1.5
		else if(attack_cooldown >= SLOW_WEAPON_COOLDOWN)
			weapon_value *= 0.5
		. += round(weapon_value)
	. += (base_parry_chance * 5)
	. += melee_accuracy_bonus * 2

	var/total_coverage = get_percentage_body_cover(body_parts_covered)
	var/cold_value = (5 * (-(min_cold_protection_temperature)/T20C) * get_percentage_body_cover(cold_protection))
	var/heat_value = (5 *   (max_heat_protection_temperature/T20C)  * get_percentage_body_cover(heat_protection))
	var/additional_value = cold_value + heat_value

	if(total_coverage > 0)

		var/shock_protection  = ((1-siemens_coefficient) * 20) * total_coverage
		var/gas_leak_value = ((1-gas_transfer_coefficient) * 20) * total_coverage
		var/permeability_value = ((1-permeability_coefficient) * 20) * total_coverage
		var/pressure_protection = FLOOR(abs(max_pressure_protection - min_pressure_protection)/ONE_ATMOSPHERE)

		additional_value += shock_protection + gas_leak_value + permeability_value + pressure_protection

		if(LAZYLEN(armor))
			var/armour_value
			for(var/atype in armor)
				var/adding_armour_value = BASE_ARMOUR_WORTH * (armor[atype]/MUNDANE_ARMOUR_VALUE)
				armour_value += adding_armour_value
			if(armour_value)
				// TODO; use armor_degradation_speed as a negative coefficient
				additional_value += (armour_value*total_coverage)

		if(item_flags)
			if(item_flags & ITEM_FLAG_THICKMATERIAL)
				additional_value += (25 * total_coverage)
			if(item_flags & ITEM_FLAG_AIRTIGHT)
				additional_value += (25 * total_coverage)

	if(item_flags)
		for(var/flag in list(ITEM_FLAG_PADDED, ITEM_FLAG_NOSLIP, ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT, ITEM_FLAG_SILENT, ITEM_FLAG_NOCUFFS))
			if(item_flags & flag)
				additional_value += 15

	. = round(. + additional_value)

#undef MUNDANE_ARMOUR_VALUE
#undef BASE_ARMOUR_WORTH

/obj/item/organ/get_single_monetary_worth()
	. = ..()
	if(species)
		. = round(. * species.rarity_value)
