// Atom-level definitions

/atom/New(loc, ...)
	//atom creation method that preloads variables at creation
	if(global.use_preloader && (src.type == global._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		global._preloader.load(src)

	var/do_initialize = SSatoms.atom_init_stage
	var/list/created = SSatoms.created_atoms
	if(do_initialize > INITIALIZATION_INSSATOMS_LATE)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return
	else if(created)
		var/list/argument_list
		if(length(args) > 1)
			argument_list = args.Copy(2)
		if(argument_list || do_initialize == INITIALIZATION_INSSATOMS_LATE)
			created[src] = argument_list

	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		verbs += /atom/proc/climb_on

//Called after New if the map is being loaded. mapload = TRUE
//Called from base of New if the map is not being loaded. mapload = FALSE
//This base must be called or derivatives must set initialized to TRUE
//must not sleep
//Other parameters are passed from New (excluding loc)
//Must return an Initialize hint. Defined in __DEFINES/subsystems.dm

/atom/proc/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(atom_flags & ATOM_FLAG_INITIALIZED)
		PRINT_STACK_TRACE("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	if(light_power && light_range)
		update_light()

	if(opacity)
		updateVisibility(src)
		var/turf/T = loc
		if(istype(T))
			T.recalc_atom_opacity()

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/Destroy()
	QDEL_NULL(reagents)

	LAZYCLEARLIST(our_overlays)
	LAZYCLEARLIST(priority_overlays)

	QDEL_NULL(light)

	if(opacity)
		updateVisibility(src)

	return ..()

// Movable level stuff

/atom/movable/Initialize(ml, ...)
	. = ..()
	if (!follow_repository.excluded_subtypes[type] && follow_repository.followed_subtypes_tcache[type])
		follow_repository.add_subject(src)

	if (virtual_mob && ispath(initial(virtual_mob)))
		virtual_mob = new virtual_mob(get_turf(src), src)

	// Fire Entered events for freshly created movables.
	if (!ml && loc)
		loc.Entered(src, null)

/atom/movable/Destroy()
	. = ..()
#ifdef DISABLE_DEBUG_CRASH
	// meh do nothing. we know what we're doing. pro engineers.
#else
	if(!(atom_flags & ATOM_FLAG_INITIALIZED))
		PRINT_STACK_TRACE("Was deleted before initialization")
#endif

	for(var/A in src)
		qdel(A)

	forceMove(null)

	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	if(virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
		virtual_mob = null
