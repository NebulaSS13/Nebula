var/global/list/psychic_ranks_to_strings = list("Latent", "Operant", "Masterclass", "Grandmasterclass", "Paramount")

PROCESSING_SUBSYSTEM_DEF(psi)
	name = "Psychics"
	priority = SS_PRIORITY_PSYCHICS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND

	var/list/faculties_by_id        = list()
	var/list/faculties_by_name      = list()
	var/list/all_aura_images        = list()
	var/list/psi_dampeners          = list()
	var/list/psi_monitors           = list()
	var/list/armour_faculty_by_type = list()
	var/list/faculties_by_intent    = new(I_FLAG_ALL)

/datum/controller/subsystem/processing/psi/proc/get_faculty_by_intent(decl/intent/intent)
	var/static/list/intent_flags = list(
		I_FLAG_HELP,
		I_FLAG_DISARM,
		I_FLAG_GRAB,
		I_FLAG_HARM
	)
	. = faculties_by_intent[intent.intent_flags]
	if(!.)
		for(var/flag in intent_flags)
			if(flag & intent.intent_flags)
				. = faculties_by_intent[flag]
				faculties_by_intent[intent.intent_flags] = .

/datum/controller/subsystem/processing/psi/proc/get_faculty(var/faculty)
	return faculties_by_name[faculty] || faculties_by_id[faculty]

/datum/controller/subsystem/processing/psi/Initialize()
	. = ..()

	var/list/faculties = decls_repository.get_decls_of_subtype(/decl/psionic_faculty)
	for(var/ftype in faculties)
		var/decl/psionic_faculty/faculty = faculties[ftype]
		faculties_by_id[faculty.id] = faculty
		faculties_by_name[faculty.name] = faculty
		faculties_by_intent[faculty.associated_intent_flag] = faculty.id

	var/list/powers = decls_repository.get_decls_of_subtype(/decl/psionic_power)
	for(var/ptype in powers)
		var/decl/psionic_power/power = powers[ptype]
		if(power.faculty)
			var/decl/psionic_faculty/faculty = get_faculty(power.faculty)
			if(faculty)
				faculty.powers |= power
