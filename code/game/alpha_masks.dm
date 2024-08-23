var/global/list/_alpha_masks = list()
/proc/get_or_create_alpha_mask(atom/movable/owner)
	if(!global._alpha_masks[owner])
		var/atom/movable/alpha_mask/mask = new
		mask.set_owner(owner)
		global._alpha_masks[owner] = mask
		return mask
	return global._alpha_masks[owner]

// Dummy overlay used to follow mobs around, separate from their icon generation for rendering purposes.
/atom/movable/alpha_mask
	name = ""
	simulated = FALSE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	default_pixel_x = -16
	default_pixel_y = -16
	var/atom/movable/owner

// Set our appearance state to avoid showing up in right-click.
/atom/movable/alpha_mask/Initialize()
	. = ..()
	verbs.Cut()
	name = ""
	appearance_flags &= ~KEEP_TOGETHER
	appearance_flags |= KEEP_APART | RESET_TRANSFORM

/atom/movable/alpha_mask/Destroy()
	if(owner)
		global._alpha_masks -= owner
		events_repository.unregister(/decl/observ/moved, owner, src)
		events_repository.unregister(/decl/observ/destroyed, owner, src)
		owner = null
	return ..()

// Update events to keep track of owner.
/atom/movable/alpha_mask/proc/set_owner(atom/movable/new_owner)
	if(owner)
		events_repository.unregister(/decl/observ/moved, owner, src)
		events_repository.unregister(/decl/observ/destroyed, owner, src)
	owner = new_owner
	if(owner)
		events_repository.register(/decl/observ/moved, owner, src, TYPE_PROC_REF(/atom/movable/alpha_mask, follow_owner))
		events_repository.register(/decl/observ/destroyed, owner, src, TYPE_PROC_REF(/datum, qdel_self))
	follow_owner()

// Callback proc to move the overlay onto the correct turf.
/atom/movable/alpha_mask/proc/follow_owner()
	if(!owner)
		qdel(src)
		return
	forceMove(get_turf(owner.loc))

// Override proc to change the overlays used by an atom type.
/atom/movable/proc/get_turf_alpha_mask_states()
	return 'icons/effects/alpha_mask.dmi'

// Proc called by /turf/Entered() to update a mob's mask overlay.
/atom/movable/proc/update_turf_alpha_mask()
	set waitfor = FALSE
	if(!simulated || updating_turf_alpha_mask)
		return
	updating_turf_alpha_mask = TRUE
	sleep(0)
	updating_turf_alpha_mask = FALSE
	if(QDELETED(src))
		return
	var/turf/our_turf = loc
	var/mask_state = isturf(our_turf) && our_turf.get_movable_alpha_mask_state(src)
	if(mask_state)
		var/atom/movable/alpha_mask/mask = get_or_create_alpha_mask(src)
		if(mask)
			var/mask_icon_file = get_turf_alpha_mask_states() || 'icons/effects/alpha_mask.dmi'
			mask.render_target = "*render_\ref[src]"
			if(mask.icon != mask_icon_file)
				mask.icon = mask_icon_file
			if(mask.icon_state != mask_state)
				mask.icon_state = mask_state
			if(add_filter("turf_alpha_mask", 1, list(type = "alpha", render_source = mask.render_target, flags = MASK_INVERSE)) && !(appearance_flags & KEEP_TOGETHER))
				update_appearance_flags(add_flags = KEEP_TOGETHER)
		else
			update_appearance_flags(remove_flags = KEEP_TOGETHER)
	else if(length(filters) && remove_filter("turf_alpha_mask") && (appearance_flags & KEEP_TOGETHER))
		update_appearance_flags(remove_flags = KEEP_TOGETHER)
