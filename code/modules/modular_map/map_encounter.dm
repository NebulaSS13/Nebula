/decl/modular_map_generator/proc/generate_encounter_sequence()
	//var/list/encounters = decls_repository.get_decls_of_subtype_unassociated(/decl/mm_encounter_template)

/datum/mm_encounter

	var/datum/mm_encounter/previous_encounter
	var/list/subsequent_encounters

	var/decl/mm_encounter_template/encounter_data
	var/list/cells = list()

/datum/mm_encounter/Destroy(force)
	cells = null
	return ..()

