/mob/proc/get_flesh_color()
	return get_species()?.get_species_flesh_color(src) || COLOR_GRAY

/mob/proc/get_gibber_type()
	return null

/mob/proc/get_blood_color()
	return get_species()?.get_species_blood_color(src) || COLOR_BLOOD_HUMAN

/mob/proc/get_blood_oxy()
	var/decl/species/my_species = get_species()
	return my_species ? my_species.blood_oxy : TRUE

//Gets blood from mob to the container, preserving all data in it.
/mob/proc/take_blood(obj/item/chems/container, var/amount)
	var/decl/species/my_species = get_species()
	if(my_species?.blood_reagent)
		container.add_to_reagents(my_species.blood_reagent, amount, get_blood_data())
		return TRUE
	return FALSE

/mob/proc/get_blood_data()
	var/data = list()
	data["donor"] = weakref(src)
	return data
