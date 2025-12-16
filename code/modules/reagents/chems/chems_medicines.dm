/decl/material/liquid/eyedrops
	name = "eye drops"
	lore_text = "A soothing balm that helps with minor eye damage."
	taste_description = "a mild burn"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_eyedrops"

/decl/material/liquid/eyedrops/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	var/obj/item/organ/internal/eyes = GET_INTERNAL_ORGAN(M, BP_EYES)
	if(istype(eyes) && !eyes.is_broken())
		ADJ_STATUS(M, STAT_BLURRY, -5)
		ADJ_STATUS(M, STAT_BLIND, -5)
		eyes.adjust_organ_damage(-(5 * removed))

/decl/material/liquid/antirads
	name = "antirads"
	lore_text = "A synthetic recombinant protein, derived from entolimod, used in the treatment of radiation poisoning."
	taste_description = "bitterness"
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_antirads"

/decl/material/liquid/antirads/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.radiation = max(M.radiation - 30 * removed, 0)

/decl/material/liquid/brute_meds
	name = "styptic powder"
	lore_text = "An analgesic and bleeding suppressant that helps with recovery from physical trauma. Can assist with mending arteries if injected in large amounts, but will cause complications."
	taste_description = "bitterness"
	taste_mult = 3
	color = "#bf0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	fruit_descriptor = "medicinal"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_styptic"
	var/effectiveness = 1

/decl/material/liquid/brute_meds/affect_overdose(mob/living/victim, total_dose)
	..()
	victim.add_chemical_effect(CE_BLOCKAGE, (15 + total_dose) / 100)
	for(var/obj/item/organ/external/limb in victim.get_external_organs())
		if((limb.status & ORGAN_ARTERY_CUT) && prob(2 + total_dose / overdose))
			limb.status &= ~ORGAN_ARTERY_CUT

//This is a logistic function that effectively doubles the healing rate as brute amounts get to around 200. Any injury below 60 is essentially unaffected and there's a scaling inbetween.
#define ADJUSTED_REGEN_VAL(X) (6+(6/(1+200*2.71828**(-0.05*(X)))))
/decl/material/liquid/brute_meds/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.add_stressor(/datum/stressor/used_chems, 5 MINUTES)
	M.add_chemical_effect_max(CE_REGEN_BRUTE, round(effectiveness*ADJUSTED_REGEN_VAL(M.get_damage(BRUTE))))
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/liquid/burn_meds
	name = "synthskin"
	lore_text = "A synthetic sealant, disinfectant and analgesic that encourages burned tissue to recover."
	taste_description = "bitterness"
	color = "#ffa800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_synthskin"
	var/effectiveness = 1

/decl/material/liquid/burn_meds/affect_blood(mob/living/M, removed, var/datum/reagents/holder)
	..()
	M.add_stressor(/datum/stressor/used_chems, 5 MINUTES)
	M.add_chemical_effect_max(CE_REGEN_BURN, round(effectiveness*ADJUSTED_REGEN_VAL(M.get_damage(BURN))))
	M.add_chemical_effect(CE_PAINKILLER, 10)
#undef ADJUSTED_REGEN_VAL

/decl/material/liquid/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	lore_text = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	color = "#c8a5dc"
	flags = AFFECTS_DEAD //This can even heal dead people.
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	uid = "chem_adminorazine"

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/decl/material/liquid/adminordrazine/affect_touch(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	affect_blood(M, removed, holder)
	return TRUE

/decl/material/liquid/adminordrazine/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.rejuvenate()

/decl/material/liquid/antitoxins
	name = "antitoxins"
	lore_text = "A mix of broad-spectrum antitoxins used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	color = "#00a000"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	fruit_descriptor = "astringent"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_antitoxins"
	var/antitoxin_strength = 1 // effect multiplier
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/decl/material/liquid/zombiepowder
	)

/decl/material/liquid/antitoxins/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	if(remove_generic)
		ADJ_STATUS(M, STAT_DROWSY, -6 * removed * antitoxin_strength)
		M.adjust_hallucination(-9 * removed * antitoxin_strength)
		M.add_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed * antitoxin_strength)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(ingested))
		if((remove_generic && reagent.toxicity) || (reagent.type in remove_toxins))
			ingested.remove_reagent(reagent, removing)
			return

	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(M.reagents))
		if((remove_generic && reagent.toxicity) || (reagent.type in remove_toxins))
			M.remove_from_reagents(reagent, removing)
			return

