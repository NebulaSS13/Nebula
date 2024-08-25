// RENAMED:
/decl/material/liquid/stabilizer
	name = "inaprovaline"

/decl/material/liquid/brute_meds
	name = "bicaridine"
	lore_text = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."

/decl/material/liquid/burn_meds
	name = "kelotane"
	lore_text = "Kelotane is a drug used to treat burns."

/decl/material/liquid/antitoxins
	name = "dylovene"
	lore_text = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harm."

/decl/material/liquid/oxy_meds
	name = "dexalin"
	lore_text = "Dexalin is used in the treatment of oxygen deprivation."
	color = "#0080ff"
	uid = "chem_dexalin"

/decl/material/liquid/oxy_meds/dexalinp
	name = "dexalin plus"
	lore_text = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	color = "#0040ff"
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 3.7
	uid = "chem_dexalin_plus"

/decl/material/liquid/oxy_meds/dexalinp/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 2) // change to add_chemical_effect_max later
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 3 * removed)

/decl/material/liquid/regenerator
	name = "tricordrazine"
	lore_text = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."

/decl/material/liquid/neuroannealer
	name = "alkysine"
	lore_text = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."

/decl/material/liquid/eyedrops
	name = "imidazoline"

/decl/material/liquid/retrovirals
	name = "ryetalyn"
	lore_text = "Ryetalyn can cure all genetic abnomalities via a catalytic process."

/decl/material/liquid/antirads
	name = "hyronalin"
	lore_text = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."

/decl/material/liquid/antibiotics
	name = "spaceacillin"
	lore_text = "An all-purpose antiviral agent."

/decl/material/liquid/antiseptic
	name = "sterilizine"

/decl/material/liquid/stimulants
	name = "methylphenidate"
	lore_text = "Improves the ability to concentrate."

/decl/material/liquid/antidepressants
	name = "citalopram"
	lore_text = "Stabilizes the mind a little."

// NEW, NOT RENAMED:
/decl/material/liquid/antidepressants/paroxetine
	name = "paroxetine"
	value = 3.5
	uid = "chem_paroxetine"

/decl/material/liquid/antidepressants/paroxetine/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume <= 0.1 && LAZYACCESS(M.chem_doses, type) >= 0.5 && world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, SPAN_WARNING("Your mind feels much less stable..."))
	else
		M.add_chemical_effect(CE_MIND, 2)
		M.adjust_hallucination(-10)
		if(world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
			LAZYSET(holder.reagent_data, type, world.time)
			if(prob(90))
				to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
			else
				to_chat(M, SPAN_WARNING("Your mind breaks apart..."))
				M.set_hallucination(200, 100)

/decl/material/liquid/burn_meds/dermaline
	name = "dermaline"
	lore_text = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	color = "#ff8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	value = 3.9
	uid = "chem_dermaline"

/decl/material/liquid/burn_meds/dermaline/affect_blood(mob/living/M, alien, removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 6 * removed) // 6 extra damage on top of kelotane's 6

/decl/material/liquid/antirads/arithrazine
	name = "arithrazine"
	lore_text = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	color = "#008000"
	value = 2.7
	uid = "chem_arithrazine"

/decl/material/liquid/antirads/arithrazine/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.radiation = max(M.radiation - 70 * removed, 0)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)