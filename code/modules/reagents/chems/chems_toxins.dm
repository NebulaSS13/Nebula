/decl/material/toxin
	name = "toxin"
	lore_text = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	color = "#cf3600"
	metabolism = REM * 0.25 // 0.05 by default. They last a while and slowly kill you.
	heating_products = list(/decl/material/toxin/denatured)
	heating_point = 100 CELSIUS
	heating_message = "goes clear."
	value = 1.5

	var/target_organ
	var/strength = 4 // How much damage it deals per unit

/decl/material/toxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(strength)
		M.add_chemical_effect(CE_TOXIN, strength)
		var/dam = (strength * removed)
		if(target_organ && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
			if(I)
				var/can_damage = I.max_damage - I.damage
				if(can_damage > 0)
					if(dam > can_damage)
						I.take_internal_damage(can_damage, silent=TRUE)
						dam -= can_damage
					else
						I.take_internal_damage(dam, silent=TRUE)
						dam = 0
		if(dam)
			M.adjustToxLoss(target_organ ? (dam * 0.75) : dam)

/decl/material/toxin/denatured
	name = "denatured toxin"
	lore_text = "Once toxic, now harmless."
	taste_description = null
	taste_mult = null
	color = "#808080"
	metabolism = REM
	heating_products = null
	heating_point = null
	target_organ = null
	strength = 0
	hidden_from_codex = TRUE

/decl/material/toxin/slimejelly
	name = "slime jelly"
	lore_text = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	taste_description = "slime"
	taste_mult = 1.3
	color = "#801e28"
	strength = 10

/decl/material/toxin/plasticide
	name = "plasticide"
	lore_text = "Liquid plastic, do not eat."
	taste_description = "plastic"
	color = "#cf3600"
	strength = 5
	heating_point = null
	heating_products = null

/decl/material/toxin/amatoxin
	name = "amatoxin"
	lore_text = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#792300"
	strength = 10

/decl/material/toxin/carpotoxin
	name = "carpotoxin"
	lore_text = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	color = "#003333"
	target_organ = BP_BRAIN
	strength = 10

/decl/material/toxin/venom
	name = "spider venom"
	lore_text = "A deadly necrotic toxin produced by giant spiders to disable their prey."
	taste_description = "absolutely vile"
	color = "#91d895"
	target_organ = BP_LIVER
	strength = 5

/decl/material/toxin/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(REAGENT_VOLUME(holder, type)*2))
		M.confused = max(M.confused, 3)
	..()

/decl/material/toxin/chlorine
	name = "chlorine"
	lore_text = "A highly poisonous liquid. Smells strongly of bleach."
	taste_description = "bleach"
	color = "#707c13"
	strength = 15
	metabolism = REM
	heating_point = null
	heating_products = null

/decl/material/toxin/phoron
	name = "phoron"
	lore_text = "Phoron in its liquid form."
	taste_mult = 1.5
	color = "#ff3300"
	strength = 30
	touch_met = 5
	heating_point = null
	heating_products = null
	value = 4
	fuel_value = 5

/decl/material/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fuel_value))
		M.pl_effects()

/decl/material/toxin/phoron/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_PHORON, volume, T20C)
	holder.remove_reagent(type, volume)

// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/decl/material/toxin/phoron/oxygen
	name = "oxyphoron"
	lore_text = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 15
	fuel_value = 15

/decl/material/toxin/phoron/oxygen/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_OXYGEN, ceil(volume/2), T20C)
	T.assume_gas(MAT_PHORON, ceil(volume/2), T20C)
	holder.remove_reagent(type, volume)

/decl/material/toxin/cyanide //Fast and Lethal
	name = "cyanide"
	lore_text = "A highly toxic chemical."
	taste_mult = 0.6
	color = "#cf3600"
	strength = 20
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/material/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.sleeping += 1

/decl/material/toxin/heartstopper
	name = "heartstopper"
	lore_text = "A potent cardiotoxin that paralyzes the heart."
	taste_description = "intense bitterness"
	color = "#6b833b"
	strength = 16
	overdose = REAGENTS_OVERDOSE / 3
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/material/toxin/heartstopper/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.confused += 1.5