/decl/material/liquid/immunobooster
	name = "immunobooster"
	lore_text = "A drug that helps restore the immune system. Will not replace a normal immunity."
	taste_description = "chalk"
	color = "#ffc0cb"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	scannable = 1
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_immunobooster"

/decl/material/liquid/immunobooster/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	if(REAGENT_VOLUME(holder, src) >= REAGENTS_OVERDOSE)
		return
	var/immunity_to_add = clamp((M.immunity_norm / 2) - M.get_immunity(), 0, removed)
	if(immunity_to_add > 0)
		M.adjust_immunity(immunity_to_add) // Rapidly brings someone up to half immunity.

/decl/material/liquid/immunobooster/affect_overdose(mob/living/victim, total_dose)
	..()
	victim.add_chemical_effect(CE_TOXIN, 1)
	victim.adjust_immunity(-0.5)

/decl/material/liquid/antibiotics
	name = "antibiotics"
	lore_text = "An all-purpose antibiotic agent."
	taste_description = "bitterness"
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 1.5
	antibiotic_strength = 1
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_antibiotics"

/decl/material/liquid/antibiotics/affect_overdose(mob/living/victim, total_dose)
	..()
	victim.adjust_immunity(-0.5)
	victim.immunity = max(victim.immunity - 0.25, 0)
	if(prob(2))
		victim.immunity_norm = max(victim.immunity_norm - 1, 0)

/decl/material/liquid/retrovirals
	name = "retrovirals"
	lore_text = "A combination of retroviral therapy compounds and a meta-polymerase that rapidly mends genetic damage and unwanted mutations with the power of dark science."
	taste_description = "acid"
	color = "#004000"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_retrovirals"

/decl/material/liquid/retrovirals/affect_overdose(mob/living/victim, total_dose)
	. = ..()
	for(var/obj/item/organ/external/limb in victim.get_external_organs())
		if(!BP_IS_PROSTHETIC(limb) && prob(25) && !(limb.status & ORGAN_MUTATED))
			limb.mutate()
			limb.limb_flags |= ORGAN_FLAG_DEFORMED

/decl/material/liquid/retrovirals/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.heal_damage(CLONE, 20 * removed)
	if(CHEM_DOSE(M, src) > 10)
		ADJ_STATUS(M, STAT_DIZZY, 5)
		ADJ_STATUS(M, STAT_JITTER, 5)
	M.reset_genetic_conditions()

/decl/material/liquid/adrenaline
	name = "adrenaline"
	lore_text = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.1
	value = 1.5
	uid = "chem_adrenaline"

/decl/material/liquid/adrenaline/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/affect_volume = REAGENT_VOLUME(holder, src)
	var/dose = CHEM_DOSE(M, src)
	. = ..()
	if(dose < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(30*affect_volume, 80))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(dose < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*affect_volume, 20))
	M.add_chemical_effect(CE_PULSE, 2)
	if(dose > 10)
		ADJ_STATUS(M, STAT_JITTER, 5)
	if(affect_volume >= 5 && M.is_asystole())
		holder.remove_reagent(type, 5)
		if(ishuman(M))
			var/mob/living/human/H = M
			if(H.resuscitate())
				var/obj/item/organ/internal/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
				heart.take_damage(heart.max_damage * 0.15)

/decl/material/liquid/stabilizer
	name = "stabilizer"
	lore_text = "A wonder drug that stabilizes autonomous nervous system, smoothing out irregularities in breathing and pulse, and helps against short-term brain damage."
	taste_description = "gauze"
	color = "#7efff9"
	scannable = 1
	metabolism = 0.5 * REM
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_stabilizer"

/decl/material/liquid/stabilizer/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_STABLE)
	M.remove_chemical_effect(CE_ALLERGEN)

/decl/material/liquid/regenerator
	name = "regenerative serum"
	lore_text = "A broad-spectrum cellular regenerator that heals both burns and physical trauma, albeit quite slowly."
	taste_description = "metastasis"
	color = "#8040ff"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_regenerative_serum"

/decl/material/liquid/regenerator/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.add_stressor(/datum/stressor/used_chems, 5 MINUTES)
	M.add_chemical_effect_max(CE_REGEN_BRUTE, 3 * removed)
	M.add_chemical_effect_max(CE_REGEN_BURN, 3 * removed)

