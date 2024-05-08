/decl/plant_trait
	abstract_type = /decl/plant_trait
	/// Descriptive name for this trait.
	var/name
	/// Shows a simple name: value header in the plant scanner.
	var/shows_general_data = FALSE
	/// Provides a dynamic string to the plant scanner (see get_extended_data())
	var/shows_extended_data = FALSE
	/// Multiplier for value when calculating seed worth.
	var/base_worth = 0
	/// Value assumed if the trait has not been inserted into the traits list.
	var/default_value = 0
	/// Set to skip master gene checking in validate().
	var/requires_master_gene = TRUE

/decl/plant_trait/proc/get_station_survivable_value()
	return

/decl/plant_trait/proc/get_extended_data(val, datum/seed/grown_seed)
	return

/decl/plant_trait/proc/get_worth_of_value(val)
	return base_worth * val

/decl/plant_trait/proc/handle_post_trait_set(datum/seed/seed)
	return

/decl/plant_trait/validate()
	. = ..()
	if(!istext(name))
		. += "null or invalid name: [name || "NULL"]"
	if(requires_master_gene)
		for(var/decl/plant_gene/plant_gene in decls_repository.get_decls_of_subtype_unassociated(/decl/plant_gene))
			if(type in plant_gene.associated_traits)
				return
		. += "could not find master gene"
