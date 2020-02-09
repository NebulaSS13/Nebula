/datum/reagent/glowsap
	name = "glowsap"
	description = "A popular party drug for adventurous types who want to BE the glowstick. May be hallucinogenic in high doses."
	overdose = 15
	color = "#9eefff"

/datum/reagent/glowsap/affect_ingest(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed)

/datum/reagent/glowsap/affect_blood(mob/living/carbon/M, alien, removed)
	M.add_chemical_effect(CE_GLOWINGEYES, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_eyes()

/datum/reagent/glowsap/on_leaving_metabolism(mob/parent, metabolism_class)
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		addtimer(CALLBACK(H, /mob/living/carbon/human/proc/update_eyes), 5 SECONDS)
	. = ..()

/datum/reagent/glowsap/overdose(var/mob/living/carbon/M, var/alien)
	. = ..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)
