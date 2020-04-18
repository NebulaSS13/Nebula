/datum/reagent/gold
	name = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "expensive metal"
	color = "#f7c430"
	value = 1.5

/datum/reagent/silver
	name = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "expensive yet reasonable metal"
	color = "#d0d0d0"

/datum/reagent/uranium
	name = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "the inside of a reactor"
	color = "#b8b8c0"

/datum/reagent/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_ingest(M, alien, removed)

/datum/reagent/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_damage(5 * removed, IRRADIATE, armor_pen = 100)

/datum/reagent/uranium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/helium
	name = "helium"
	description = "A noble gas. It makes your voice squeaky."
	taste_description = "nothing"
	color = COLOR_GRAY80
	metabolism = 0.05

/datum/reagent/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/datum/reagent/aluminium
	name = "aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile member of the boron group of chemical elements."
	color = "#a8a8a8"
	value = 0.5

/datum/reagent/ammonia
	name = "ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	color = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = 0.5

/datum/reagent/carbon
	name = "carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	color = "#1c1300"
	value = 0.5

/datum/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && ingested.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R == src)
				continue
			ingested.remove_reagent(R.type, removed * effect)

/datum/reagent/carbon/touch_turf(var/turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/copper
	name = "copper"
	description = "A highly ductile metal."
	taste_description = "copper"
	color = "#6e3b08"
	value = 0.5

/datum/reagent/iron
	name = "iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	color = "#353535"
	value = 0.5

/datum/reagent/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	color = "#808080"
	value = 0.5

/datum/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M.loc, /turf/space))
		M.SelfMove(pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	color = "#484848"
	value = 0.5

/datum/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M.loc, /turf/space))
		M.SelfMove(pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(0.1)

/datum/reagent/phosphorus
	name = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	color = "#832828"
	value = 0.5

/datum/reagent/potassium
	name = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	value = 0.5

/datum/reagent/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/radium
	name = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	color = "#c7c7c7"
	value = 0.5

/datum/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_damage(10 * removed, IRRADIATE, armor_pen = 100) // Radium may increase your chances to cure a disease

/datum/reagent/radium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/silicon
	name = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	color = "#a8a8a8"
	value = 0.5

/datum/reagent/sodium
	name = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	color = "#808080"
	value = 0.5

/datum/reagent/sulfur
	name = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	color = "#bf8c00"
	value = 0.5

/datum/reagent/tungsten
	name = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	color = "#dcdcdc"
	value = 0.5
