/datum/seed
	VAR_PRIVATE/list/_physical_composition

/datum/seed/proc/clear_chemical_composition_for_segment(_segment = PLANT_SEG_BODY)
	if(isnull(_chemical_composition))
		return
	for(var/state in _chemical_composition)
		LAZYREMOVE(_chemical_composition[state], _segment)

/datum/seed/proc/set_segment_data(datum/plant_segment/segment_data)
	LAZYINITLIST(_physical_composition)
	LAZYSET(_physical_composition, segment_data.plant_segment_type, segment_data)
	clear_chemical_composition_for_segment(segment_data.plant_segment_type)
	if(length(segment_data.reagents))
		for(var/state in segment_data.reagents)
			for(var/reagent in segment_data.reagents[state])
				set_chemical_amount(reagent, segment_data.reagents[state][reagent], state, segment_data.plant_segment_type)

/datum/seed/proc/get_segment_data(_segment = PLANT_SEG_BODY, _state = PLANT_STATE_FRESH)
	var/list/comp = LAZYACCESS(_physical_composition, _state)
	. = LAZYACCESS(comp, _segment)
	if(!. && _state != PLANT_STATE_FRESH)
		return get_segment_data(_segment, PLANT_STATE_FRESH) // Let physical data default to anything set regardless of state.

/datum/seed/proc/get_physical_composition()
	for(var/segment_type in _physical_composition)
		LAZYADD(., _physical_composition[segment_type])

/datum/seed/flower/New()
	..()
	// Adding this soley for the purposes of 'she loves me, she loves me not'
	var/decl/pronouns/pronouns = get_pronouns_by_gender(pick(MALE, FEMALE, PLURAL))
	set_segment_data(
		new /datum/plant_segment/petal(
			"petal",
			"[pronouns.He] love[pronouns.s] me, [pronouns.he] love[pronouns.s] me not...",
			list(3,5),
			list(
				(PLANT_STATE_FRESH) = list(
					/decl/material/liquid/nutriment = list(1)
				)
			)
		)
	)
