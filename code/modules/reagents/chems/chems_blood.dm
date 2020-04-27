/decl/reagent/blood
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

	chilling_products = list(/decl/reagent/coagulated_blood)
	chilling_point = 249
	chilling_message = "coagulates and clumps together."

	heating_products = list(/decl/reagent/coagulated_blood)
	heating_point = 318
	heating_message = "coagulates and clumps together."

/decl/reagent/blood/initialize_data(var/newdata)
	. = ..() || list()
	if(.)
		.["species"] = .["species"] || GLOB.using_map.default_species

/decl/reagent/blood/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	var/data = REAGENT_DATA(holder, type)
	if(!istype(T) || REAGENT_VOLUME(holder, type) < 3)
		return
	var/weakref/W = LAZYACCESS(data, "donor")
	if (!W)
		blood_splatter(T, src, 1)
		return
	W = W.resolve()
	if(ishuman(W))
		blood_splatter(T, src, 1)
	else if(isalien(W))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, holder.my_atom, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/decl/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)

	if(M.chem_doses[type] > 5)
		M.adjustToxLoss(removed)
	if(M.chem_doses[type] > 15)
		M.adjustToxLoss(removed)

/decl/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return

/decl/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.inject_blood(volume, holder)
	holder.remove_reagent(type, volume)

/decl/reagent/coagulated_blood
	name = "coagulated blood"
	color = "#aa0000"
	taste_description = "chewy iron"
	taste_mult = 1.5
	description = "When exposed to unsuitable conditions, such as the floor or an oven, blood becomes coagulated and useless for transfusions. It's great for making blood pudding, though."
	glass_name = "tomato salsa"
	glass_desc = "Are you sure this is tomato salsa?"
	hidden_from_codex = TRUE
	value = 0