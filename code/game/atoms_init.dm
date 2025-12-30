// Atom-level definitions

/atom/New(loc, ...)

	// Do this as early as humanly possible to replicate previous type-based storage behavior.
	if(storage)
		if(ispath(storage))
			storage = new storage(src)
		if(!istype(storage))
			storage = null

	// This preloader code is also duplicated in /turf/unsimulated/New(). If you change this, be sure to change it there, too.
	//atom creation method that preloads variables at creation
	if(global.use_preloader && (src.type == global._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		global._preloader.load(src)

	var/do_initialize = SSatoms.atom_init_stage
	var/list/created = SSatoms.created_atoms
	if(do_initialize > INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return
	else if(length(args) > 1)
		created[++created.len] = list(src, args.Copy(2))
	else
		created[++created.len] = list(src, null)
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

	if(isnull(default_pixel_x))
		default_pixel_x = pixel_x
	else
		pixel_x = default_pixel_x
	if(isnull(default_pixel_y))
		default_pixel_y = pixel_y
	else
		pixel_y = default_pixel_y
	if(isnull(default_pixel_z))
		default_pixel_z = pixel_z
	else
		pixel_z = default_pixel_z
	if(isnull(default_pixel_w))
		default_pixel_w = pixel_w
	else
		pixel_w = default_pixel_w

	if(light_power && light_range)
		update_light()

	if(simulated && opacity)
		updateVisibility(src)
		var/turf/T = loc
		if(istype(T))
			T.recalc_atom_opacity()

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/Destroy()
	// must be done before deletion // TODO: ADD PRE_DELETION OBSERVATION
	if(isatom(loc) && loc.storage && !QDELETED(loc.storage))
		loc.storage.on_item_pre_deletion(src)
	UNQUEUE_TEMPERATURE_ATOM(src)
	QDEL_NULL(reagents)
	LAZYCLEARLIST(our_overlays)
	LAZYCLEARLIST(priority_overlays)
	LAZYCLEARLIST(climbers)
	QDEL_NULL(light)
	if(simulated && opacity)
		updateVisibility(src)
	if(atom_codex_ref && atom_codex_ref != TRUE) // may be null, TRUE or a datum instance
		QDEL_NULL(atom_codex_ref)
	. = ..()
	// This might need to be moved onto a Del() override at some point.
	QDEL_NULL(storage)

// Called if an atom is deleted before it initializes. Only call Destroy in this if you know what you're doing.
/atom/proc/EarlyDestroy(force = FALSE)
	return QDEL_HINT_QUEUE


// Movable level stuff

/atom/movable/Initialize(ml, ...)
	. = ..()
	if (!follow_repository.excluded_subtypes[type] && follow_repository.followed_subtypes_tcache[type])
		follow_repository.add_subject(src)

	if(ispath(virtual_mob))
		virtual_mob = new virtual_mob(get_turf(src), src)

	// Fire Entered events for freshly created movables.
	// Changing this behavior will almost certainly break power; update accordingly.
	if (!ml && loc)
		loc.Entered(src, null)
	if(loc && (z_flags & ZMM_WIDE_LOAD))
		SSzcopy.discover_movable(src)

/atom/movable/EarlyDestroy(force = FALSE)
	loc = null // should NOT use forceMove, in order to avoid events
	return ..()

/atom/movable/Destroy()
	// Clear this up early so it doesn't complain about events being disposed while it's listening.
	if(isatom(virtual_mob))
		QDEL_NULL(virtual_mob)

	unregister_all_movement(loc, src) // unregister events before destroy to avoid expensive checking

	// If you want to keep any of these atoms, handle them before ..()
	for(var/atom/movable/thing as anything in src) // safe to assume they're never going to have non-movables in contents
		qdel(thing)

	. = ..()

	var/atom/oldloc = loc
	forceMove(null)

	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	vis_locs = null //clears this atom out of all vis_contents
	clear_vis_contents()

	if(!isnull(updating_turf_alpha_mask))
		var/atom/movable/mask = global._alpha_masks[src]
		if(!QDELETED(mask))
			qdel(mask)

	// This has to be done for movables because atoms can't be in storage.
	if(isatom(oldloc) && !QDELETED(oldloc?.storage))
		oldloc.storage.on_item_post_deletion(src) // must be done after deletion

/atom/GetCloneArgs()
	return list(loc)

/atom/PopulateClone(atom/clone)
	//Not entirely sure about icon stuff. Some legacy things would need it copied, but not more recently coded atoms.
	clone.appearance = appearance
	clone.set_invisibility(invisibility)

	clone.SetName(name)
	clone.set_density(density)
	clone.set_opacity(opacity)
	clone.set_gender(gender, FALSE)
	clone.set_dir(dir)

	clone.blood_DNA    = listDeepClone(blood_DNA, TRUE)
	clone.was_bloodied = was_bloodied
	clone.blood_color  = blood_color
	clone.germ_level   = germ_level
	clone.temperature  = temperature

	//Setup reagents
	QDEL_NULL(clone.reagents)
	clone.reagents = reagents?.Clone()
	if(clone.reagents)
		clone.reagents.set_holder(clone) //Holder MUST be set after cloning reagents
	return clone

/atom/movable/PopulateClone(atom/movable/clone)
	clone = ..()
	clone.anchored = anchored
	return clone