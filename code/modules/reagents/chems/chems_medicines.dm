/datum/reagent/imidazoline
	name = "eye drops"
	description = "A soothing balm that helps with minor eye damage."
	taste_description = "a mild burn"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.2

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(E && istype(E) && !E.is_broken())
			M.eye_blurry = max(M.eye_blurry - 5, 0)
			M.eye_blind = max(M.eye_blind - 5, 0)
			E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/entolimod
	name = "entolimod"
	description = "A synthetic recombinant protein used in the treatment of radiation poisoning."
	taste_description = "bitterness"
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.3

/datum/reagent/entolimod/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/brute_meds
	name = "styptic powder"
	description = "A contact analgesic and bleeding suppressant that helps with recovery from physical trauma. When injected, can assist with mending arteries, but will cause complications."
	taste_description = "bitterness"
	taste_mult = 3
	color = "#bf0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.9

/datum/reagent/brute_meds/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + volume)/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2))
				E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/brute_meds/affect_touch(mob/living/carbon/M, alien, removed)
	M.heal_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/burn_meds
	name = "regenerative powder"
	description = "A contact analgesic that encourages burned tissue to recover."
	taste_description = "bitterness"
	color = "#ffa800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.9

/datum/reagent/burn_meds/affect_touch(mob/living/carbon/M, alien, removed)
	M.heal_organ_damage(0, 6 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	description = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	color = "#c8a5dc"
	flags = AFFECTS_DEAD //This can even heal dead people.

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/datum/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.rejuvenate()

/datum/reagent/antitoxins
	name = "antitoxins"
	description = "A mix of broad-spectrum antitoxins used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	color = "#00a000"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.1
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/datum/reagent/toxin/zombiepowder
	)

/datum/reagent/antitoxins/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(remove_generic)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_up_to_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/datum/reagent/R in ingested.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			ingested.remove_reagent(R.type, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			M.reagents.remove_reagent(R.type, removing)
			return


/datum/reagent/antivirals
	name = "Antivirals"
	description = "An all-in-one antiviral agent. Fever, cough, sneeze, safe for babies."
	taste_description = "cough syrup"
	color = "#c8a5dc"
	overdose = 60
	scannable = 1
	metabolism = REM * 0.05
	flags = IGNORE_MOB_SIZE

/datum/reagent/antivirals/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 15)
	M.add_chemical_effect(CE_ANTIVIRAL, 1)

/datum/reagent/antivirals/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)

/datum/reagent/immunobooster
	name = "immunobooster"
	description = "A drug that helps restore the immune system. Will not replace a normal immunity."
	taste_description = "chalky"
	color = "#ffc0cb"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	scannable = 1

/datum/reagent/immunobooster/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume < REAGENTS_OVERDOSE && !M.chem_effects[CE_ANTIVIRAL])
		M.immunity = min(M.immunity_norm * 0.5, removed + M.immunity) // Rapidly brings someone up to half immunity.
	if(M.chem_effects[CE_ANTIVIRAL]) //don't take with 'cillin
		M.add_chemical_effect(CE_TOXIN, 4) // as strong as taking vanilla 'toxin'

/datum/reagent/immunobooster/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.immunity -= 0.5 //inverse effects when abused

/datum/reagent/stimulants
	name = "stimulants"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	color = "#bf80bf"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

/datum/reagent/stimulants/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + 5 MINUTES)
		data = world.time
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		M.drowsyness = max(M.drowsyness - 5, 0)
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
		if(world.time > data + 5 MINUTES)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/antidepressants
	name = "antidepressants"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	color = "#ff80ff"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

/datum/reagent/antidepressants/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + 5 MINUTES)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 1)
		M.adjust_hallucination(-10)
		if(world.time > data + 5 MINUTES)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/antibiotics
	name = "antibiotics"
	description = "An all-purpose antibiotic agent."
	taste_description = "bitterness"
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 2.5

/datum/reagent/antibiotics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.immunity = max(M.immunity - 0.1, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_COMMON)
	M.add_chemical_effect(CE_ANTIBIOTIC, 1)
	if(volume > 10)
		M.immunity = max(M.immunity - 0.3, 0)
		M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_ENGINEERED)
	if(M.chem_doses[type] > 15)
		M.immunity = max(M.immunity - 0.25, 0)

/datum/reagent/antibiotics/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.immunity = max(M.immunity - 0.25, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_EXOTIC)
	if(prob(2))
		M.immunity_norm = max(M.immunity_norm - 1, 0)
