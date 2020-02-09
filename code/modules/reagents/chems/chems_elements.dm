/datum/reagent/gold
	name = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "expensive metal"
	color = "#f7c430"
	value = 7

/datum/reagent/silver
	name = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "expensive yet reasonable metal"
	color = "#d0d0d0"
	value = 4

/datum/reagent/uranium
	name = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "the inside of a reactor"
	color = "#b8b8c0"
	value = 9

/datum/reagent/helium
	name = "helium"
	description = "A noble gas. It makes your voice squeaky."
	taste_description = "nothing"
	color = COLOR_GRAY80
	metabolism = 0.05

/datum/reagent/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SQUEAKY, 1)

/datum/reagent/oxygen
	name = "oxygen"
	description = "An ubiquitous oxidizing agent."
	taste_description = "nothing"
	color = COLOR_GRAY80


















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
			return