//Gets blood from mob to the container, preserving all data in it.
/mob/living/proc/take_blood(obj/item/chems/container, var/amount)
	var/decl/species/my_species = get_species()
	if(my_species)
		container.reagents.add_reagent(my_species.blood_reagent, amount, get_blood_data())
	return TRUE

//Transfers blood from container ot vessels
/mob/living/proc/inject_blood(var/amount, var/datum/reagents/donor)
	var/decl/species/my_species = get_species()
	if(!my_species?.blood_volume)
		return //Don't divide by 0
	var/injected_data = REAGENT_DATA(donor, my_species.blood_reagent)
	var/chems = LAZYACCESS(injected_data, "trace_chem")
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / my_species.blood_volume) * amount)//adds trace chemicals to owner's blood

/mob/living/proc/get_blood_data()
	. = list()

	.["donor"] = weakref(src)
	if(dna)
		.["blood_DNA"] =  dna.unique_enzymes
		.["blood_type"] = dna.b_type

	var/decl/species/my_species = get_species()
	if(my_species)
		.["species"] =     my_species.name
		.["blood_color"] = my_species.get_blood_color(src)
		.["has_oxy"] =     my_species.blood_oxy

	var/list/temp_chem = list()
	for(var/R in reagents.reagent_volumes)
		temp_chem[R] = REAGENT_VOLUME(reagents, R)

	.["trace_chem"] = temp_chem
	.["dose_chem"] =  chem_doses ? chem_doses.Copy() : list()
