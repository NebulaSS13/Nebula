//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/human
	var/stamina = 100

/mob/living/human/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	last_pain = null // Clear the last cached pain value so further calls won't use an old value.
	//Organs and blood
	handle_organs()
	handle_shock()
	handle_pain()
	handle_stamina()

/mob/living/human/get_stamina()
	return stamina

/mob/living/human/adjust_stamina(var/amt)
	var/last_stamina = stamina
	if(stat == DEAD)
		stamina = 0
	else
		stamina = clamp(stamina + amt, 0, 100)
		if(stamina <= 0)
			to_chat(src, SPAN_WARNING("You are exhausted!"))
			remove_stressor(/datum/stressor/well_rested)
			add_stressor(/datum/stressor/fatigued, 5 MINUTES)
			if(MOVING_QUICKLY(src))
				set_moving_slowly()
	if(last_stamina != stamina)
		refresh_hud_element(HUD_STAMINA)

/mob/living/human/proc/handle_stamina()
	if((world.time - last_quick_move_time) > 5 SECONDS)
		var/mod = (current_posture.prone + (nutrition / get_max_nutrition())) / 2
		adjust_stamina(max(get_config_value(/decl/config/num/movement_max_stamina_recovery), get_config_value(/decl/config/num/movement_min_stamina_recovery) * mod) * (1 + GET_CHEMICAL_EFFECT(src, CE_ENERGETIC)))

/mob/living/human/set_stat(var/new_stat)
	var/old_stat = stat
	. = ..()
	if(stat)
		update_skin(1)
	if(client && client.is_afk())
		if(old_stat == UNCONSCIOUS && stat == CONSCIOUS)
			playsound_local(null, 'sound/effects/bells.ogg', 100, is_global=TRUE)

// Calculate how vulnerable the human is to the current pressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit that's rated for the pressure, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/human/proc/get_pressure_weakness(pressure)

	var/pressure_adjustment_coefficient = 0
	var/list/zones = list(SLOT_HEAD, SLOT_UPPER_BODY, SLOT_LOWER_BODY, SLOT_LEGS, SLOT_FEET, SLOT_ARMS, SLOT_HANDS)
	for(var/zone in zones)
		var/list/covers = get_covering_equipped_items(zone)
		var/zone_exposure = 1
		for(var/obj/item/clothing/C in covers)
			zone_exposure = min(zone_exposure, C.get_pressure_weakness(pressure,zone))
		if(zone_exposure >= 1)
			return 1
		pressure_adjustment_coefficient = max(pressure_adjustment_coefficient, zone_exposure)
	pressure_adjustment_coefficient = clamp(pressure_adjustment_coefficient, 0, 1) // So it isn't less than 0 or larger than 1.

	return pressure_adjustment_coefficient

// Calculate how much of the environment pressure-difference affects the human.
/mob/living/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference
	var/species_safe_pressure = species.get_safe_pressure(src)

	// First get the absolute pressure difference.
	pressure_difference = abs(pressure - species_safe_pressure)

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness(pressure)

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < species_safe_pressure)
		return species_safe_pressure - pressure_difference
	else
		return species_safe_pressure + pressure_difference

/mob/living/human/handle_impaired_vision()

	. = ..()
	if(!.)
		return

	//Vision
	var/obj/item/organ/vision
	var/vision_organ_tag = get_vision_organ_tag()
	if(vision_organ_tag)
		vision = GET_INTERNAL_ORGAN(src, vision_organ_tag)

	if(!vision_organ_tag) // Presumably if a species has no vision organs, they see via some other means.
		set_status_condition(STAT_BLIND, 0)
		set_status_condition(STAT_BLURRY, 0)
	else if(!vision || (vision && !vision.is_usable()))   // Vision organs cut out or broken? Permablind.
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		SET_STATUS_MAX(src, STAT_BLURRY, 1)
	// Non-genetic blindness; covered eyes will heal faster.
	else if(!has_genetic_condition(GENE_COND_BLINDED) && equipment_tint_total >= TINT_BLIND)
		ADJ_STATUS(src, STAT_BLURRY, -1)

