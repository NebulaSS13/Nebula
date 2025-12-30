/decl/psionic_faculty
	var/id
	var/name
	var/associated_intent_flag
	var/list/armour_types = list()
	var/list/powers = list()

/decl/psionic_faculty/validate()
	. = ..()
	if(!isnull(associated_intent_flag) && !isnum(associated_intent_flag))
		. += "non-bitflag associated_intent_flag value set"

/decl/psionic_faculty/Initialize()
	. = ..()
	for(var/atype in armour_types)
		SSpsi.armour_faculty_by_type[atype] = id
