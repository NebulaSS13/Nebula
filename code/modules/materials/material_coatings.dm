/decl/material
	/// What word is used to describe an item covered in/stained by this by default?
	/// Can be overridden by get_coated_adjective().
	var/coated_adjective = "stained"

// TODO: Maybe make this use a strengths system like taste?
/// Returns a string to describe an item coated with this reagent (and others).
/// Receives the coating reagent holder as an argument, so coating.my_atom is accessible
/// and it can also conditionally use a different string for primary/non-primary materials, or
/// if another liquid is present, e.g. 'wet bloody muddy shoes'.
/decl/material/proc/get_coated_adjective(datum/reagents/coating)
	var/used_color = get_reagent_color(coating)
	if(get_config_value(/decl/config/enum/colored_coating_names) == CONFIG_COATING_COLOR_COMPONENTS)
		return FONT_COLORED(used_color, coated_adjective)
	return coated_adjective

/// Gets the name used to describe a coating with this material as its primary reagent.
/// This is mostly for handling special cases like mud.
/decl/material/proc/get_primary_coating_name(datum/reagents/coating)
	// this should probably respect current phase/solution/etc better, but coating sure doesn't
	return get_reagent_name(coating, phase_at_temperature())

/// Builds a string to describe a coating made up of this reagent (and others).
/// This reagent will never be the primary reagent, however; that's handled in get_primary_coating_name.
/// Receives the coating as an argument like get_coated_adjective, but also receives the accumulator list
/// for more complex behaviors like adding to the start. It can't reliably handle things like removing
/// another entry because ordering is not guaranteed, so beware if you need something like that.
/decl/material/proc/build_coated_name(datum/reagents/coating, list/accumulator)
	accumulator |= get_coated_adjective(coating)