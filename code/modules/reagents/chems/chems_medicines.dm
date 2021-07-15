/decl/material/liquid/eyedrops
	name = "eye drops"
	lore_text = "A soothing balm that helps with minor eye damage."
	taste_description = "a mild burn"
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/liquid/eyedrops/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_internal_organ(BP_EYES)
		if(E && istype(E) && !E.is_broken())
			ADJ_STATUS(M, STAT_BLURRY, -5) 
			ADJ_STATUS(M, STAT_BLIND, -5)
			E.damage = max(E.damage - 5 * removed, 0)

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

/decl/material/liquid/antirads/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/liquid/brute_meds/affect_overdose(mob/living/M, alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + REAGENT_VOLUME(holder, type))/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2 + REAGENT_VOLUME(holder, type) / overdose))
				E.status &= ~ORGAN_ARTERY_CUT

/decl/material/liquid/brute_meds/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/overkill_healing = 6/(1+200*2.71828**(-0.05*M.getBruteLoss())) //This is a logistic function that effectively doubles the healing rate as brute amounts get to around 200. Any injury below 60 is essentially unaffected and there's a scaling inbetween.
	M.heal_organ_damage((6+overkill_healing) * removed, 0)
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

/decl/material/liquid/burn_meds/affect_blood(mob/living/M, alien, removed, var/datum/reagents/holder)
	var/overkill_healing = 6/(1+200*2.71828**(-0.05*M.getFireLoss()))	
	M.heal_organ_damage(0, (6+overkill_healing) * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/liquid/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	lore_text = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	color = "#c8a5dc"
	flags = AFFECTS_DEAD //This can even heal dead people.

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/decl/material/liquid/adminordrazine/affect_touch(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed, holder)

/decl/material/liquid/adminordrazine/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
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
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/decl/material/liquid/zombiepowder
	)

/decl/material/liquid/antitoxins/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(remove_generic)
		ADJ_STATUS(M, STAT_DROWSY, -6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/R in ingested.reagent_volumes)
		var/decl/material/chem = GET_DECL(R)
		if((remove_generic && chem.toxicity) || (R in remove_toxins))
			M.reagents.remove_reagent(R, removing)
			return

	for(var/R in M.reagents?.reagent_volumes)
		var/decl/material/chem = GET_DECL(R)
		if((remove_generic && chem.toxicity) || (R in remove_toxins))
			M.reagents.remove_reagent(R, removing)
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

/decl/material/liquid/immunobooster/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M) && REAGENT_VOLUME(holder, type) < REAGENTS_OVERDOSE)
		var/mob/living/carbon/human/H = M
		H.immunity = min(H.immunity_norm * 0.5, removed + H.immunity) // Rapidly brings someone up to half immunity.

/decl/material/liquid/immunobooster/affect_overdose(var/mob/living/M, var/alien, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_TOXIN, 1)
	var/mob/living/carbon/human/H = M
	if(istype(H))
		H.immunity -= 0.5 //inverse effects when abused

/decl/material/liquid/stimulants
	name = "stimulants"
	lore_text = "Improves the ability to concentrate."
	taste_description = "sourness"
	color = "#bf80bf"
	scannable = 1
	metabolism = 0.01
	value = 1.5

