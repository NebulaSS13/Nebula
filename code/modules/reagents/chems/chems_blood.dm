/decl/material/liquid/blood
	name = "blood"
	lore_text = "A red (or blue) liquid commonly found inside animals, most of whom are pretty insistent about it being left where you found it."
	metabolism = REM * 5
	color = "#c80000"
	scannable = 1
	taste_description = "iron"
	taste_mult = 1.3
	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	value = 2.5
	opacity = 1
	min_fluid_opacity = FLUID_MAX_ALPHA

	chilling_products = list(
		/decl/material/liquid/coagulated_blood = 1
	)
	chilling_point = 249
	chilling_message = "coagulates and clumps together."

	heating_products = list(
		/decl/material/liquid/coagulated_blood = 1
	)
	heating_point = 318
	heating_message = "coagulates and clumps together."

/decl/material/liquid/blood/initialize_data(var/newdata)
	. = ..() || list()
	if(.)
		.["species"] = .["species"] || GLOB.using_map.default_species

/decl/material/liquid/blood/mix_data(var/datum/reagents/reagents, var/list/newdata, var/amount)	
	var/list/data = REAGENT_DATA(reagents, type)
	if(LAZYACCESS(newdata, "trace_chem"))
		var/list/other_chems = LAZYACCESS(newdata, "trace_chem")
		if(!data)
			data = newdata.Copy()
		else if(!data["trace_chem"])
			data["trace_chem"] = other_chems.Copy()
		else
			var/list/my_chems = data["trace_chem"]
			for(var/chem in other_chems)
				my_chems[chem] = my_chems[chem] + other_chems[chem]
	. = data

/decl/material/liquid/blood/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
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

/decl/material/liquid/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.HasTrait(/decl/trait/metabolically_inert))
		return

	if(M.chem_doses[type] > 5)
		M.adjustToxLoss(removed)
	if(M.chem_doses[type] > 15)
		M.adjustToxLoss(removed)

/decl/material/liquid/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			return

/decl/material/liquid/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.inject_blood(volume, holder)
	holder.remove_reagent(type, volume)

/decl/material/liquid/coagulated_blood
	name = "coagulated blood"
	color = "#aa0000"
	taste_description = "chewy iron"
	taste_mult = 1.5
	lore_text = "When exposed to unsuitable conditions, such as the floor or an oven, blood becomes coagulated and useless for transfusions. It's great for making blood pudding, though."
	glass_name = "tomato salsa"
	glass_desc = "Are you sure this is tomato salsa?"
	hidden_from_codex = TRUE
	toxicity = 4
	value = 0
