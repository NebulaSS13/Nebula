/decl/material/proc/on_leaving_metabolism(datum/reagents/metabolism/holder)
	return

/decl/material/proc/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder) // Acid melting, cleaner cleaning, etc
	if(solvent_power >= MAT_SOLVENT_MODERATE)
		if(istype(O, /obj/item/paper) && amount >= FLUID_MINIMUM_TRANSFER)
			var/obj/item/paper/paperaffected = O
			paperaffected.clearpaper()
			O.visible_message(SPAN_NOTICE("The solution dissolves the ink on the paper."), range = 1)
		else if(istype(O, /obj/item/book) && amount >= FLUID_PUDDLE)
			var/obj/item/book/affectedbook = O
			if(affectedbook.clear_text())
				O.visible_message(SPAN_NOTICE("The solution dissolves the ink on the book."), range = 1)
			else
				O.visible_message(SPAN_WARNING("The solution does nothing. Whatever this is, it isn't normal ink."), range = 1)

	if(solvent_power >= MAT_SOLVENT_STRONG && O.solvent_can_melt(solvent_power) && (istype(O, /obj/item) || istype(O, /obj/effect/vine)) && (amount > solvent_melt_dose))
		O.visible_message(SPAN_DANGER("\The [O] dissolves!"))
		O.handle_melting()
		holder?.remove_reagent(src, solvent_melt_dose)
	else if(defoliant && istype(O, /obj/effect/vine))
		qdel(O)
	else
		if(dirtiness <= DIRTINESS_DECONTAMINATE)
			if(amount >= decontamination_dose && istype(O, /obj/item))
				var/obj/item/thing = O
				if(thing.contaminated)
					thing.decontaminate()
		if(dirtiness <= DIRTINESS_STERILE)
			O.germ_level -= min(amount*20, O.germ_level)
			O.was_bloodied = FALSE
		if(dirtiness <= DIRTINESS_CLEAN)
			O.clean()

#define FLAMMABLE_LIQUID_DIVISOR 7
// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/decl/material/proc/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(accelerant_value != FUEL_VALUE_NONE && amount && istype(M))
		M.adjust_fire_intensity(floor((amount * accelerant_value)/FLAMMABLE_LIQUID_DIVISOR))
#undef FLAMMABLE_LIQUID_DIVISOR

/decl/material/proc/touch_turf(var/turf/touching_turf, var/amount, var/datum/reagents/holder) // Cleaner cleaning, lube lubbing, etc, all go here

	if(REAGENT_VOLUME(holder, src) < turf_touch_threshold)
		return

	if(istype(touching_turf) && touching_turf.simulated)
		if(defoliant)
			for(var/obj/effect/overlay/wallrot/rot in touching_turf)
				touching_turf.visible_message(SPAN_NOTICE("\The [rot] is completely dissolved by the solution!"))
				qdel(rot)
		if(slipperiness != 0 && !touching_turf.check_fluid_depth()) // Don't make floors slippery if they have an active fluid on top of them please.
			if(slipperiness < 0)
				touching_turf.unwet_floor(TRUE)
			else if (REAGENT_VOLUME(holder, src) >= slippery_amount)
				touching_turf.wet_floor(slipperiness)

	if(length(vapor_products))
		var/result_volume = REAGENT_VOLUME(holder, src)
		var/atom/reagent_atom = REAGENT_GET_ATOM(holder)
		var/temperature = reagent_atom?.temperature || T20C
		for(var/vapor in vapor_products)
			touching_turf.assume_gas(vapor, (result_volume * vapor_products[vapor]), temperature)
		holder.remove_reagent(src, result_volume)

