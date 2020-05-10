/decl/reagent
	var/name
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/color = "#000000"
	var/color_weight = 1
	var/alpha = 255
	var/flags = 0
	var/hidden_from_codex

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	// GAS DATA, generic values copied from base XGM datum type.
	var/gas_specific_heat = 20
	var/gas_molar_mass =    0.032
	var/gas_overlay_limit = 0.7
	var/gas_flags =         0
	var/gas_burn_product
	var/gas_overlay = "generic"
	// END GAS DATA

	// Matter state data.
	var/chilling_point
	var/chilling_message = "crackles and freezes!"
	var/chilling_sound = 'sound/effects/bubbles.ogg'
	var/list/chilling_products

	var/list/heating_products
	var/heating_point
	var/heating_message = "begins to boil!"
	var/heating_sound = 'sound/effects/bubbles.ogg'
	var/fuel_value = 0

	var/temperature_multiplier = 1
	var/value = 1

	var/scent //refer to _scent.dm
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = SCENT_DESC_SMELL
	var/scent_range = 1

/decl/reagent/proc/on_leaving_metabolism(var/mob/parent, var/metabolism_class)
	return

/decl/reagent/proc/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder) // Acid melting, cleaner cleaning, etc
	return

#define FLAMMABLE_LIQUID_DIVISOR 7
// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/decl/reagent/proc/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(fuel_value && amount && istype(M))
		M.fire_stacks += Floor((amount * fuel_value)/FLAMMABLE_LIQUID_DIVISOR)

/decl/reagent/proc/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder) // Cleaner cleaning, lube lubbing, etc, all go here
	if(fuel_value && istype(T))
		var/removing = Floor((amount * fuel_value)/FLAMMABLE_LIQUID_DIVISOR)
		if(removing > 0)
			new /obj/effect/decal/cleanable/liquid_fuel(T, removing)
			holder.remove_reagent(type, removing)
#undef FLAMMABLE_LIQUID_DIVISOR

/decl/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location, var/datum/reagents/holder) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(QDELETED(src))
		return // Something else removed us.
	if(!istype(M))
		return
	if(!(flags & AFFECTS_DEAD) && M.stat == DEAD && (world.time - M.timeofdeath > 150))
		return
	if(overdose && (location != CHEM_TOUCH))
		var/overdose_threshold = overdose * (flags & IGNORE_MOB_SIZE? 1 : MOB_SIZE_MEDIUM/M.mob_size)
		if(REAGENT_VOLUME(holder, type) > overdose_threshold)
			affect_overdose(M, alien, holder)

	//determine the metabolism rate
	var/removed = metabolism
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	removed = M.get_adjusted_metabolism(removed)

	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(flags & IGNORE_MOB_SIZE) && location != CHEM_TOUCH)
		effective *= (MOB_SIZE_MEDIUM/M.mob_size)

	M.chem_doses[type] = M.chem_doses[type] + effective
	if(effective >= (metabolism * 0.1) || effective >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(location)
			if(CHEM_INJECT)
				affect_blood(M, alien, effective, holder)
			if(CHEM_INGEST)
				affect_ingest(M, alien, effective, holder)
			if(CHEM_TOUCH)
				affect_touch(M, alien, effective, holder)
	holder.remove_reagent(type, removed)

/decl/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	return

/decl/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed * 0.5, holder)
	return

/decl/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	return

/decl/reagent/proc/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder) // Overdose effect. Doesn't happen instantly.
	M.add_chemical_effect(CE_TOXIN, 1)
	M.adjustToxLoss(REM)

/decl/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(newdata) 
		. = newdata

/decl/reagent/proc/mix_data(var/datum/reagents/reagents, var/list/newdata, var/amount)	
	. = REAGENT_DATA(reagents, type)

/decl/reagent/proc/ex_act(obj/item/chems/holder, severity)
	return

/decl/reagent/proc/get_value()
	. = value

/decl/reagent/proc/get_presentation_name(var/obj/item/prop)
	. = glass_name || name
	if(prop?.reagents?.total_volume)
		. = build_presentation_name_from_reagents(prop, .)

/decl/reagent/proc/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = supplied
	if(prop.reagents.has_reagent(/decl/reagent/drink/ice))
		. = "iced [.]"