/mob/living/human/handle_disabilities()
	..()
	if(stat != DEAD && has_genetic_condition(GENE_COND_COUGHING) && prob(5) && GET_STATUS(src, STAT_PARA) <= 1)
		drop_held_items()
		cough()

/mob/living/human/handle_mutations_and_radiation()
	if(get_damage(BURN) && (has_genetic_condition(GENE_COND_COLD_RESISTANCE) || (prob(1))))
		heal_organ_damage(0,1)
	..()

/mob/living/human/handle_environment(datum/gas_mixture/environment)

	..()

	if(!environment || has_genetic_condition(GENE_COND_SPACE_RESISTANCE))
		return

	//Stuff like water absorbtion happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		var/decl/material/mat = GET_DECL(g)
		if((mat.gas_flags & XGM_GAS_CONTAMINANT) && environment.gas[g] > mat.gas_overlay_limit + 1)
			handle_contaminants()
			break

	if(isspaceturf(src.loc)) //being in a closet will interfere with radiation, may not make sense but we don't model radiation for atoms in general so it will have to do for now.
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)

			//Thermal radiation into space
			var/heat_gain = get_thermal_radiation(bodytemperature, HUMAN_EXPOSED_SURFACE_AREA, 0.5, SPACE_HEAT_TRANSFER_COEFFICIENT)

			var/temperature_gain = heat_gain/HUMAN_HEAT_CAPACITY
			bodytemperature += temperature_gain //temperature_gain will often be negative

	var/relative_density = (environment.total_moles/environment.volume) / (MOLES_CELLSTANDARD/CELL_VOLUME)
	if(relative_density > 0.02) //don't bother if we are in vacuum or near-vacuum
		var/loc_temp = environment.temperature

		if(adjusted_pressure < species.get_warning_high_pressure(src) && adjusted_pressure > species.get_warning_low_pressure(src) && abs(loc_temp - bodytemperature) < 20 && bodytemperature < get_mob_temperature_threshold(HEAT_LEVEL_1) && bodytemperature > get_mob_temperature_threshold(COLD_LEVEL_1) && species.body_temperature)
			SET_HUD_ALERT(src, HUD_PRESSURE, 0)
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		bodytemperature += clamp(temp_adj*relative_density, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= get_mob_temperature_threshold(HEAT_LEVEL_1))
		//Body temperature is too hot.
		if(status_flags & GODMODE)	return 1	//godmode
		var/burn_dam = 0
		if(bodytemperature < get_mob_temperature_threshold(HEAT_LEVEL_2))
			burn_dam = HEAT_DAMAGE_LEVEL_1
		else if(bodytemperature < get_mob_temperature_threshold(HEAT_LEVEL_3))
			burn_dam = HEAT_DAMAGE_LEVEL_2
		else
			burn_dam = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature")
		SET_HUD_ALERT_MAX(src, HUD_FIRE, 2)

	else if(bodytemperature <= get_mob_temperature_threshold(COLD_LEVEL_1))
		SET_HUD_ALERT_MAX(src, HUD_FIRE, 1)
		if(status_flags & GODMODE)	return 1	//godmode

		var/burn_dam = 0

		if(bodytemperature > get_mob_temperature_threshold(COLD_LEVEL_2))
			burn_dam = COLD_DAMAGE_LEVEL_1
		else if(bodytemperature > get_mob_temperature_threshold(COLD_LEVEL_3))
			burn_dam = COLD_DAMAGE_LEVEL_2
		else
			burn_dam = COLD_DAMAGE_LEVEL_3
		add_mob_modifier(/decl/mob_modifier/stasis, 2 SECONDS, source = src)
		if(!has_chemical_effect(CE_CRYO, 1))
			take_overall_damage(burn=burn_dam, used_weapon = "Low Body Temperature")
			SET_HUD_ALERT_MAX(src, HUD_FIRE, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)	return 1	//godmode

	var/high_pressure = species.get_hazard_high_pressure(src)
	if(adjusted_pressure >= high_pressure)
		var/pressure_damage = min( ( (adjusted_pressure / high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
		SET_HUD_ALERT(src, HUD_PRESSURE, 2)
	else if(adjusted_pressure >= species.get_warning_high_pressure(src))
		SET_HUD_ALERT(src, HUD_PRESSURE, 1)
	else if(adjusted_pressure >= species.get_warning_low_pressure(src))
		SET_HUD_ALERT(src, HUD_PRESSURE, 0)
	else if(adjusted_pressure >= species.get_hazard_low_pressure(src))
		SET_HUD_ALERT(src, HUD_PRESSURE, -1)
	else
		var/list/obj/item/organ/external/parts = get_damageable_organs()
		for(var/obj/item/organ/external/limb in parts)
			if(QDELETED(limb) || !(limb.owner == src))
				continue
			if(limb.brute_dam + limb.burn_dam + (LOW_PRESSURE_DAMAGE) < limb.min_broken_damage) //vacuum does not break bones
				limb.take_damage(LOW_PRESSURE_DAMAGE, inflicter = "Low Pressure")
		if(getOxyLossPercent() < 55) // 11 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
			take_damage(4)  // 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, OXY, roughly twenty seconds
		SET_HUD_ALERT(src, HUD_PRESSURE, -2)

	return

/mob/living/human/get_bodytemperature_difference()
	if (is_on_fire())
		return 0 //too busy for pesky metabolic regulation
	return ..()

/mob/living/human/stabilize_body_temperature()
	// Robolimbs cause overheating too.
	if(robolimb_count)
		bodytemperature += round(robolimb_count/2)
	return ..()

/mob/living/human/get_heat_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/slot in global.standard_clothing_slots)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C))
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection
			if(LAZYLEN(C.accessories))
				for(var/obj/item/clothing/accessory in C.accessories)
					if(accessory.max_heat_protection_temperature && accessory.max_heat_protection_temperature >= temperature)
						. |= accessory.heat_protection

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/slot in global.standard_clothing_slots)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C))
			if(!isnull(C.min_cold_protection_temperature) && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection
			if(LAZYLEN(C.accessories))
				for(var/obj/item/clothing/accessory in C.accessories)
					if(!isnull(accessory.min_cold_protection_temperature) && accessory.min_cold_protection_temperature <= temperature)
						. |= accessory.cold_protection


/mob/living/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/human/get_cold_protection(temperature)
	if(has_genetic_condition(GENE_COND_COLD_RESISTANCE))
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & SLOT_HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & SLOT_UPPER_BODY)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & SLOT_LOWER_BODY)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & SLOT_LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & SLOT_LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & SLOT_FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & SLOT_FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & SLOT_ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & SLOT_ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & SLOT_HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & SLOT_HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)

