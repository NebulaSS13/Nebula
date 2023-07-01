/decl/material/liquid/denatured_toxin
	name = "denatured toxin"
	uid = "liquid_denatured_toxin"
	lore_text = "Once toxic, now harmless."
	taste_description = null
	taste_mult = null
	color = "#808080"
	metabolism = REM
	toxicity_targets_organ = null
	toxicity = 0
	hidden_from_codex = TRUE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE // It's useless, don't use it.

/decl/material/liquid/plasticide
	name = "plasticide"
	uid = "liquid_plasticide"
	lore_text = "Liquid plastic, do not eat."
	taste_description = "plastic"
	color = "#cf3600"
	toxicity = 5
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/amatoxin
	name = "amatoxin"
	uid = "liquid_amatoxin"
	lore_text = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#792300"
	toxicity = 10
	heating_products = list(
		/decl/material/liquid/denatured_toxin = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "becomes clear."
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/carpotoxin
	name = "carpotoxin"
	uid = "liquid_carpotoxin"
	lore_text = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	color = "#003333"
	toxicity_targets_organ = BP_BRAIN
	toxicity = 10
	heating_products = list(
		/decl/material/liquid/denatured_toxin = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "becomes clear."
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/venom
	name = "spider venom"
	uid = "liquid_spider_venom"
	lore_text = "A deadly necrotic toxin produced by giant spiders to disable their prey."
	taste_description = "absolutely vile"
	color = "#91d895"
	toxicity_targets_organ = BP_LIVER
	toxicity = 5
	heating_products = list(
		/decl/material/liquid/denatured_toxin = 1
	)
	heating_point = 100 CELSIUS
	heating_message = "becomes clear."
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/venom/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(prob(REAGENT_VOLUME(holder, type)*2))
		SET_STATUS_MAX(M, STAT_CONFUSE, 3)
	..()

/decl/material/liquid/cyanide //Fast and Lethal
	name = "cyanide"
	uid = "liquid_cyanide"
	lore_text = "A highly toxic chemical."
	taste_mult = 0.6
	color = "#cf3600"
	toxicity = 20
	metabolism = REM * 2
	toxicity_targets_organ = BP_HEART
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/cyanide/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	ADJ_STATUS(M, STAT_ASLEEP, 1)

/decl/material/liquid/heartstopper
	name = "heartstopper"
	uid = "liquid_heartstopper"
	lore_text = "A potent cardiotoxin that paralyzes the heart."
	taste_description = "intense bitterness"
	color = "#6b833b"
	toxicity = 16
	overdose = REAGENTS_OVERDOSE / 3
	metabolism = REM * 2
	toxicity_targets_organ = BP_HEART
	taste_mult = 1.2
	exoplanet_rarity_plant = MAT_RARITY_UNCOMMON
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/heartstopper/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	ADJ_STATUS(M, STAT_CONFUSE, 1.5)

/decl/material/liquid/heartstopper/affect_overdose(var/mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath-10)
			H.adjustOxyLoss(2)
			SET_STATUS_MAX(H, STAT_WEAK, 10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/liquid/zombiepowder
	name = "zombie powder"
	uid = "liquid_zombie_powder"
	lore_text = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	color = "#669900"
	metabolism = REM
	toxicity = 3
	toxicity_targets_organ = BP_BRAIN
	heating_point = 100 CELSIUS
	heating_message = "melts into a liquid slurry."
	heating_products = list(
		/decl/material/liquid/carpotoxin = 0.2,
		/decl/material/liquid/sedatives = 0.4,
		/decl/material/solid/metal/copper = 0.4
	)
	taste_mult = 1.2
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/zombiepowder/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	SET_STATUS_MAX(M, STAT_WEAK, 10)
	SET_STATUS_MAX(M, STAT_SILENCE, 10)
	if(LAZYACCESS(M.chem_doses, type) <= removed) //half-assed attempt to make timeofdeath update only at the onset
		M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/liquid/zombiepowder/on_leaving_metabolism(datum/reagents/metabolism/holder)
	var/mob/M = holder?.my_atom
	if(istype(M))
		M.status_flags &= ~FAKEDEATH
	. = ..()

/decl/material/liquid/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	uid = "liquid_fertilizer"
	lore_text = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	toxicity = 0.5 // It's not THAT poisonous.
	color = "#664330"
	metabolism = REM * 0.25
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/weedkiller
	name = "weedkiller"
	uid = "liquid_weedkiller"
	lore_text = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	color = "#49002e"
	toxicity = 4
	heating_products = list(
		/decl/material/liquid/bromide = 0.4,
		/decl/material/liquid/water = 0.6
	)
	heating_point = 100 CELSIUS
	metabolism = REM * 0.25
	defoliant = TRUE
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/liquid/tar
	name = "tar"
	uid = "liquid_tar"
	lore_text = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	toxicity = 4
	heating_products = list(
		/decl/material/liquid/acetone = 0.4,
		/decl/material/solid/carbon = 0.4,
		/decl/material/liquid/ethanol = 0.2
	)
	heating_point = 145 CELSIUS
	heating_message = "separates"
	taste_mult = 1.2
	metabolism = REM * 0.25
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/liquid/hair_remover
	name = "hair remover"
	uid = "liquid_hair_remover"
	lore_text = "An extremely effective chemical depilator. Do not ingest."
	taste_description = "acid"
	color = "#d9ffb3"
	toxicity = 1
	overdose = REAGENTS_OVERDOSE
	taste_mult = 1.2
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE // i am so tired of seeing hair remover planets
	metabolism = REM * 0.25

/decl/material/liquid/hair_remover/affect_touch(var/mob/M, var/removed, var/datum/reagents/holder)
	M.lose_hair()
	holder.remove_reagent(type, REAGENT_VOLUME(holder, type))

/decl/material/liquid/zombie
	name = "liquid corruption"
	uid = "liquid_corruption"
	lore_text = "A filthy, oily substance which slowly churns of its own accord."
	taste_description = "decaying blood"
	color = "#800000"
	taste_mult = 5
	toxicity = 10
	metabolism = REM * 5
	overdose = 30
	hidden_from_codex = TRUE
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE
	var/amount_to_zombify = 5

/decl/material/liquid/zombie/affect_touch(var/mob/living/M, var/removed, var/datum/reagents/holder)
	affect_blood(M, removed * 0.5, holder)

/decl/material/liquid/zombie/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/true_dose = LAZYACCESS(H.chem_doses, type) + REAGENT_VOLUME(holder, type)
		if (true_dose >= amount_to_zombify)
			H.zombify()
		else if (true_dose > 1 && prob(20))
			H.zombify()
		else if (prob(10))
			to_chat(H, "<span class='warning'>You feel terribly ill!</span>")

/decl/material/liquid/bromide
	name = "bromide"
	codex_name = "elemental bromide"
	uid = "liquid_bromide"
	lore_text = "A dark, nearly opaque, red-orange, toxic element."
	taste_description = "pestkiller"
	color = "#4c3b34"
	toxicity = 3
	taste_mult = 1.2
	metabolism = REM * 0.25

/decl/material/liquid/mercury
	name = "mercury"
	uid = "liquid_mercury"
	lore_text = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	color = "#484848"
	value = 0.5
	narcosis = 5
