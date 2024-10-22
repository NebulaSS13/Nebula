/mob/proc/get_flesh_color()
	return get_species()?.get_species_flesh_color(src) || COLOR_GRAY

/mob/proc/get_gibber_type()
	return null

/mob/proc/get_blood_color()
	return get_species()?.get_species_blood_color(src) || COLOR_BLOOD_HUMAN

/mob/proc/get_blood_oxy()
	var/decl/species/my_species = get_species()
	return my_species ? my_species.blood_oxy : TRUE

/mob/proc/get_blood_name()
	return "blood"

/mob/living/silicon/get_blood_name()
	return "oil"

/mob/living/human/get_blood_name()
	if(species)
		return species.get_blood_name(src)
	return "blood"

//Gets blood from mob to the container, preserving all data in it.
/mob/proc/take_blood(obj/item/chems/container, var/amount)
	var/decl/species/my_species = get_species()
	if(my_species?.blood_reagent)
		container.add_to_reagents(my_species.blood_reagent, amount, get_blood_data())
		return TRUE
	return FALSE

/mob/proc/get_blood_data()
	var/data = list()
	data[DATA_BLOOD_DONOR] = weakref(src)
	return data

/// Removes amt units of blood from src, if it has blood.
/// If absolute is FALSE, rescale amt according to mob size.
/// Returns the amount of blood removed.
/mob/proc/remove_blood(amt, absolute = FALSE)
	return 0