/mob/living/human/apply_chemical_effects()
	. = ..()
	if(has_chemical_effect(CE_GLOWINGEYES, 1))
		update_eyes()
		return TRUE

/mob/living/human/handle_regular_status_updates()

	voice = GetVoice()
	SetName(get_visible_name())

	if(status_flags & GODMODE)
		return FALSE

	if(vsc.contaminant_control.CONTAMINATION_LOSS)
		var/total_contamination= 0
		for(var/obj/item/thing in src)
			if(thing.contaminated)
				total_contamination += vsc.contaminant_control.CONTAMINATION_LOSS
		take_damage(total_contamination, TOX)

	. = ..()
	if(!.)
		return

	if(get_shock() >= species.total_health)
		if(!stat)
			to_chat(src, "<span class='warning'>[species.halloss_message_self]</span>")
			src.visible_message("<B>[src]</B> [species.halloss_message]")
		SET_STATUS_MAX(src, STAT_PARA, 10)

	if(HAS_STATUS(src, STAT_PARA) || HAS_STATUS(src, STAT_ASLEEP))
		set_stat(UNCONSCIOUS)
		animate_tail_reset()
		heal_damage(PAIN, 3)
		if(prob(2) && is_asystole() && isSynthetic())
			visible_message("<b>[src]</b> [pick("emits low pitched whirr","beeps urgently")].")
	else
		set_stat(CONSCIOUS)

	// Check everything else.
	//Periodically double-check embedded_flag
	if(embedded_flag && !(life_tick % 10))
		if(!embedded_needs_process())
			embedded_flag = 0

	//Resting
	if(current_posture.prone)
		if(HAS_STATUS(src, STAT_DIZZY))
			ADJ_STATUS(src, STAT_DIZZY, -15)
		if(HAS_STATUS(src, STAT_JITTER))
			ADJ_STATUS(src, STAT_JITTER, -15)
		heal_damage(PAIN, 3)
	else
		if(HAS_STATUS(src, STAT_DIZZY))
			ADJ_STATUS(src, STAT_DIZZY, -3)
		if(HAS_STATUS(src, STAT_JITTER))
			ADJ_STATUS(src, STAT_JITTER, -3)
		heal_damage(PAIN, 1)

	if(HAS_STATUS(src, STAT_DROWSY))
		SET_STATUS_MAX(src, STAT_BLURRY, 2)
		var/sleepy = GET_STATUS(src, STAT_DROWSY)
		if(sleepy > 10)
			var/zzzchance = min(5, 5*sleepy/30)
			if((prob(zzzchance) || sleepy >= 60))
				if(stat == CONSCIOUS)
					to_chat(src, SPAN_NOTICE("You are about to fall asleep..."))
				SET_STATUS_MAX(src, STAT_ASLEEP, 5)


