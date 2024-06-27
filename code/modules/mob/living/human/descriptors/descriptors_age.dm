/datum/appearance_descriptor/age
	name = "age"
	standalone_value_descriptors = list(
		"an infant" =      1,
		"a toddler" =      3,
		"a child" =        7,
		"a teenager" =    13,
		"a young adult" = 17,
		"an adult" =      25,
		"middle-aged" =   40,
		"aging" =         55,
		"elderly" =       70
	)

	chargen_min_index = 5
	chargen_max_index = 8
	comparative_value_descriptor_equivalent = "around the same age as you"
	comparative_value_descriptors_smaller = list(
		"somewhat younger than you",
		"younger than you",
		"much younger than you",
		"a child compared to you"
	)
	comparative_value_descriptors_larger = list(
		"slightly older than you",
		"older  than you",
		"much older than you",
		"ancient compared to you"
	)

/datum/appearance_descriptor/age/get_value_text(var/value)
	. = "[value] year\s"

/datum/appearance_descriptor/age/get_species_text(var/use_name)
	. = " in [use_name] terms"

/datum/appearance_descriptor/age/has_custom_value()
	return TRUE

/datum/appearance_descriptor/age/get_value_from_index(var/value, var/chargen_bound = TRUE)
	var/age_key = standalone_value_descriptors[..()]
	. = standalone_value_descriptors[age_key]

/datum/appearance_descriptor/age/get_index_from_value(var/value)
	for(var/i = 2 to length(standalone_value_descriptors))
		var/age_key = standalone_value_descriptors[i]
		if(value < standalone_value_descriptors[age_key])
			return i-1
	return length(standalone_value_descriptors)

/datum/appearance_descriptor/age/set_default_value()
	default_value = standalone_value_descriptors[standalone_value_descriptors[chargen_min_index]]

/datum/appearance_descriptor/age/sanitize_value(var/value, var/chargen_bound = TRUE)
	if(!chargen_bound)
		return clamp(round(value), standalone_value_descriptors[standalone_value_descriptors[1]], standalone_value_descriptors[standalone_value_descriptors[length(standalone_value_descriptors)]])
	return ..()

/datum/appearance_descriptor/age/get_min_chargen_value()
	var/age_key = standalone_value_descriptors[chargen_min_index]
	return standalone_value_descriptors[age_key]

/datum/appearance_descriptor/age/get_max_chargen_value()
	var/age_key = standalone_value_descriptors[min(length(standalone_value_descriptors), chargen_max_index+1)]
	. = standalone_value_descriptors[age_key]-1
