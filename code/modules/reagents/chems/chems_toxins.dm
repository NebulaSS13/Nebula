/decl/reagent/toxin
	name = "toxin"
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	color = "#cf3600"
	metabolism = REM * 0.25 // 0.05 by default. They last a while and slowly kill you.
	heating_products = list(/decl/reagent/toxin/denatured)
	heating_point = 100 CELSIUS
	heating_message = "goes clear."
	value = 1.5

	var/target_organ
	var/strength = 4 // How much damage it deals per unit

/decl/reagent/toxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/reagent/toxin/denatured
	name = "denatured toxin"
	description = "Once toxic, now harmless."
	taste_description = null
	taste_mult = null
	color = "#808080"
	metabolism = REM
	heating_products = null
	heating_point = null
	target_organ = null
	strength = 0
	hidden_from_codex = TRUE

/decl/reagent/toxin/slimejelly
	name = "slime jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	taste_description = "slime"
	taste_mult = 1.3
	color = "#801e28"
	strength = 10

/decl/reagent/toxin/plasticide
	name = "plasticide"
	description = "Liquid plastic, do not eat."
	taste_description = "plastic"
	color = "#cf3600"
	strength = 5
	heating_point = null
	heating_products = null

/decl/reagent/toxin/amatoxin
	name = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#792300"
	strength = 10

/decl/reagent/toxin/carpotoxin
	name = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	color = "#003333"
	target_organ = BP_BRAIN
	strength = 10

/decl/reagent/toxin/venom
	name = "spider venom"
	description = "A deadly necrotic toxin produced by giant spiders to disable their prey."
	taste_description = "absolutely vile"
	color = "#91d895"
	target_organ = BP_LIVER
	strength = 5

/decl/reagent/toxin/venom/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(REAGENT_VOLUME(holder, type)*2))
		M.confused = max(M.confused, 3)
	..()

/decl/reagent/toxin/chlorine
	name = "chlorine"
	description = "A highly poisonous liquid. Smells strongly of bleach."
	taste_description = "bleach"
	color = "#707c13"
	strength = 15
	metabolism = REM
	heating_point = null
	heating_products = null

/decl/reagent/toxin/phoron
	name = "phoron"
	description = "Phoron in its liquid form."
	taste_mult = 1.5
	color = "#ff3300"
	strength = 30
	touch_met = 5
	heating_point = null
	heating_products = null
	value = 4
	fuel_value = 2

/decl/reagent/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fuel_value))
		M.handle_contaminants()

/decl/reagent/toxin/phoron/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_PHORON, volume, T20C)
	holder.remove_reagent(type, volume)

// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/decl/reagent/toxin/phoron/oxygen
	name = "oxyphoron"
	description = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 15
	fuel_value = 2.5

/decl/reagent/toxin/phoron/oxygen/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	var/volume = REAGENT_VOLUME(holder, type)
	T.assume_gas(MAT_OXYGEN, ceil(volume/2), T20C)
	T.assume_gas(MAT_PHORON, ceil(volume/2), T20C)
	holder.remove_reagent(type, volume)

/decl/reagent/toxin/cyanide //Fast and Lethal
	name = "cyanide"
	description = "A highly toxic chemical."
	taste_mult = 0.6
	color = "#cf3600"
	strength = 20
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/reagent/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.sleeping += 1

/decl/reagent/toxin/heartstopper
	name = "heartstopper"
	description = "A potent cardiotoxin that paralyzes the heart."
	taste_description = "intense bitterness"
	color = "#6b833b"
	strength = 16
	overdose = REAGENTS_OVERDOSE / 3
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/decl/reagent/toxin/heartstopper/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.confused += 1.5

/decl/reagent/toxin/heartstopper/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/decl/reagent/toxin/zombiepowder
	name = "zombie powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	color = "#669900"
	metabolism = REM
	strength = 3
	target_organ = BP_BRAIN
	heating_message = "melts into a liquid slurry."
	heating_products = list(/decl/reagent/toxin/carpotoxin, /decl/reagent/sedatives, /decl/reagent/copper)

/decl/reagent/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	if(M.chem_doses[type] <= removed) //half-assed attempt to make timeofdeath update only at the onset
		M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/decl/reagent/toxin/zombiepowder/on_leaving_metabolism(mob/parent, metabolism_class)
	parent?.status_flags &= ~FAKEDEATH
	. = ..()

/decl/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"
	heating_point = null
	heating_products = null
	hidden_from_codex = TRUE

/decl/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"

/decl/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"

/decl/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"

/decl/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	color = "#49002e"
	strength = 4
	heating_products = list(/decl/reagent/toxin, /decl/reagent/water)

/decl/reagent/toxin/plantbgone/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message("<span class='notice'>The fungi are completely dissolved by the solution!</span>")

/decl/reagent/toxin/plantbgone/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/effect/vine))
		qdel(O)
		
/decl/reagent/toxin/tar
	name = "tar"
	description = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	strength = 4
	heating_products = list(/decl/reagent/acetone, /decl/reagent/carbon, /decl/reagent/ethanol)
	heating_point = 145 CELSIUS
	heating_message = "separates"

/decl/reagent/toxin/hair_remover
	name = "hair remover"
	description = "An extremely effective chemical depilator. Do not ingest."
	taste_description = "acid"
	color = "#d9ffb3"
	strength = 1
	overdose = REAGENTS_OVERDOSE
	heating_products = null
	heating_point = null

/decl/reagent/toxin/hair_remover/affect_touch(var/mob/M, var/alien, var/removed, var/datum/reagents/holder)
	M.lose_hair()
	holder.remove_reagent(type, REAGENT_VOLUME(holder, type))

/decl/reagent/toxin/zombie
	name = "liquid corruption"
	description = "A filthy, oily substance which slowly churns of its own accord."
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

/decl/reagent/toxin/zombie/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed * 0.5, holder)

/decl/reagent/toxin/zombie/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/reagent/toxin/methyl_bromide
	name = "methyl bromide"
	description = "A fumigant derived from bromide."
	taste_description = "pestkiller"
	color = "#4c3b34"
	strength = 5
	heating_products = null
	heating_point = null

/decl/reagent/toxin/methyl_bromide/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T))
		var/volume = REAGENT_VOLUME(holder, type)
		T.assume_gas(MAT_METHYL_BROMIDE, volume, T20C)
		holder.remove_reagent(type, volume)

/decl/reagent/toxin/methyl_bromide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/reagent/toxin/bromide
	name = "bromide"
	description = "A dark, nearly opaque, red-orange, toxic element."
	taste_description = "pestkiller"
	color = "#4c3b34"
	strength = 3
	heating_products = null
	heating_point = null