/mob/living/human/handle_regular_hud_updates()
	if(life_tick%30==15)
		hud_updateflag = 1022
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()
	. = ..()
	if(!.)
		return
	if(stat != DEAD)
		var/half_health = get_max_health()/2
		if(stat == UNCONSCIOUS && current_health < half_health)
			//Critical damage passage overlay
			var/severity = 0
			switch(current_health - half_health)
				if(-20 to -10)			severity = 1
				if(-30 to -20)			severity = 2
				if(-40 to -30)			severity = 3
				if(-50 to -40)			severity = 4
				if(-60 to -50)			severity = 5
				if(-70 to -60)			severity = 6
				if(-80 to -70)			severity = 7
				if(-90 to -80)			severity = 8
				if(-95 to -90)			severity = 9
				if(-INFINITY to -95)	severity = 10
			overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			//Oxygen damage overlay
			if(get_damage(OXY))
				var/severity = 0
				switch(getOxyLossPercent())
					if(10 to 20)		severity = 1
					if(20 to 25)		severity = 2
					if(25 to 30)		severity = 3
					if(30 to 35)		severity = 4
					if(35 to 40)		severity = 5
					if(40 to 45)		severity = 6
					if(45 to INFINITY)	severity = 7
				overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.get_damage(BRUTE) + src.get_damage(BURN) + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)		severity = 1
				if(25 to 40)		severity = 2
				if(40 to 55)		severity = 3
				if(55 to 70)		severity = 4
				if(70 to 85)		severity = 5
				if(85 to INFINITY)	severity = 6
			overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

	return 1

