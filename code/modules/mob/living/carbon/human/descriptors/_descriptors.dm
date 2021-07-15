/*

	Small, mechanically supported physical customisation options.
	Also allows for per-species physical information ('his neck markings are more important than yours').
	ETA till a downstream ports this and adds boob and penis size: 2 days. UPDATE: still no penis sizes

	Descriptors are stored in species/human lists (appearance_descriptors) as a string key (name) indexed 
	to a value (either a personalized value or the shared datum on the species). The general pattern for
	looking up descriptor data is to iterate the species.appearance_descriptors list for the datum instances
	and then check human.appearance_descriptors for the specific value the mob is using.

	This code is really noodly and can be tricky to follow in places. This is due to two different systems
	of value comparison being used, one linear (height/build) and one with arbitrary values (age).

*/

/mob/living/carbon/human/proc/show_descriptors_to(var/mob/user)
	if(LAZYLEN(appearance_descriptors))
		if(user == src)
			for(var/entry in appearance_descriptors)
				var/datum/appearance_descriptor/descriptor = species.appearance_descriptors[entry]
				LAZYADD(., "[descriptor.get_first_person_message_start()] [descriptor.get_standalone_value_descriptor(appearance_descriptors[descriptor.name])].")
		else
			for(var/entry in appearance_descriptors)
				var/datum/appearance_descriptor/descriptor = species.appearance_descriptors[entry]
				LAZYADD(., descriptor.get_comparative_value_descriptor(appearance_descriptors[descriptor.name], user, src))

/datum/appearance_descriptor
	var/name                                       // String ident. Used to collect related datums into one category (ie. species overrides) and for saving.
	var/chargen_label                              // String ident for chargen.
	var/default_value                              // Initial value for this descriptor.
	var/relative_value_comparison_multiplier = 1   // Used for examining similar properties between different species.
	var/comparative_value_descriptor_equivalent    // String for looking at someone with roughly the same property.
	var/list/standalone_value_descriptors          // String set for initial descriptor text.
	var/list/comparative_value_descriptors_smaller // String set for looking at someone smaller than you.
	var/list/comparative_value_descriptors_larger  // String set for looking at someone larger than you.
	var/list/chargen_value_descriptors             // Used for chargen selection of values in cases where there is a hidden meaning.
	var/chargen_min_index                          // Min value selectable in chargen. Defaults to 1.
	var/chargen_max_index                          // Max value selectable in chargen. Defaults to size of descriptor list.
	var/skip_species_mention                       // Set to true to ignore species descriptors when examining another species.
	var/equivalent_variance_threshold = 0.1        // Variance % below this value will be treated as equivalent when examining another mob.
	var/comparison_variance_multiplier = 0.75      // A multiplier applied to variance values to tighten them in a bit and allow for major cross-species variations to have more significant strings.

/datum/appearance_descriptor/New(var/comparison_val = 1)
	if(!isnull(comparison_val))
		relative_value_comparison_multiplier = comparison_val
	if(!chargen_label)
		chargen_label = name
	if(!chargen_value_descriptors)
		chargen_value_descriptors = list()
		for(var/i = 1 to LAZYLEN(standalone_value_descriptors))
			chargen_value_descriptors[standalone_value_descriptors[i]] = i
	if(isnull(chargen_min_index))
		chargen_min_index = 1
	if(isnull(chargen_max_index))
		chargen_max_index = LAZYLEN(standalone_value_descriptors)
	set_default_value()
	..(null)

/datum/appearance_descriptor/proc/set_default_value()
	default_value = CEILING(LAZYLEN(standalone_value_descriptors) * 0.5)

/datum/appearance_descriptor/proc/get_mob_scale_adjustments(var/offset_value)
	return

/datum/appearance_descriptor/proc/get_mob_overlay(var/mob/applying, var/offset_value)
	return

/datum/appearance_descriptor/proc/get_third_person_message_start(var/decl/pronouns/my_gender)
	return "[my_gender.He] [my_gender.is]"

/datum/appearance_descriptor/proc/get_first_person_message_start()
	return "You are"

/datum/appearance_descriptor/proc/get_standalone_value_descriptor(var/check_value)
	if(isnull(check_value))
		check_value = default_value
	else
		check_value = get_index_from_value(check_value)
	if(check_value && LAZYLEN(standalone_value_descriptors) >= check_value)
		return standalone_value_descriptors[check_value]

// Build a species-specific descriptor string.
/datum/appearance_descriptor/proc/get_species_text(var/use_name)
	. = " for \a [use_name]"

