/// This material type has mob effects based on accumulated dose.
/// If the drug has been in your system enough to accumulate a dose,
/// and the level of it in your bloodstream drops below a certain volume,
/// you will get discontinuation effects.
/// If it is above that volume or hasn't been in your system long enough to accumulate,
/// you will get the positive effects.
/decl/material/liquid/accumulated
	abstract_type = /decl/material/liquid/accumulated
	/// (FLOAT) The dose under which you will receive effects from discontinuation.
	var/required_dose = 0.5
	/// (FLOAT) The minimum volume to get the positive effect of this reagent.
	var/required_volume = 0.1
	/// (FLOAT) The cooldown between effect triggers.
	var/effect_cooldown = 5 MINUTES

/decl/material/liquid/accumulated/affect_blood(mob/living/victim, removed, datum/reagents/holder)
	var/affect_volume = REAGENT_VOLUME(holder, src)
	. = ..()

	var/update_data = FALSE
	var/list/data = REAGENT_DATA(holder, src)
	var/is_off_cooldown = world.time > LAZYACCESS(data, DATA_COOLDOWN_TIME) + effect_cooldown
	if(affect_volume <= required_volume && CHEM_DOSE(victim, src) >= required_dose)
		update_data = discontinuation_effect(victim, removed, holder, is_off_cooldown)
	else
		update_data = positive_effect(victim, removed, holder, is_off_cooldown)

	if(update_data)
		LAZYSET(data, DATA_COOLDOWN_TIME, world.time)
		LAZYSET(holder.reagent_data, type, data)

/// Returns TRUE to signal that the effect should go on cooldown.
/decl/material/liquid/accumulated/proc/positive_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	return FALSE

/// Returns TRUE to signal that the effect should go on cooldown.
/decl/material/liquid/accumulated/proc/discontinuation_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	return FALSE

/decl/material/liquid/accumulated/stimulants
	name = "stimulants"
	lore_text = "Improves the ability to concentrate."
	taste_description = "sourness"
	color = "#bf80bf"
	scannable = 1
	metabolism = 0.01
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_stimulants"
	allergen_flags = ALLERGEN_STIMULANT

/decl/material/liquid/accumulated/stimulants/positive_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	ADJ_STATUS(victim, STAT_DROWSY, -5)
	ADJ_STATUS(victim, STAT_PARA, -1)
	ADJ_STATUS(victim, STAT_STUN, -1)
	ADJ_STATUS(victim, STAT_WEAK, -1)
	if(is_off_cooldown)
		to_chat(victim, SPAN_NOTICE("Your mind feels focused and undivided."))
		return TRUE
	return FALSE

/decl/material/liquid/accumulated/stimulants/discontinuation_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	if(is_off_cooldown)
		to_chat(victim, SPAN_WARNING("You lose focus..."))
		return TRUE
	return FALSE

/decl/material/liquid/accumulated/antidepressants
	name = "antidepressants"
	lore_text = "Stabilizes the mind a little."
	taste_description = "bitterness"
	color = "#ff80ff"
	scannable = 1
	metabolism = 0.01
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_antidepressants"

/decl/material/liquid/accumulated/antidepressants/positive_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	victim.add_chemical_effect(CE_MIND, 1)
	victim.adjust_hallucination(-10)
	if(is_off_cooldown)
		to_chat(victim, SPAN_NOTICE("Your mind feels stable... a little stable."))
		return TRUE
	return FALSE

/decl/material/liquid/accumulated/antidepressants/discontinuation_effect(mob/living/victim, removed, datum/reagents/holder, is_off_cooldown)
	if(is_off_cooldown)
		to_chat(victim, SPAN_WARNING("Your mind feels a little less stable..."))
		return TRUE
	return FALSE