/mob/living/human/handle_random_events()
	// Puke if toxloss is too high
	var/vomit_score = 0
	for(var/tag in list(BP_LIVER,BP_KIDNEYS))
		var/obj/item/organ/internal/organ = GET_INTERNAL_ORGAN(src, tag)
		if(organ)
			vomit_score += organ.get_organ_damage()
		else if (should_have_organ(tag))
			vomit_score += 45
	if(has_chemical_effect(CE_TOXIN, 1) || radiation)
		vomit_score += 0.5 * get_damage(TOX)
	if(has_chemical_effect(CE_ALCOHOL_TOXIC, 1))
		vomit_score += 10 * GET_CHEMICAL_EFFECT(src, CE_ALCOHOL_TOXIC)
	if(has_chemical_effect(CE_ALCOHOL, 1))
		vomit_score += 10
	if(stat != DEAD && vomit_score > 25 && prob(10))
		vomit(vomit_score, vomit_score/25)

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() <= LIGHTING_SOFT_THRESHOLD)
			playsound_local(T,pick(global.scarySounds),50, 1, -1)

	var/area/A = get_area(src)
	if(client && world.time >= client.played + 60 SECONDS)
		A.play_ambience(src)
	if(stat == UNCONSCIOUS && world.time - l_move_time < 5 && prob(10))
		to_chat(src,"<span class='notice'>You feel like you're [pick("moving","flying","floating","falling","hovering")].</span>")

#define BASE_SHOCK_RECOVERY 1
/mob/living/human/proc/handle_shock()
	if(!can_feel_pain() || (status_flags & GODMODE))
		shock_stage = 0
		return

	var/stress_modifier = get_stress_modifier()
	if(stress_modifier)
		stress_modifier *= get_config_value(/decl/config/num/health_stress_shock_recovery_constant)

	if(is_asystole())
		shock_stage = max(shock_stage + (BASE_SHOCK_RECOVERY + stress_modifier), 61)

	var/traumatic_shock = get_shock()
	if(traumatic_shock >= max(30, 0.8*shock_stage))
		shock_stage += (1 + stress_modifier)
	else if (!is_asystole())
		shock_stage = min(shock_stage, 160)
		var/recovery = 1
		if(traumatic_shock < 0.5 * shock_stage) //lower shock faster if pain is gone completely
			recovery++
		if(traumatic_shock < 0.25 * shock_stage)
			recovery++
		shock_stage = max(shock_stage - (recovery * (1-stress_modifier)), 0)
		return

	if(stat != CONSCIOUS)
		return

	// If we haven't adjusted by at least one full unit, don't run the message logic below.
	var/next_rounded_shock_stage = round(shock_stage)
	if(next_rounded_shock_stage == rounded_shock_stage)
		return

	rounded_shock_stage = next_rounded_shock_stage
	if(rounded_shock_stage <= 0)
		return

	if(rounded_shock_stage == 10)
		// Please be very careful when calling custom_pain() from within code that relies on pain/trauma values. There's the
		// possibility of a feedback loop from custom_pain() being called with a positive power, incrementing pain on a limb,
		// which triggers this proc, which calls custom_pain(), etc. Make sure you call it with nohalloss = TRUE in these cases!
		custom_pain("[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!", 10, nohalloss = TRUE)

	if(rounded_shock_stage >= 30)
		if(rounded_shock_stage == 30)
			var/decl/pronouns/pronouns = get_pronouns()
			visible_message("<b>\The [src]</b> is having trouble keeping [pronouns.his] eyes open.")
		if(prob(30))
			SET_STATUS_MAX(src, STAT_BLURRY, 2)
			SET_STATUS_MAX(src, STAT_STUTTER, 5)

	if (rounded_shock_stage >= 60)
		if(rounded_shock_stage == 60) visible_message("<b>[src]</b>'s body becomes limp.")
		if (prob(2))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", rounded_shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 3)

	if(rounded_shock_stage >= 80)
		if (prob(5))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", rounded_shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_WEAK, 5)

	if(rounded_shock_stage >= 120)
		if(!HAS_STATUS(src, STAT_PARA) && prob(2))
			custom_pain("[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!", rounded_shock_stage, nohalloss = TRUE)
			SET_STATUS_MAX(src, STAT_PARA, 5)

	if(rounded_shock_stage == 150)
		visible_message("<b>[src]</b> can no longer stand, collapsing!")

	if(rounded_shock_stage >= 150)
		SET_STATUS_MAX(src, STAT_WEAK, 5)