/datum/appearance_descriptor/proc/get_initial_comparison_component(var/mob/me, var/mob/them, var/decl/pronouns/my_gender, var/decl/pronouns/other_gender, var/my_value)
	if(!skip_species_mention)
		var/mob/living/carbon/human/H = me
		var/mob/living/carbon/human/O = them
		if(istype(H) && (!istype(O) || H.species.name != O.species.name))
			. = get_species_text("\improper [H.species.name]")
	. = "[get_third_person_message_start(my_gender)] [get_standalone_value_descriptor(my_value)][.]"

/datum/appearance_descriptor/proc/get_secondary_comparison_component(var/decl/pronouns/my_gender, var/decl/pronouns/other_gender, var/my_value, var/comparing_value)
	var/variance = abs(1-(my_value/comparing_value)) * comparison_variance_multiplier
	if(variance < equivalent_variance_threshold)
		. = "[.], [get_comparative_value_string_equivalent(my_gender, other_gender)]"
	else
		if(my_value < comparing_value)
			. = "[.], [get_comparative_value_string_smaller(variance, my_gender, other_gender)]"
		else if(my_value > comparing_value)
			. = "[.], [get_comparative_value_string_larger(variance, my_gender, other_gender)]"

/datum/appearance_descriptor/proc/get_comparative_value_descriptor(var/my_value, var/mob/observer, var/mob/me)

	// Store our gender info for later.
	var/decl/pronouns/my_gender = me.get_pronouns()
	var/decl/pronouns/other_gender = observer.get_pronouns()

	. = get_initial_comparison_component(me, observer, my_gender, other_gender, my_value)

	// Append the same-descriptor comparison text.
	var/comparing_value
	if(ishuman(observer))
		var/mob/living/carbon/human/human_observer = observer
		if(LAZYLEN(human_observer.appearance_descriptors) && !isnull(human_observer.species.appearance_descriptors[name]) && !isnull(human_observer.appearance_descriptors[name]))
			var/datum/appearance_descriptor/obs_descriptor = human_observer.species.appearance_descriptors[name]
			comparing_value = human_observer.appearance_descriptors[name] * obs_descriptor.relative_value_comparison_multiplier

	if(. && !isnull(comparing_value))
		. = "[.][get_secondary_comparison_component(my_gender, other_gender, my_value * relative_value_comparison_multiplier, comparing_value)]"

	// We're done, add a full stop.
	. = "[.]. "

/datum/appearance_descriptor/proc/get_index_from_value(var/value)
	return value

/datum/appearance_descriptor/proc/get_comparative_value_string_equivalent(var/decl/pronouns/my_gender, var/decl/pronouns/other_gender)
	return comparative_value_descriptor_equivalent

/datum/appearance_descriptor/proc/get_comparative_value_string_smaller(var/value, var/decl/pronouns/my_gender, var/decl/pronouns/other_gender)
	var/maxval = LAZYLEN(comparative_value_descriptors_smaller)
	value = Clamp(CEILING(value * maxval), 1, maxval)
	return comparative_value_descriptors_smaller[value]

/datum/appearance_descriptor/proc/get_comparative_value_string_larger(var/value, var/decl/pronouns/my_gender, var/decl/pronouns/other_gender)
	var/maxval = LAZYLEN(comparative_value_descriptors_larger)
	value = Clamp(CEILING(value * maxval), 1, maxval)
	return comparative_value_descriptors_larger[value]

/datum/appearance_descriptor/proc/has_custom_value()
	return FALSE

/datum/appearance_descriptor/proc/randomize_value(var/limit_chargen = TRUE)
	if(limit_chargen)
		return rand(chargen_min_index, chargen_max_index)
	return rand(1, LAZYLEN(standalone_value_descriptors))

/datum/appearance_descriptor/proc/get_value_from_index(var/value, var/chargen_bound = TRUE)
	if(chargen_bound)
		return Clamp(round(value), chargen_min_index, chargen_max_index)
	return Clamp(round(value), 1, LAZYLEN(standalone_value_descriptors))
	
/datum/appearance_descriptor/proc/sanitize_value(var/value, var/chargen_bound = TRUE)
	if(chargen_bound)
		return Clamp(round(value), get_min_chargen_value(), get_max_chargen_value())
	return Clamp(round(value), 1, LAZYLEN(standalone_value_descriptors))

/datum/appearance_descriptor/proc/get_value_text(var/value)
	. = "[value || "0"]"

/datum/appearance_descriptor/proc/get_min_chargen_value()
	return chargen_min_index
	
/datum/appearance_descriptor/proc/get_max_chargen_value()
	return chargen_max_index
