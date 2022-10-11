// This subsystem exists solely to crosslink aspects due to mutual dependency loops.
SUBSYSTEM_DEF(aspects)
	name = "Aspects"
	flags = SS_NO_FIRE
	init_order = SS_INIT_PRE_CHAR_SETUP
	var/list/all_aspects = list()

/datum/controller/subsystem/aspects/Initialize()
	var/list/all_aspect_decls = decls_repository.get_decls_of_subtype(/decl/aspect)
	for(var/aspect_type in all_aspect_decls)
		var/decl/aspect/aspect = all_aspect_decls[aspect_type]
		if(aspect.name) // remove when dev abstract decl changes are merged in
			aspect.build_references()
			all_aspects |= aspect
	. = ..()
