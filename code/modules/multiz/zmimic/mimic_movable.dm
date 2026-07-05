/atom/movable
	/// The mimic (if any) that's *directly* copying us.
	var/tmp/atom/movable/openspace/mimic/bound_overlay
	/// Movable-level Z-Mimic flags. This uses ZMM_* flags, not ZM_* flags.
	var/z_flags = 0

/atom/movable/set_dir(ndir)
	. = ..()
	if (. && bound_overlay)
		bound_overlay.set_dir(ndir)

/atom/movable/update_above()
	if (!isturf(loc))
		return

	if (MOVABLE_IS_BELOW_ZTURF(src))
		if (!bound_overlay)
			SSzcopy.discover_movable(src)
			return

		SSzcopy.queued_overlays += bound_overlay
		bound_overlay.queued += 1
	else if (bound_overlay)	// qdel is null-safe, but might as well save a proc call
		qdel(bound_overlay)

// Grabs a list of every openspace object that's directly or indirectly mimicking this object. Returns an empty list if none found.
/atom/movable/proc/get_above_oo()
	. = list()
	var/atom/movable/curr = src
	while (curr.bound_overlay)
		. += curr.bound_overlay
		curr = curr.bound_overlay

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	abstract_type = /atom/movable/openspace // unsure if this is valid, check with Lohi -- Yes, it's valid.
	var/target_slot = 0

/atom/movable/openspace/can_fall()
	return FALSE

// No blowing up abstract objects.
/atom/movable/openspace/explosion_act(ex_sev)
	SHOULD_CALL_PARENT(FALSE)
	return

// -- MULTIPLIER / SHADOWER --

// Holder object used for dimming openspaces & copying lighting of below turf.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shouldn't see this."
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "blank"
	plane = ZM_COMPUTE_PLANE(0, ZM_SLICE_SLOT_LIGHTING)
	layer = MIMICED_LIGHTING_LAYER
	color = SHADOWER_DARKENING_COLOR
	var/lighting_generation = 0
	var/lighting_generation_static = 0

/atom/movable/openspace/multiplier/Destroy(force)
	if(!force)
		PRINT_STACK_TRACE("Turf shadower improperly qdel'd.")
		return QDEL_HINT_LETMELIVE
	var/turf/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

/atom/movable/openspace/multiplier/proc/copy_lighting(atom/movable/lighting_overlay/LO)
	if (LO.needs_update)
		// If this LO is pending an update, avoid this update and just let it update us.
		return
	ASSERT(LO.z == z - 1)
	var/mutable_appearance/MA = new /mutable_appearance(LO)
	MA.layer = MIMICED_LIGHTING_LAYER
	MA.plane = ZM_COMPUTE_PLANE(0, ZM_SLICE_SLOT_LIGHTING)

	var/turf/T = loc
	if (!(T.below.z_flags & ZM_NO_SHADOW))
		if (MA.icon_state == LIGHTING_BASE_ICON_STATE)
			// We're using a color matrix, so just darken the colors across the board.
			var/list/c_list = MA.color
			c_list[CL_MATRIX_RR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_RG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_RB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AB] *= SHADOWER_DARKENING_FACTOR
			MA.color = c_list
		else
			// Not a color matrix, so we can just use the color var ourselves.
			MA.color = SHADOWER_DARKENING_COLOR

	appearance = MA

	lighting_generation += 1
	set_invisibility(INVISIBILITY_NONE)

	if (our_overlays || priority_overlays)
		compile_overlays()
	else if (bound_overlay)
		// compile_overlays() calls update_above().
		update_above()

// -- OPENSPACE MIMIC --

// Object used to hold a mimiced atom's appearance.
/atom/movable/openspace/mimic
	plane = ZMIMIC_MAXIMUM_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = 0
	var/destruction_timer
	var/mimiced_type
	var/original_z
	var/override_depth
	var/hidden = FALSE
	var/cached_name
	var/have_performed_fixup = FALSE

/atom/movable/openspace/mimic/New()
	atom_flags = ATOM_FLAG_INITIALIZED
	SSzcopy.openspace_overlays += 1
	loc?.Entered(src, null)

/atom/movable/openspace/mimic/Destroy()
	SSzcopy.openspace_overlays -= 1
	queued = 0

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/mimic/proc/timeout(filename, line, reason)
	ZM_DEBUG_LOG("Mimic timeout from origin [filename]:[line], caused by [reason]; was mimicking [associated_atom || "NULL"] ([associated_atom?.type || "NULL"]) at [x],[y],[z]")
	qdel(src)

