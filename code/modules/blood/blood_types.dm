var/global/list/blood_types_by_name
/proc/get_blood_type_by_name(var/blood_type)
	var/list/blood_types = get_all_blood_types()
	. = blood_types[blood_type]
	if(!.)
		PRINT_STACK_TRACE("Invalid blood_type key supplied to get_blood_type_by_name(): [blood_type || "NULL"]")

/proc/get_all_blood_types()
	if(!global.blood_types_by_name)
		global.blood_types_by_name = list()
		var/list/all_blood_types = decls_repository.get_decls_of_subtype(/decl/blood_type)
		for(var/btype in all_blood_types)
			var/decl/blood_type/blood_decl = all_blood_types[btype]
			global.blood_types_by_name[blood_decl.name] = blood_decl
	return global.blood_types_by_name

/decl/blood_type
	abstract_type = /decl/blood_type

	var/name
	var/list/antigens
	var/random_weighting = 1
	var/antigen_category = SPECIES_MONKEY // Rhesus factor oh no

	var/splatter_name =   "blood"
	var/splatter_desc =   "It's some blood. That's not supposed to be there."
	var/splatter_colour = COLOR_BLOOD_HUMAN

	var/transfusion_fail_percentage = 0.5
	var/transfusion_fail_reagent = /decl/material/liquid/coagulated_blood

var/global/list/antigen_comparison_cache = list()
/decl/blood_type/proc/can_take_donation_from(var/decl/blood_type/other_blood_type)

	// Invalid object type, probably did a stack trace already, return early.
	if(!istype(other_blood_type))
		return FALSE

	// This is alien blood, gross yuck.
	if(other_blood_type.antigen_category != antigen_category)
		return FALSE

	// Other blood type is O-, universal donor.
	if(!LAZYLEN(other_blood_type.antigens))
		return TRUE

	// Our blood type is O- and the other blood type is not; can't take donation.
	if(!LAZYLEN(antigens))
		return FALSE

	// Check if we have all the associated antigens.
	// Cache the result to avoid constantly having to recompare lists that don't change.
	LAZYINITLIST(global.antigen_comparison_cache[type])
	. = global.antigen_comparison_cache[type][other_blood_type.type]
	if(isnull(.))
		. = TRUE
		for(var/antigen in other_blood_type.antigens)
			if(!(antigen in antigens))
				. = FALSE
				break
		global.antigen_comparison_cache[type][other_blood_type.type] = .