/decl/material/liquid/neuroannealer
	name = "neuroannealer"
	lore_text = "A neuroplasticity-assisting compound that helps to lessen damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	color = "#ffff66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_neuroannealer"

/decl/material/liquid/neuroannealer/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/human/H = M
		ADJ_STATUS(H, STAT_CONFUSE, 1)
		ADJ_STATUS(H, STAT_DROWSY, 1)

/decl/material/liquid/oxy_meds
	name = "oxygel"
	lore_text = "A biodegradable gel full of oxygen-laden synthetic molecules. Injected into suffocation victims to stave off the effects of oxygen deprivation."
	taste_description = "tasteless slickness"
	scannable = 1
	color = COLOR_GRAY80
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_oxygel"

/decl/material/liquid/oxy_meds/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 2 * removed)

/decl/material/liquid/clotting_agent
	name = "clotting agent"
	uid = "chem_clotting_agent"
	lore_text = "A medication used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	color = "#4246c7"
	scannable = TRUE

/decl/material/liquid/clotting_agent/affect_blood(mob/living/M, removed, datum/reagents/holder)
	SET_STATUS_MAX(M, STAT_BLURRY, 30)
	M.add_chemical_effect(CE_BLOCKAGE, (15 + REAGENT_VOLUME(holder, src))/100)
	for(var/obj/item/organ/external/limb in M.get_external_organs())
		if(!(limb.status & (ORGAN_ARTERY_CUT|ORGAN_BLEEDING)) || !prob(2 + REAGENT_VOLUME(holder, src)))
			continue
		if(limb.status & ORGAN_ARTERY_CUT)
			limb.status &= ~ORGAN_ARTERY_CUT
			break
		if(limb.status & ORGAN_BLEEDING)
			var/closed_wound = FALSE
			for(var/datum/wound/wound in limb.wounds)
				if(wound.bleeding() && !wound.clamped)
					wound.clamped = TRUE
					closed_wound = TRUE
					break
			if(closed_wound)
				break
	..()

/decl/material/liquid/clotting_agent/affect_overdose(mob/living/victim, total_dose)
	var/obj/item/organ/internal/heart = GET_INTERNAL_ORGAN(victim, BP_HEART)
	if(heart && prob(25))
		heart.take_damage(rand(1,3))
	return ..()

#define DETOXIFIER_EFFECTIVENESS 6 // 6u of opiates removed per 1u of detoxifier; 5u is enough to remove 30u, i.e. an overdose
#define DETOXIFIER_DOSE_EFFECTIVENESS 2 // 2u of metabolised opiates removed per 1u of detoxifier; will leave you vulnerable to another OD if you use more
/decl/material/liquid/detoxifier
	name = "detoxifier"
	lore_text = "A compound designed to purge opiates and narcotics from the body when inhaled or injected."
	taste_description = "bitterness"
	color = "#6666ff"
	metabolism = REM
	scannable = TRUE
	affect_blood_on_ingest = FALSE
	value = 1.5
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	uid = "chem_detoxifier"

/decl/material/liquid/detoxifier/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	var/charges = removed * DETOXIFIER_EFFECTIVENESS
	var/dosecharges = CHEM_DOSE(M, src) * DETOXIFIER_DOSE_EFFECTIVENESS
	for(var/datum/reagents/container as anything in M.get_metabolizing_reagent_holders())
		for(var/decl/material/reagent as anything in REAGENT_VOLUMES(container))
			var/decl/material/liquid/painkillers/painkiller = reagent
			if(!istype(painkiller) || !painkiller.narcotic)
				continue
			var/amount = min(charges, REAGENT_VOLUME(container, reagent))
			if(amount)
				charges -= amount
				container.remove_reagent(reagent, amount)
			var/dose_amount = min(dosecharges, CHEM_DOSE(M, reagent))
			if(dose_amount)
				var/dose = CHEM_DOSE(M, reagent) - dose_amount
				LAZYSET(M._chem_doses, reagent, dose)
				if(CHEM_DOSE(M, reagent) <= 0)
					LAZYREMOVE(M._chem_doses, reagent)
				dosecharges -= dose_amount
			if(charges <= 0 && dosecharges <= 0)
				break
		if(charges <= 0 && dosecharges <= 0)
			break
#undef DETOXIFIER_EFFECTIVENESS
#undef DETOXIFIER_DOSE_EFFECTIVENESS

