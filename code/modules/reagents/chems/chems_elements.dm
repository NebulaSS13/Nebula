/decl/material/gold
	name = "gold"
	lore_text = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "expensive metal"
	icon_colour = "#f7c430"
	value = 1.5

/decl/material/silver
	name = "silver"
	lore_text = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "expensive yet reasonable metal"
	icon_colour = "#d0d0d0"

/decl/material/uranium
	name = "uranium"
	lore_text = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "the inside of a reactor"
	icon_colour = "#b8b8c0"

/decl/material/uranium/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed, holder)

/decl/material/uranium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_damage(5 * removed, IRRADIATE, armor_pen = 100)

/decl/material/uranium/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/decl/material/helium
	name = "helium"
	lore_text = "A noble gas. It makes your voice squeaky."
	taste_description = "nothing"
	icon_colour = COLOR_GRAY80
	metabolism = 0.05

/decl/material/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/decl/material/aluminium
	name = "aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	lore_text = "A silvery white and ductile member of the boron group of chemical elements."
	icon_colour = "#a8a8a8"
	value = 0.5

/decl/material/ammonia
	name = "ammonia"
	taste_description = "mordant"
	taste_mult = 2
	lore_text = "A caustic substance commonly used in fertilizer or household cleaners."
	icon_colour = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = 0.5

/decl/material/carbon
	name = "carbon"
	lore_text = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	icon_colour = "#1c1300"
	value = 0.5

/decl/material/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/carbon/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T, /turf/space))
		var/volume = REAGENT_VOLUME(holder, src)
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/decl/material/copper
	name = "copper"
	lore_text = "A highly ductile metal."
	taste_description = "copper"
	icon_colour = "#6e3b08"
	value = 0.5

/decl/material/iron
	name = "iron"
	lore_text = "Pure iron is a metal."
	taste_description = "metal"
	icon_colour = "#353535"
	value = 0.5

/decl/material/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/decl/material/lithium
	name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	taste_description = "metal"
	icon_colour = "#808080"
	value = 0.5

/decl/material/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M.loc, /turf/space))
		M.SelfMove(pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/decl/material/mercury
	name = "mercury"
	lore_text = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	icon_colour = "#484848"
	value = 0.5

/decl/material/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M.loc, /turf/space))
		M.SelfMove(pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(0.1)

/decl/material/phosphorus
	name = "phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	icon_colour = "#832828"
	value = 0.5

/decl/material/potassium
	name = "potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	icon_colour = "#a0a0a0"
	value = 0.5

/decl/material/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/material/radium
	name = "radium"
	lore_text = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	icon_colour = "#c7c7c7"
	value = 0.5

/decl/material/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_damage(10 * removed, IRRADIATE, armor_pen = 100) // Radium may increase your chances to cure a disease

/decl/material/radium/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/decl/material/silicon
	name = "silicon"
	lore_text = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	icon_colour = "#a8a8a8"
	value = 0.5

/decl/material/sodium
	name = "sodium"
	lore_text = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	icon_colour = "#808080"
	value = 0.5

/decl/material/sulfur
	name = "sulfur"
	lore_text = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	icon_colour = "#bf8c00"
	value = 0.5

/decl/material/tungsten
	name = "tungsten"
	lore_text = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	icon_colour = "#dcdcdc"
	value = 0.5
