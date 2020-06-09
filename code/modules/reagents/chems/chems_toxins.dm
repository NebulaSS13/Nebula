/decl/material/chem/toxin
	name = "toxin"
	lore_text = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	color = "#cf3600"
	metabolism = REM * 0.25 // 0.05 by default. They last a while and slowly kill you.
	heating_products = list(
		/decl/material/chem/toxin/denatured = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "goes clear."
	value = 1.5

/decl/material/chem/toxin/denatured
	name = "denatured toxin"
	lore_text = "Once toxic, now harmless."
	taste_description = null
	taste_mult = null
	color = "#808080"
	metabolism = REM
	heating_products = null
	heating_point = null
	toxicity_targets_organ = null
	toxicity = 0
	hidden_from_codex = TRUE

/decl/material/chem/toxin/slimejelly
	name = "slime jelly"
	lore_text = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	taste_description = "slime"
	taste_mult = 1.3
	color = "#801e28"
	toxicity = 10

/decl/material/chem/toxin/plasticide
	name = "plasticide"
	lore_text = "Liquid plastic, do not eat."
	taste_description = "plastic"
	color = "#cf3600"
	toxicity = 5
	heating_point = null
	heating_products = null

/decl/material/chem/toxin/amatoxin
	name = "amatoxin"
	lore_text = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#792300"
	toxicity = 10

/decl/material/chem/toxin/carpotoxin
	name = "carpotoxin"
	lore_text = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	color = "#003333"
	toxicity_targets_organ = BP_BRAIN
	toxicity = 10

/decl/material/chem/toxin/venom
	name = "spider venom"
	lore_text = "A deadly necrotic toxin produced by giant spiders to disable their prey."
	taste_description = "absolutely vile"
	color = "#91d895"
	toxicity_targets_organ = BP_LIVER
	toxicity = 5

/decl/material/chem/toxin/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(REAGENT_VOLUME(holder, type)*2))
		M.confused = max(M.confused, 3)
	..()

/decl/material/chem/toxin/chlorine
	name = "chlorine"
	lore_text = "A highly poisonous liquid. Smells strongly of bleach."
	taste_description = "bleach"
	color = "#707c13"
	toxicity = 15
	metabolism = REM
	heating_point = null
	heating_products = null

/decl/material/chem/toxin/phoron
	name = "phoron"
	lore_text = "Phoron in its liquid form."
	taste_mult = 1.5
	color = "#ff3300"
	toxicity = 30
	touch_met = 5
	heating_point = null
	heating_products = null
	value = 4
	fuel_value = 2
	vapor_products = list(MAT_PHORON = 1)

/decl/material/chem/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fuel_value))
		M.handle_contaminants()

// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/decl/material/chem/toxin/phoron/oxygen
	name = "oxyphoron"
	lore_text = "An exceptionally flammable molecule formed from deuterium synthesis."
	toxicity = 15
	fuel_value = 2.5
	vapor_products = list(
		MAT_OXYGEN = 0.5,
		MAT_PHORON = 0.5
	)

/decl/material/chem/toxin/cyanide //Fast and Lethal
	name = "cyanide"
	lore_text = "A highly toxic chemical."
	taste_mult = 0.6
	color = "#cf3600"
	toxicity = 20
	metabolism = REM * 2
	toxicity_targets_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/material/chem/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.sleeping += 1

/decl/material/chem/toxin/heartstopper
	name = "heartstopper"
	lore_text = "A potent cardiotoxin that paralyzes the heart."
	taste_description = "intense bitterness"
	color = "#6b833b"
	toxicity = 16
	overdose = REAGENTS_OVERDOSE / 3
	metabolism = REM * 2
	toxicity_targets_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/material/chem/toxin/heartstopper/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.confused += 1.5

/decl/material/chem/toxin/heartstopper/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/chem/toxin/zombiepowder
	name = "zombie powder"
	lore_text = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	color = "#669900"
	metabolism = REM
	toxicity = 3
	toxicity_targets_organ = BP_BRAIN
	heating_message = "melts into a liquid slurry."
	heating_products = list(
		/decl/material/chem/toxin/carpotoxin = 0.3, 
		/decl/material/chem/sedatives        = 0.35, 
		/decl/material/copper                = 0.35
	)

/decl/material/chem/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	if(M.chem_doses[type] <= removed) //half-assed attempt to make timeofdeath update only at the onset
		M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/chem/toxin/zombiepowder/on_leaving_metabolism(mob/parent, metabolism_class)
	parent?.status_flags &= ~FAKEDEATH
	. = ..()

/decl/material/chem/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	lore_text = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	toxicity = 0.5 // It's not THAT poisonous.
	color = "#664330"
	heating_point = null
	heating_products = null
	hidden_from_codex = TRUE

/decl/material/chem/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"

/decl/material/chem/toxin/fertilizer/left4zed
	name = "Left-4-Zed"

/decl/material/chem/toxin/fertilizer/robustharvest
	name = "Robust Harvest"

/decl/material/chem/toxin/plantbgone
	name = "Plant-B-Gone"
	lore_text = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	color = "#49002e"
	toxicity = 4
	heating_products = list(
		/decl/material/chem/toxin = 0.3, 
		/decl/material/gas/water = 0.7
	)
	defoliant = TRUE
		
/decl/material/chem/toxin/tar
	name = "tar"
	lore_text = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	toxicity = 4
	heating_products = list(
		/decl/material/chem/acetone = 0.2, 
		/decl/material/chem/carbon  = 0.6, 
		/decl/material/chem/ethanol = 0.2
	)
	heating_point = 145 CELSIUS
	heating_message = "separates"

/decl/material/chem/toxin/hair_remover
	name = "hair remover"
	lore_text = "An extremely effective chemical depilator. Do not ingest."
	taste_description = "acid"
	color = "#d9ffb3"
	toxicity = 1
	overdose = REAGENTS_OVERDOSE
	heating_products = null
	heating_point = null

/decl/material/chem/toxin/hair_remover/affect_touch(var/mob/M, var/alien, var/removed, var/datum/reagents/holder)
	M.lose_hair()
	holder.remove_reagent(type, REAGENT_VOLUME(holder, type))

/decl/material/chem/toxin/zombie
	name = "liquid corruption"
	lore_text = "A filthy, oily substance which slowly churns of its own accord."
	taste_description = "decaying blood"
	color = "#800000"
	taste_mult = 5
	toxicity = 10
	metabolism = REM * 5
	overdose = 30
	hidden_from_codex = TRUE
	heating_products = null
	heating_point = null
	var/amount_to_zombify = 5

/decl/material/chem/toxin/zombie/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed * 0.5, holder)

/decl/material/chem/toxin/zombie/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/true_dose = H.chem_doses[type] + REAGENT_VOLUME(holder, type)
		if (true_dose >= amount_to_zombify)
			H.zombify()
		else if (true_dose > 1 && prob(20))
			H.zombify()
		else if (prob(10))
			to_chat(H, "<span class='warning'>You feel terribly ill!</span>")

/decl/material/chem/toxin/bromide
	name = "bromide"
	lore_text = "A dark, nearly opaque, red-orange, toxic element."
	taste_description = "pestkiller"
	color = "#4c3b34"
	toxicity = 3
	heating_products = null
	heating_point = null
