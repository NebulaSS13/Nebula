//Transfers blood from container to vessels
/mob/living/proc/inject_blood(var/amount, var/datum/reagents/donor)
	var/decl/species/my_species = get_species()
	if(!my_species?.blood_volume)
		return //Don't divide by 0
	var/injected_data = REAGENT_DATA(donor, my_species.blood_reagent)
	var/chems = LAZYACCESS(injected_data, DATA_BLOOD_TRACE_CHEM)
	for(var/C in chems)
		add_to_reagents(C, (text2num(chems[C]) / my_species.blood_volume) * amount)//adds trace chemicals to owner's blood

/mob/living/get_blood_data()

	var/data = ..()
	data[DATA_BLOOD_DNA]  = get_unique_enzymes()
	data[DATA_BLOOD_TYPE] = get_blood_type()
	var/species_name = get_species_name()
	if(species_name)
		data[DATA_BLOOD_SPECIES] = species_name

	var/list/temp_chem = list()
	for(var/R in reagents?.reagent_volumes)
		temp_chem[R] = REAGENT_VOLUME(reagents, R)
	data[DATA_BLOOD_TRACE_CHEM]  = temp_chem
	data[DATA_BLOOD_DOSE_CHEM]   = chem_doses?.Copy() || list()

	if(isSynthetic())
		data[DATA_BLOOD_HAS_OXY] = FALSE
		data[DATA_BLOOD_COLOR]   = SYNTH_BLOOD_COLOR
	else
		data[DATA_BLOOD_HAS_OXY] = get_blood_oxy()
		data[DATA_BLOOD_COLOR]   = get_blood_color()
	return data

/mob/living/proc/is_blood_incompatible(their_blood_type)
	var/decl/blood_type/my_blood = get_blood_type_by_name(get_blood_type())
	return !istype(my_blood) || !my_blood.can_take_donation_from(get_blood_type_by_name(their_blood_type))

/mob/living/get_gibber_type()
	if(mob_size <= MOB_SIZE_TINY)
		return isSynthetic() ? /obj/effect/decal/cleanable/blood/gibs/robot : /obj/effect/decal/cleanable/blood/gibs
	return isSynthetic() ? /obj/effect/gibspawner/robot : /obj/effect/gibspawner/generic