/decl/material/proc/on_mob_life(var/mob/living/M, var/metabolism_class, var/datum/reagents/holder, var/list/life_dose_tracker)

	if(QDELETED(src))
		return // Something else removed us.
	if(!istype(M))
		return
	if(!(flags & AFFECTS_DEAD) && M.stat == DEAD && (world.time - M.timeofdeath > 150))
		return

	// Keep track of dosage of chems across holders for overdosing purposes
	if(overdose && metabolism_class != CHEM_TOUCH && islist(life_dose_tracker))
		life_dose_tracker[src] += REAGENT_VOLUME(holder, src)

	//determine the metabolism rate
	var/removed
	switch(metabolism_class)
		if(CHEM_INGEST)
			removed = ingest_met
		if(CHEM_TOUCH)
			removed = touch_met
		if(CHEM_INHALE)
			removed = inhale_met
	if(!removed)
		removed = metabolism
	if(!removed)
		removed = metabolism
	removed = M.get_adjusted_metabolism(removed)

	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(flags & IGNORE_MOB_SIZE))
		effective *= (MOB_SIZE_MEDIUM/M.mob_size)
	if(metabolism_class != CHEM_TOUCH)
		var/dose = CHEM_DOSE(M, src) + effective
		LAZYSET(M._chem_doses, src, dose)

	var/remove_dose = TRUE
	if(effective >= (metabolism * 0.1) || effective >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(metabolism_class)
			if(CHEM_INJECT)
				affect_blood(M, effective, holder)
			if(CHEM_INGEST)
				affect_ingest(M, effective, holder)
			if(CHEM_TOUCH)
				remove_dose = affect_touch(M, effective, holder)
			if(CHEM_INHALE)
				affect_inhale(M, effective, holder)
	if(remove_dose)
		holder.remove_reagent(src, removed)

/decl/material/proc/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)

	SHOULD_CALL_PARENT(TRUE)

	if(M.status_flags & GODMODE)
		return

	if(antibiotic_strength)
		M.adjust_immunity(-0.1 * antibiotic_strength)
		M.add_chemical_effect(CE_ANTIBIOTIC, antibiotic_strength)
		if(REAGENT_VOLUME(holder, src) > 10)
			M.adjust_immunity(-0.3 * antibiotic_strength)
		if(CHEM_DOSE(M, src) > 15)
			M.adjust_immunity(-0.25 * antibiotic_strength)

	if(nutriment_factor || hydration_factor)
		if(injectable_nutrition)
			adjust_mob_nutrition(M, removed, holder, CHEM_INJECT)
		else
			apply_intolerances(M, removed, holder, CHEM_INJECT)
			M.take_damage(0.2 * removed, TOX)
	else if(!injectable_nutrition)
		apply_intolerances(M, removed, holder, CHEM_INJECT)

	if(radioactivity)
		M.apply_damage(radioactivity * removed, IRRADIATE, armor_pen = 100)

	if(toxicity)
		M.add_chemical_effect(CE_TOXIN, toxicity)
		var/dam = (toxicity * removed)
		if(toxicity_targets_organ && ishuman(M))
			var/organ_damage = dam * M.get_toxin_resistance()
			if(organ_damage > 0)
				var/mob/living/human/H = M
				var/obj/item/organ/internal/organ = GET_INTERNAL_ORGAN(H, toxicity_targets_organ)
				if(organ)
					var/can_damage = organ.max_damage - organ.get_organ_damage()
					if(can_damage > 0)
						if(organ_damage > can_damage)
							organ.take_damage(can_damage, silent=TRUE)
							dam -= can_damage
						else
							organ.take_damage(organ_damage, silent=TRUE)
							dam = 0
		if(dam > 0)
			M.take_damage(toxicity_targets_organ ? (dam * 0.75) : dam, TOX)

	if(solvent_power >= MAT_SOLVENT_STRONG)
		M.take_organ_damage(0, removed * solvent_power, override_droplimb = DISMEMBER_METHOD_ACID)

	if(narcosis)
		if(prob(10))
			M.SelfMove(pick(global.cardinal))
		if(prob(narcosis))
			M.emote(pick(/decl/emote/visible/twitch, /decl/emote/visible/drool, /decl/emote/audible/moan))

	if(euphoriant)
		SET_STATUS_MAX(M, STAT_DRUGGY, euphoriant)

/decl/material/proc/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)

	SHOULD_CALL_PARENT(TRUE)

	adjust_mob_nutrition(M, removed, holder, CHEM_INGEST)
	if(affect_blood_on_ingest)
		affect_blood(M, removed * affect_blood_on_ingest, holder)

/decl/material/proc/affect_inhale(var/mob/living/M, var/removed, var/datum/reagents/holder)

	SHOULD_CALL_PARENT(TRUE)

	apply_intolerances(M, removed, holder, CHEM_INHALE)
	if(affect_blood_on_inhale)
		affect_blood(M, removed * affect_blood_on_inhale, holder)

// Major allergy - handled by handle_allergens() on /mob/living by default.
/decl/material/proc/apply_allergy_effects(mob/living/subject, removed, severity, ingestion_method)
	if(allergen_factor > 0)
		subject.add_chemical_effect(CE_ALLERGEN, removed * severity * allergen_factor)
	else if(allergen_factor < 0)
		subject.remove_chemical_effect(CE_ALLERGEN, removed * severity * allergen_factor)

