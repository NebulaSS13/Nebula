/decl/material/liquid/blood
	name = "blood"
	codex_name = "whole blood"
	uid = "chem_blood"
	lore_text = "A red (or blue) liquid commonly found inside animals, most of whom are pretty insistent about it being left where you found it."
	metabolism = REM * 5
	color = "#c80000"
	scannable = 1
	taste_description = "iron"
	taste_mult = 1.3
	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	value = 2.5
	opacity = TRUE
	min_fluid_opacity = FLUID_MAX_ALPHA
	max_fluid_opacity = 240
	compost_value = 1 // yum

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
	affect_blood_on_ingest = FALSE

/decl/material/liquid/blood/initialize_data(list/newdata)
	. = ..() || list()
	.[DATA_BLOOD_SPECIES] ||= global.using_map.default_species

/decl/material/liquid/blood/mix_data(var/datum/reagents/reagents, var/list/newdata, var/amount)
	. = ..()
	if(LAZYACCESS(newdata, DATA_BLOOD_TRACE_CHEM))
		var/list/other_chems = LAZYACCESS(newdata, DATA_BLOOD_TRACE_CHEM)
		if(!.)
			. = newdata.Copy()
		else if(!.[DATA_BLOOD_TRACE_CHEM])
			.[DATA_BLOOD_TRACE_CHEM] = other_chems.Copy()
		else
			var/list/my_chems = .[DATA_BLOOD_TRACE_CHEM]
			for(var/chem in other_chems)
				my_chems[chem] = my_chems[chem] + other_chems[chem]

/decl/material/liquid/blood/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	var/data = REAGENT_DATA(holder, type)
	if(!istype(T) || REAGENT_VOLUME(holder, type) < 3)
		return
	var/weakref/W = LAZYACCESS(data, DATA_BLOOD_DONOR)
	blood_splatter(T, W?.resolve() || holder.my_atom, 1)

/decl/material/liquid/blood/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	if(M.has_trait(/decl/trait/metabolically_inert))
		return
	if(LAZYACCESS(M.chem_doses, type) > 5)
		M.take_damage(removed, TOX)
	if(LAZYACCESS(M.chem_doses, type) > 15)
		M.take_damage(removed, TOX)

/decl/material/liquid/blood/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/volume = REAGENT_VOLUME(holder, type)
		var/mob/living/human/H = M
		H.inject_blood(volume, holder)
		holder.remove_reagent(type, volume)
	. = ..()

/decl/material/liquid/blood/get_reagent_color(datum/reagents/holder)
	var/list/blood_data = REAGENT_DATA(holder, type)
	return blood_data?["blood_color"] || ..()

/decl/material/liquid/coagulated_blood
	name = "coagulated blood"
	color = "#aa0000"
	uid = "chem_blood_coagulated"
	taste_description = "chewy iron"
	taste_mult = 1.5
	lore_text = "When exposed to unsuitable conditions, such as the floor or an oven, blood becomes coagulated and useless for transfusions. It's great for making blood pudding, though."
	glass_name = "tomato salsa"
	glass_desc = "Are you sure this is tomato salsa?"
	hidden_from_codex = TRUE
	toxicity = 4
	value = 0
	exoplanet_rarity_gas = MAT_RARITY_UNCOMMON
	compost_value = 1 // yum