/atom/movable/openspace/mimic/attackby(obj/item/used_item, mob/user)
	to_chat(user, SPAN_NOTICE("\The [src] is too far away."))
	return TRUE

/atom/movable/openspace/mimic/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))
	return TRUE

/atom/movable/openspace/mimic/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	return associated_atom.examined_by(user, distance, infix, suffix)

/atom/movable/openspace/mimic/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	var/decl/pronouns/P = get_pronouns_by_gender(gender)
	return associated_atom.examined_by(user, null, infix, suffix || "[P.He] [P.is] [z - original_z] level\s below you.")

// Trying to grab a mimic tries to grab the copied atom instead.
/atom/movable/openspace/mimic/try_make_grab(mob/living/user, defer_hand)
	return associated_atom.try_make_grab(user, defer_hand)

/atom/movable/openspace/mimic/forceMove(turf/dest)
	if (QDELING(src))	// Everything in this block is nonsense if we're being destroyed.
		return ..()

	if (!dest)
		ZM_DEBUG_LOG("Mimic moved to nullspace; deleting self.")
		qdel(src)
		return

	var/turf/old_loc = loc
	var/force_layering_update = FALSE

	if (isnull(override_depth) && isturf(old_loc) && isturf(dest) && old_loc.z != dest.z)
		var/atom/movable/openspace/mimic/parent_mimic = astype(associated_atom)
		// If we're the top-most mimic, we can directly compute depth. Otherwise, pull it off our parent mimic since it should already have either computed it itself, or stolen it from _its_ parent.
		depth = parent_mimic?.depth
		if (depth == null)	// depth of 0 is valid
			depth = ZM_COMPUTE_DEPTH(associated_atom.z)
			ZM_DEBUG_LOG("Recomputing depth, no parent: result is [depth]")
			force_layering_update = TRUE

	. = ..()

	if (MOVABLE_IS_ON_ZTURF(src))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null

		if (isturf(old_loc))
			var/flag_difference = old_loc.z_flags ^ dest.z_flags

			if (force_layering_update || (flag_difference & ZM_FLAGS_AFFECTS_LAYERING))
				SSzcopy.update_mimic_layering(src)

			if (flag_difference & ZM_FLAGS_AFFECTS_VIS)
				SSzcopy.update_mimic_occlusion(src)
		else	// If we're moving from null to a z-turf, just rebuild both.
			SSzcopy.update_mimic_layering(src)
			SSzcopy.update_mimic_occlusion(src)

	else if (!destruction_timer)
		destruction_timer = ZM_DESTRUCTION_TIMER(src, "forceMove")

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/mimic/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = ZM_DESTRUCTION_TIMER(src, "OTC")

// -- TURF PROXY --

// This thing holds the mimic appearance for non-OVERWRITE turfs.
/atom/movable/openspace/turf_proxy
	plane = ZMIMIC_MAXIMUM_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	z_flags = ZMM_IGNORE  // Only one of these should ever be visible at a time, the mimic logic will handle that.

/atom/movable/openspace/turf_proxy/attackby(obj/item/used_item, mob/user)
	return loc.attackby(used_item, user)

/atom/movable/openspace/turf_proxy/attack_hand(mob/user as mob)
	SHOULD_CALL_PARENT(FALSE)
	return loc.attack_hand(user)

/atom/movable/openspace/turf_proxy/attack_generic(mob/user as mob)
	loc.attack_generic(user)

/atom/movable/openspace/turf_proxy/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	return loc.examined_by(user, distance, infix, suffix)


// -- TURF MIMIC --

// A type for copying non-overwrite turfs' self-appearance.
/atom/movable/openspace/turf_mimic
	plane = ZMIMIC_MAXIMUM_PLANE	// These *should* only ever be at the top?
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	var/turf/delegate

/atom/movable/openspace/turf_mimic/Initialize(mapload, ...)
	. = ..()
	ASSERT(isturf(loc))
	delegate = loc:below

/atom/movable/openspace/turf_mimic/attackby(obj/item/used_item, mob/user)
	return loc.attackby(used_item, user)

/atom/movable/openspace/turf_mimic/attack_hand(mob/user as mob)
	SHOULD_CALL_PARENT(FALSE)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))
	return TRUE

/atom/movable/openspace/turf_mimic/attack_generic(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/examined_by(mob/user, distance, infix, suffix)
	SHOULD_CALL_PARENT(FALSE)
	return delegate.examined_by(user, distance, infix, suffix)
