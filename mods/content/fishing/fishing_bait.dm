// Returns a value used as a multiplier in the fishing delay calc. Higher represents a stronger reduction in fishing time.
#define BAIT_VALUE_CONSTANT 0.1
/obj/item/proc/get_bait_value()
	. = 0
	for(var/mat in matter)
		var/decl/material/bait_mat = GET_DECL(mat)
		if(bait_mat.fishing_bait_value)
			. += MATERIAL_UNITS_TO_REAGENTS_UNITS(matter[mat]) * bait_mat.fishing_bait_value * BAIT_VALUE_CONSTANT
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
		if(reagent.fishing_bait_value)
			. += REAGENT_VOLUME(reagents, reagent) * reagent.fishing_bait_value * BAIT_VALUE_CONSTANT
#undef BAIT_VALUE_CONSTANT

/decl/material
	/// A multiplier for this material when used in fishing bait.
	var/fishing_bait_value = 0

/decl/material/solid/organic/meat
	fishing_bait_value = 1

/decl/material/solid/organic/plantmatter
	fishing_bait_value = 0.75

/decl/material/liquid/nutriment
	fishing_bait_value = 0.65

/decl/material/liquid/oil
	fishing_bait_value = 0

/decl/material/solid/organic/skin
	fishing_bait_value = 0.75

/decl/material/solid/organic/skin/feathers
	fishing_bait_value = 0

/decl/material/solid/organic/skin/fur
	fishing_bait_value = 0