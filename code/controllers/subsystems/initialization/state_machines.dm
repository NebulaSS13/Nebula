SUBSYSTEM_DEF(state_machines)
	name = "State Machines"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE


/datum/controller/subsystem/state_machines/Initialize()
	. = ..()

	var/list/states = decls_repository.get_decls_unassociated(decls_repository.get_decls_of_subtype(/decl/state))
	for(var/thing in states)
		var/decl/state/state = thing
		state.set_up()