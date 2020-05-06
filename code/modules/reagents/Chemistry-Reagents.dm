/decl/material/proc/on_leaving_metabolism(var/mob/parent, var/metabolism_class)
	return

/decl/material/proc/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder) // Acid melting, cleaner cleaning, etc
	if(pH <= 3 && (istype(O, /obj/item) || istype(O, /obj/effect/vine)) && !O.unacidable)
		var/meltdose = (pH * 8)
		if(REAGENT_VOLUME(holder, type) >= meltdose)
			var/obj/effect/decal/cleanable/molten_item/I = new(get_turf(O))
			I.desc = "Looks like this was \an [O] some time ago."
			I.visible_message(SPAN_DANGER("\The [O] melts."))
			qdel(O)
			holder?.remove_reagent(type, meltdose) 

#define FLAMMABLE_LIQUID_DIVISOR 7
// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/decl/material/proc/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(fuel_value && amount && istype(M))
		M.fire_stacks += Floor((amount * fuel_value)/FLAMMABLE_LIQUID_DIVISOR)

/decl/material/proc/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder) // Cleaner cleaning, lube lubbing, etc, all go here
	if(fuel_value && istype(T))
		var/removing = Floor((amount * fuel_value)/FLAMMABLE_LIQUID_DIVISOR)
		if(removing > 0)
			new /obj/effect/decal/cleanable/liquid_fuel(T, removing)
			holder.remove_reagent(type, removing)
#undef FLAMMABLE_LIQUID_DIVISOR

/decl/material/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location, var/datum/reagents/holder) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
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

/decl/material/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/fueltox = fuel_value * 2
	if(fueltox > 0)
		M.adjustToxLoss(fueltox * removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(pH >= 10)
			H.take_organ_damage(0, removed * (pH-10))
		else if(pH <= 3)
			H.take_organ_damage(0, removed * ((4-pH)*2))

/decl/material/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed * 0.5, holder)
	return

/decl/material/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)

	if(pH <= 3)
		var/meltdose = (pH * 8)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/thing in list(H.head, H.wear_mask, H.glasses))
				if(thing.unacidable || removed < meltdose)
					to_chat(H, SPAN_DANGER("Your [thing] protects you from the acid."))
					holder.remove_reagent(type, REAGENT_VOLUME(holder, type))
					return
				to_chat(H, SPAN_DANGER("Your [thing] melts away!"))
				H.drop_from_inventory(thing)
				qdel(thing)
				removed -= meltdose

		if(!M.unacidable && removed >= meltdose)
			M.take_organ_damage(0, min(removed * power * 0.2, max_damage))
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/screamed
				for(var/obj/item/organ/external/affecting in H.organs)
					if(!screamed && affecting.can_feel_pain())
						screamed = 1
						H.emote("scream")
					affecting.status |= ORGAN_DISFIGURED

/decl/material/proc/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder) // Overdose effect. Doesn't happen instantly.
	M.add_chemical_effect(CE_TOXIN, 1)
	M.adjustToxLoss(REM)

/decl/material/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(newdata) 
		. = newdata

/decl/material/proc/mix_data(var/datum/reagents/reagents, var/list/newdata, var/amount)	
	. = REAGENT_DATA(reagents, type)

/decl/material/proc/ex_act(obj/item/chems/holder, severity)
	if(fuel_value <= 0)
		return
	var/volume = REAGENT_VOLUME(holder?.reagents, type) * fuel_value
	if(volume <= 50)
		return
	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/products = new(_temperature = 5 * PHORON_FLASHPOINT)
	var/gas_moles = 3 * volume
	products.adjust_multi(MAT_NO, 0.1 * gas_moles, MAT_NO2, 0.1 * gas_moles, MAT_NITROGEN, 0.6 * gas_moles, MAT_HYDROGEN, 0.02 * gas_moles)
	T.assume_air(products)
	if(volume > 500)
		explosion(T,1,2,4)
	else if(volume > 100)
		explosion(T,0,1,3)
	else if(volume > 50)
		explosion(T,-1,1,2)
	holder?.reagents?.remove_reagent(type, volume)

/decl/material/proc/get_value()
	. = value