/decl/material/toxin/heartstopper/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/toxin/zombiepowder
	name = "zombie powder"
	lore_text = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	color = "#669900"
	metabolism = REM
	strength = 3
	target_organ = BP_BRAIN
	heating_message = "melts into a liquid slurry."
	heating_products = list(/decl/material/toxin/carpotoxin, /decl/material/sedatives, /decl/material/copper)

/decl/material/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	if(M.chem_doses[type] <= removed) //half-assed attempt to make timeofdeath update only at the onset
		M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/decl/material/toxin/zombiepowder/on_leaving_metabolism(mob/parent, metabolism_class)
	parent?.status_flags &= ~FAKEDEATH
	. = ..()

/decl/material/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	lore_text = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"
	heating_point = null
	heating_products = null
	hidden_from_codex = TRUE

/decl/material/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"

/decl/material/toxin/fertilizer/left4zed
	name = "Left-4-Zed"

/decl/material/toxin/fertilizer/robustharvest
	name = "Robust Harvest"

/decl/material/toxin/plantbgone
	name = "Plant-B-Gone"
	lore_text = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	color = "#49002e"
	strength = 4
	heating_products = list(/decl/material/toxin, /decl/material/water)

/decl/material/toxin/plantbgone/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message("<span class='notice'>The fungi are completely dissolved by the solution!</span>")

/decl/material/toxin/plantbgone/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/effect/vine))
		qdel(O)
		
/decl/material/toxin/tar
	name = "tar"
	lore_text = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	strength = 4
	heating_products = list(/decl/material/acetone, /decl/material/carbon, /decl/material/ethanol)
	heating_point = 145 CELSIUS
	heating_message = "separates"

/decl/material/toxin/hair_remover
	name = "hair remover"
	lore_text = "An extremely effective chemical depilator. Do not ingest."
	taste_description = "acid"
	color = "#d9ffb3"
	strength = 1
	overdose = REAGENTS_OVERDOSE
	heating_products = null
	heating_point = null

/decl/material/toxin/hair_remover/affect_touch(var/mob/M, var/alien, var/removed, var/datum/reagents/holder)
	M.lose_hair()
	holder.remove_reagent(type, REAGENT_VOLUME(holder, type))

/decl/material/toxin/zombie
	name = "liquid corruption"
	lore_text = "A filthy, oily substance which slowly churns of its own accord."
	taste_description = "decaying blood"
	color = "#800000"
	taste_mult = 5
	strength = 10
	metabolism = REM * 5
	overdose = 30
	hidden_from_codex = TRUE
	heating_products = null
	heating_point = null
	var/amount_to_zombify = 5

/decl/material/toxin/zombie/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed * 0.5, holder)

/decl/material/toxin/zombie/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/material/toxin/methyl_bromide
	name = "methyl bromide"
	lore_text = "A fumigant derived from bromide."
	taste_description = "pestkiller"
	color = "#4c3b34"
	strength = 5
	heating_products = null
	heating_point = null

/decl/material/toxin/methyl_bromide/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T))
		var/volume = REAGENT_VOLUME(holder, type)
		T.assume_gas(MAT_METHYL_BROMIDE, volume, T20C)
		holder.remove_reagent(type, volume)

/decl/material/toxin/methyl_bromide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(istype(M))
		for(var/obj/item/organ/external/E in M.organs)
			if(LAZYLEN(E.implants))
				for(var/obj/effect/spider/spider in E.implants)
					if(prob(25))
						E.implants -= spider
						M.visible_message("<span class='notice'>The dying form of \a [spider] emerges from inside \the [M]'s [E.name].</span>")
						qdel(spider)
						break

/decl/material/toxin/bromide
	name = "bromide"
	lore_text = "A dark, nearly opaque, red-orange, toxic element."
	taste_description = "pestkiller"
	color = "#4c3b34"
	strength = 3
	heating_products = null
	heating_point = null