#undef BASE_SHOCK_RECOVERY

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/
/mob/living/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD) && hud_list[HEALTH_HUD])
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == DEAD)
			holder.icon_state = "0" 	// X_X
		else if(is_asystole())
			holder.icon_state = "flatline"
		else
			holder.icon_state = "[get_pulse()]"
		hud_list[HEALTH_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD) && hud_list[LIFE_HUD])
		var/image/holder = hud_list[LIFE_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD) && hud_list[STATUS_HUD] && hud_list[STATUS_HUD_OOC])
		var/image/holder = hud_list[STATUS_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"

		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD)
			holder2.icon_state = "huddead"
		else
			holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if (BITTEST(hud_updateflag, ID_HUD) && hud_list[ID_HUD])
		var/image/holder = hud_list[ID_HUD]
		holder.icon_state = "hudunknown"

		var/obj/item/id = get_equipped_item(slot_wear_id_str)
		if(id)
			var/obj/item/card/id/id_card = id.GetIdCard()
			if(id_card)
				var/datum/job/J = SSjobs.get_by_title(id_card.GetJobName())
				if(J)
					holder.icon       = J.hud_icon
					holder.icon_state = J.hud_icon_state

		hud_list[ID_HUD] = holder

	if (BITTEST(hud_updateflag, WANTED_HUD) && hud_list[WANTED_HUD])
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		var/obj/item/id = get_equipped_item(slot_wear_id_str)
		if(id)
			var/obj/item/card/id/id_card = id.GetIdCard()
			if(id_card)
				perpname = id_card.registered_name

		var/datum/computer_file/report/crew_record/E = get_crewmember_record(perpname)
		if(E)
			switch(E.get_criminalStatus())
				if("Arrest")
					holder.icon_state = "hudwanted"
				if("Incarcerated")
					holder.icon_state = "hudprisoner"
				if("Parolled")
					holder.icon_state = "hudparolled"
				if("Released")
					holder.icon_state = "hudreleased"
		hud_list[WANTED_HUD] = holder

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hud_imp_blank"
		holder2.icon_state = "hud_imp_blank"
		holder3.icon_state = "hud_imp_blank"
		for(var/obj/item/implant/implant in src)
			if(implant.implanted)
				if(istype(implant,/obj/item/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				else if(istype(implant,/obj/item/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				else if(istype(implant,/obj/item/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD]  = holder3

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = hud_list[SPECIALROLE_HUD]
		holder.icon_state = "hudblank"
		var/special_role = mind?.get_special_role_name()
		if(special_role)
			if(global.hud_icon_reference[special_role])
				holder.icon_state = global.hud_icon_reference[special_role]
			else
				holder.icon_state = "hudsyndicate"
			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = 0

/mob/living/human/rejuvenate()
	reset_blood()
	full_prosthetic = null
	shock_stage = 0
	..()
	adjust_stamina(100)

/mob/living/human/reset_view(atom/A)
	..()
	if(machine_visual && machine_visual != A)
		machine_visual.remove_visual(src)
	if(eyeobj)
		eyeobj.remove_visual(src)

/mob/living/human/handle_vision()
	if(client)
		var/datum/global_hud/global_hud = get_global_hud()
		client.screen.Remove(global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)
	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(sight|viewflags)
	if(eyeobj && eyeobj.owner != src)
		reset_view(null)
	if(has_genetic_condition(GENE_COND_REMOTE_VIEW) && remoteview_target && remoteview_target.stat != CONSCIOUS)
		remoteview_target = null
		reset_view(null, 0)

	update_equipment_vision()
	species.handle_vision(src)

/mob/living/human/update_living_sight()
	..()
	if(GET_CHEMICAL_EFFECT(src, CE_THIRDEYE) || has_genetic_condition(GENE_COND_XRAY))
		set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