/decl/material/liquid/stimulants/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume <= 0.1 && LAZYACCESS(M.chem_doses, type) >= 0.5 && world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		ADJ_STATUS(M, STAT_DROWSY, -5)
		ADJ_STATUS(M, STAT_PARA, -1)
		ADJ_STATUS(M, STAT_STUN, -1)
		ADJ_STATUS(M, STAT_WEAK, -1)
		if(world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
			LAZYSET(holder.reagent_data, type, world.time)
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/decl/material/liquid/antidepressants
	name = "antidepressants"
	lore_text = "Stabilizes the mind a little."
	taste_description = "bitterness"
	color = "#ff80ff"
	scannable = 1
	metabolism = 0.01
	value = 1.5

/decl/material/liquid/antidepressants/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume <= 0.1 && LAZYACCESS(M.chem_doses, type) >= 0.5 && world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 1)
		M.adjust_hallucination(-10)
		if(world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
			LAZYSET(holder.reagent_data, type, world.time)
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/decl/material/liquid/antibiotics
	name = "antibiotics"
	lore_text = "An all-purpose antibiotic agent."
	taste_description = "bitterness"
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 1.5

/decl/material/liquid/antibiotics/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	H.immunity = max(H.immunity - 0.1, 0)
	H.add_chemical_effect(CE_ANTIBIOTIC, 1)
	if(volume > 10)
		H.immunity = max(H.immunity - 0.3, 0)
	if(LAZYACCESS(H.chem_doses, type) > 15)
		H.immunity = max(H.immunity - 0.25, 0)

/decl/material/liquid/antibiotics/affect_overdose(var/mob/living/M, var/alien, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	H.immunity = max(H.immunity - 0.25, 0)
	if(prob(2))
		H.immunity_norm = max(H.immunity_norm - 1, 0)

/decl/material/liquid/retrovirals
	name = "retrovirals"
	lore_text = "A combination of retroviral therapy compounds and a meta-polymerase that rapidly mends genetic damage and unwanted mutations with the power of dark science."
	taste_description = "acid"
	color = "#004000"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 1.5

/decl/material/liquid/retrovirals/affect_overdose(mob/living/M, alien, datum/reagents/holder)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(!BP_IS_PROSTHETIC(E) && prob(25) && !(E.status & ORGAN_MUTATED))
				E.mutate()
				E.limb_flags |= ORGAN_FLAG_DEFORMED
	
/decl/material/liquid/retrovirals/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustCloneLoss(-20 * removed)
	if(LAZYACCESS(M.chem_doses, type) > 10)
		ADJ_STATUS(M, STAT_DIZZY, 5)
		ADJ_STATUS(M, STAT_JITTER, 5)
	var/needs_update = M.mutations.len > 0
	M.mutations.Cut()
	M.disabilities = 0
	M.sdisabilities = 0
	if(needs_update && ishuman(M))
		M.dna.ResetUI()
		M.dna.ResetSE()
		domutcheck(M, null, MUTCHK_FORCED)
		M.update_icon()

/decl/material/liquid/adrenaline
	name = "adrenaline"
	lore_text = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.1
	value = 1.5

/decl/material/liquid/adrenaline/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(30*volume, 80))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(dose < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*volume, 20))
	M.add_chemical_effect(CE_PULSE, 2)
	if(dose > 10)
		ADJ_STATUS(M, STAT_JITTER, 5)
	if(volume >= 5 && M.is_asystole())
		holder.remove_reagent(type, 5)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.resuscitate())
				var/obj/item/organ/internal/heart = H.get_internal_organ(BP_HEART)
				heart.take_internal_damage(heart.max_damage * 0.15)

/decl/material/liquid/stabilizer
	name = "stabilizer"
	lore_text = "A wonder drug that stabilizes autonomous nervous system, smoothing out irregularities in breathing and pulse, and helps against short-term brain damage."
	taste_description = "gauze"
	color = "#7efff9"
	scannable = 1
	metabolism = 0.5 * REM
	value = 1.5

/decl/material/liquid/stabilizer/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_STABLE)

/decl/material/liquid/regenerator
	name = "regenerative serum"
	lore_text = "A broad-spectrum cellular regenerator that heals both burns and physical trauma, albeit quite slowly."
	taste_description = "metastasis"
	color = "#8040ff"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/liquid/regenerator/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(3 * removed, 3 * removed)

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

/decl/material/liquid/neuroannealer/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		ADJ_STATUS(H, STAT_CONFUSE, 1)
		ADJ_STATUS(H, STAT_DROWSY, 1)

/decl/material/liquid/oxy_meds
	name = "oxygel"
	lore_text = "A biodegradable gel full of oxygen-laden synthetic molecules. Injected into suffocation victims to stave off the effects of oxygen deprivation."
	taste_description = "tasteless slickness"
	scannable = 1
	color = COLOR_GRAY80

/decl/material/liquid/oxy_meds/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 2 * removed)
