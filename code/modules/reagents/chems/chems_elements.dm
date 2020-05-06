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