// Intolerance - TODO: more messages
/decl/material/proc/apply_intolerance_effects(mob/living/subject, removed, severity, ingestion_method)
	if(ingestion_method != CHEM_INGEST)
		return
	if(ishuman(subject) && prob(removed))
		var/mob/living/human/puker = subject
		puker.vomit()
	else if(prob(1))
		var/static/list/intolerance_messages = list(
			"Your innards churn and cramp unhappily."
		)
		subject.custom_pain(pick(intolerance_messages), 1)

/decl/material/proc/apply_intolerances(mob/living/subject, removed, datum/reagents/holder, ingestion_method)

	var/list/data = REAGENT_DATA(holder, src)
	var/check_flags = LAZYACCESS(data, DATA_INGREDIENT_FLAGS) | allergen_flags
	if(!check_flags)
		return 1

	var/list/intolerances = get_intolerances_by_flag(check_flags, ingestion_method)
	if(!length(intolerances))
		return 1

	var/malus_level = 0
	for(var/decl/trait/intolerance as anything in intolerances)
		malus_level = max(malus_level, subject.get_trait_level(intolerance.type))
	if(!malus_level)
		return 1

	if(malus_level >= TRAIT_LEVEL_MAJOR)
		apply_allergy_effects(subject, removed, malus_level, ingestion_method)
	else if(malus_level >= TRAIT_LEVEL_MINOR)
		apply_intolerance_effects(subject, removed, malus_level, ingestion_method)
	return max(0, (1 - (malus_level * 0.25)))

// Defined as a proc so it can be overridden.
/decl/material/proc/adjust_mob_nutrition(mob/living/subject, removed, datum/reagents/holder, ingestion_method)
	var/metabolic_penalty = apply_intolerances(subject, removed, holder, ingestion_method)
	if(nutriment_factor)
		var/effective_power = nutriment_factor * metabolic_penalty * removed
		if(effective_power)
			subject.adjust_nutrition(effective_power)
	if(hydration_factor)
		var/effective_power = hydration_factor * metabolic_penalty * removed
		if(effective_power)
			subject.adjust_hydration(effective_power)

// Slightly different to other reagent processing - return TRUE to consume the removed amount, FALSE not to consume.
/decl/material/proc/affect_touch(var/mob/living/victim, var/removed, var/datum/reagents/holder)

	SHOULD_CALL_PARENT(TRUE)
	. = FALSE
	if(!istype(victim))
		return FALSE

	if(radioactivity)
		victim.apply_damage((radioactivity / 2) * removed, IRRADIATE)
		. = TRUE

	if(dirtiness <= DIRTINESS_STERILE)
		if(victim.germ_level < INFECTION_LEVEL_TWO) // rest and antibiotics is required to cure serious infections
			victim.germ_level -= min(removed*20, victim.germ_level)
		for(var/obj/item/organ in victim.contents)
			organ.was_bloodied = FALSE
		victim.was_bloodied = FALSE
		. = TRUE

	// TODO: clean should add the gross reagents washed off to a holder to dump on the loc.
	if(dirtiness <= DIRTINESS_CLEAN)
		for(var/obj/item/thing in victim.get_held_items())
			thing.clean()
		var/obj/item/mask = victim.get_equipped_item(slot_wear_mask_str)
		if(mask)
			mask.clean()
		if(ishuman(victim))
			var/mob/living/human/human_victim = victim
			var/obj/item/head = human_victim.get_equipped_item(slot_head_str)
			if(head)
				head.clean()
			var/obj/item/suit = human_victim.get_equipped_item(slot_wear_suit_str)
			if(suit)
				suit.clean()
			else
				var/obj/item/uniform = human_victim.get_equipped_item(slot_w_uniform_str)
				if(uniform)
					uniform.clean()

			var/obj/item/shoes = human_victim.get_equipped_item(slot_shoes_str)
			if(shoes)
				shoes.clean()
			else
				human_victim.clean()
		else
			victim.clean()

	if(solvent_power > MAT_SOLVENT_NONE && removed >= solvent_melt_dose && victim.solvent_act(min(removed * solvent_power * ((removed < solvent_melt_dose) ? 0.1 : 0.2), solvent_max_damage), solvent_melt_dose, solvent_power))
		holder.remove_reagent(src, REAGENT_VOLUME(holder, src))
		. = TRUE

/decl/material/proc/affect_overdose(mob/living/victim, total_dose) // Overdose effect. Doesn't happen instantly.
	victim.add_chemical_effect(CE_TOXIN, 1)
	victim.take_damage(REM, TOX)