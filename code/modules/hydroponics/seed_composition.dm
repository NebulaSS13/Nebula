/datum/seed
	VAR_PRIVATE/list/_chemical_composition

/datum/seed/proc/copy_chemical_composition(datum/seed/donor)
	UNLINT(_chemical_composition = deepCopyList(donor._chemical_composition))

/datum/seed/proc/get_chemical_amount(_chem, _state = PLANT_STATE_FRESH, _segment = PLANT_SEG_BODY)
	var/list/comp = get_chemical_composition(_state, _segment)
	return LAZYACCESS(comp, _chem)

/datum/seed/proc/set_chemical_amount(_chem, list/_amt, _state = PLANT_STATE_FRESH, _segment = PLANT_SEG_BODY)
	LAZYINITLIST(_chemical_composition)
	LAZYINITLIST(_chemical_composition[_state])
	LAZYSET(_chemical_composition[_state][_segment], _chem, _amt)

/datum/seed/proc/get_chemical_composition(_state = PLANT_STATE_FRESH, _segment = PLANT_SEG_BODY)
	var/list/comp = LAZYACCESS(_chemical_composition, _state)
	return LAZYACCESS(comp, _segment)

/datum/seed/proc/clear_chemical_composition()
	LAZYCLEARLIST(_chemical_composition)
