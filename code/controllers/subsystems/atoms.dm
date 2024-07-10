#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE | SS_NEEDS_SHUTDOWN

	var/atom_init_stage = INITIALIZATION_INSSATOMS
	var/old_init_stage

	var/list/late_loaders
	var/list/created_atoms = list()

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms()
	if(atom_init_stage <= INITIALIZATION_INSSATOMS_LATE)
		return

	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(late_loaders)

	var/list/mapload_arg = list(TRUE)

	var/count = created_atoms.len
	while(created_atoms.len)
		var/atom/A = created_atoms[created_atoms.len]
		var/list/atom_args = created_atoms[A]
		created_atoms.len--
		if(!QDELETED(A) && !(A.atom_flags & ATOM_FLAG_INITIALIZED))
			if(atom_args)
				atom_args.Insert(1, TRUE)
				InitAtom(A, atom_args)
			else
				InitAtom(A, mapload_arg)
			CHECK_TICK

	// If wondering why not just store all atoms in created_atoms and use the block above: that turns out unbearably expensive.
	// Instead, atoms without extra arguments in New created on server start are fished out of world directly.
	// We do this exactly once.
	if(!initialized)
		for(var/atom/A in world)
			if(!QDELETED(A) && !(A.atom_flags & ATOM_FLAG_INITIALIZED))
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	report_progress("Initialized [count] atom\s")

	atom_init_stage = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/I in late_loaders)
			var/atom/A = I
			A.LateInitialize(arglist(late_loaders[A]))
			CHECK_TICK
		report_progress("Late initialized [late_loaders.len] atom\s")
		late_loaders.Cut()

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	// This is handled and battle tested by dreamchecker. Limit to UNIT_TESTS just in case that ever fails.
	#ifdef UNIT_TESTS
	var/start_tick = world.time
	#endif

	var/result = A.Initialize(arglist(arguments))

	#ifdef UNIT_TESTS
	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT
	#endif

	var/qdeleted = FALSE

	switch(result)
		if(INITIALIZE_HINT_NORMAL)
			EMPTY_BLOCK_GUARD
		if(INITIALIZE_HINT_LATELOAD)
			if(arguments[1])	//mapload
				late_loaders[A] = arguments
			else
				A.LateInitialize(arglist(arguments))
		if(INITIALIZE_HINT_QDEL)
			A.atom_flags |= ATOM_FLAG_INITIALIZED // never call EarlyDestroy if we return this hint
			qdel(A)
			qdeleted = TRUE
		else
			BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.atom_flags & ATOM_FLAG_INITIALIZED))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/stat_entry(msg)
	..("Bad Initialize Calls:[BadInitializeCalls.len]")

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS_LATE

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	atom_init_stage = old_init_stage

/datum/controller/subsystem/atoms/Recover()
	atom_init_stage = SSatoms.atom_init_stage
	if(atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_init_stage = SSatoms.old_init_stage
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[global.log_directory]/initialize.log")
