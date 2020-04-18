/datum/reagent/blood
	data = new/list(
		"donor" = null,
		"species" = null,
		"blood_DNA" = null,
		"blood_type" = null,
		"blood_colour" = COLOR_BLOOD_HUMAN,
		"trace_chem" = null,
		"dose_chem" = null,
		"has_oxy" = 1
	)
	name = "Blood"
	description = "A red (or blue) liquid commonly found inside animals, most of whom are pretty insistent about it being left where you found it."
	metabolism = REM * 5
	color = "#c80000"
	scannable = 1
	taste_description = "iron"
	taste_mult = 1.3
	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	value = 2.5

	chilling_products = list(/datum/reagent/coagulated_blood)
	chilling_point = 249
	chilling_message = "coagulates and clumps together."

	heating_products = list(/datum/reagent/coagulated_blood)
	heating_point = 318
	heating_message = "coagulates and clumps together."

/datum/reagent/blood/initialize_data(var/newdata)
	..()
	if(data)
		if(isnull(data["species"]))
			data["species"] = GLOB.using_map.default_species
		if(data["blood_colour"])
			color = data["blood_colour"]
	return

/datum/reagent/blood/proc/sync_to(var/mob/living/carbon/C)
	data = C.get_blood_data()
	color = data["blood_colour"]

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	return t

/datum/reagent/blood/touch_turf(var/turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	var/weakref/W = data["donor"]
	if (!W)
		blood_splatter(T, src, 1)
		return
	W = W.resolve()
	if(ishuman(W))
		blood_splatter(T, src, 1)
	else if(isalien(W))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	if(M.chem_doses[type] > 5)
		M.adjustToxLoss(removed)
	if(M.chem_doses[type] > 15)
		M.adjustToxLoss(removed)

/datum/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return

/datum/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.inject_blood(src, volume)
	remove_self(volume)

/datum/reagent/coagulated_blood
	name = "coagulated blood"
	color = "#aa0000"
	taste_description = "chewy iron"
	taste_mult = 1.5
	description = "When exposed to unsuitable conditions, such as the floor or an oven, blood becomes coagulated and useless for transfusions. It's great for making blood pudding, though."
	glass_name = "tomato salsa"
	glass_desc = "Are you sure this is tomato salsa?"
	hidden_from_codex = TRUE
	value = 0