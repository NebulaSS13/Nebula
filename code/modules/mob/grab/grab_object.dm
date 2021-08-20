/obj/item/grab
	name = "grab"
	canremove = 0
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_NO_CONTAINER

	pickup_sound = null
	drop_sound =   null
	equip_sound =  null

	var/atom/movable/affecting = null
	var/mob/assailant = null
	var/decl/grab/current_grab
	var/last_action
	var/last_upgrade
	var/special_target_functional = 1
	var/attacking = 0
	var/target_zone
	var/done_struggle = FALSE // Used by struggle grab datum to keep track of state.

/*
	This section is for overrides of existing procs.
*/
/obj/item/grab/Initialize(mapload, atom/movable/target, var/use_grab_state)
	. = ..(mapload)
	if(. == INITIALIZE_HINT_QDEL)
		return

	current_grab = GET_DECL(use_grab_state)
	if(!istype(current_grab))
		return INITIALIZE_HINT_QDEL
	assailant = loc
	if(!istype(assailant) || !assailant.add_grab(src))
		return INITIALIZE_HINT_QDEL
	affecting = target
	if(!istype(affecting))
		return INITIALIZE_HINT_QDEL
	target_zone = assailant.zone_sel?.selecting

	var/mob/living/affecting_mob = get_affecting_mob()
	if(affecting_mob)
		affecting_mob.UpdateLyingBuckledAndVerbStatus()
		if(ishuman(affecting_mob))
			var/mob/living/carbon/human/H = affecting_mob
			if(H.w_uniform)
				H.w_uniform.add_fingerprint(assailant)

	LAZYADD(affecting.grabbed_by, src) // This is how we handle affecting being deleted.
	adjust_position()
	action_used()
	assailant.do_attack_animation(affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_icon()

	events_repository.register(/decl/observ/moved, affecting, src, .proc/on_affecting_move)
	if(assailant.zone_sel)
		events_repository.register(/decl/observ/zone_selected, assailant.zone_sel, src, .proc/on_target_change)

	var/obj/item/organ/O = get_targeted_organ()
	var/decl/pronouns/G = assailant.get_pronouns()
	if(affecting_mob && O) // may have grabbed a buckled mob, so may be grabbing their holder
		SetName("[name] (\the [affecting_mob]'s [O.name])")
		events_repository.register(/decl/observ/dismembered, affecting_mob, src, .proc/on_organ_loss)
		if(affecting_mob != assailant)
			visible_message(SPAN_DANGER("\The [assailant] has grabbed [affecting_mob]'s [O.name]!"))
		else
			visible_message(SPAN_NOTICE("\The [assailant] has grabbed [G.his] [O.name]!"))
	else
		if(affecting != assailant)
			visible_message(SPAN_DANGER("\The [assailant] has grabbed \the [affecting]!"))
		else
			visible_message(SPAN_NOTICE("\The [assailant] has grabbed [G.self]!"))

	if(affecting_mob && affecting_mob.a_intent != I_HELP)
		upgrade(TRUE)

/obj/item/grab/examine(mob/user)
	. = ..()
	var/mob/M = get_affecting_mob()
	var/obj/item/O = get_targeted_organ()
	if(M && O)
		to_chat(user, "A grip on \the [M]'s [O.name].")
	else
		to_chat(user, "A grip on \the [affecting].")

/obj/item/grab/Process()
	current_grab.process(src)

/obj/item/grab/attack_self(mob/user)
	switch(assailant.a_intent)
		if(I_HELP)
			downgrade()
		else
			upgrade()

/obj/item/grab/attack(mob/M, mob/living/user)
	current_grab.hit_with_grab(src)

/obj/item/grab/resolve_attackby(atom/A, mob/user, var/click_params)
	if(QDELETED(src) || !assailant)
		return TRUE
	assailant.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!A.grab_attack(src))
		return ..()
	action_used()
	if (current_grab.downgrade_on_action)
		downgrade()
	return TRUE

/obj/item/grab/dropped()
	..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/grab/can_be_dropped_by_client(mob/M)
	if(M == assailant)
		return TRUE

/obj/item/grab/Destroy()
	if(affecting)
		events_repository.unregister(/decl/observ/dismembered, affecting, src)
		events_repository.unregister(/decl/observ/moved, affecting, src)
		reset_position()
		LAZYREMOVE(affecting.grabbed_by, src)
		affecting.reset_plane_and_layer()
		affecting = null
	if(assailant)
		if(assailant.zone_sel)
			events_repository.unregister(/decl/observ/zone_selected, assailant.zone_sel, src)
		assailant = null
	return ..()

/*
	This section is for newly defined useful procs.
*/

/obj/item/grab/proc/on_target_change(obj/screen/zone_sel/zone, old_sel, new_sel)
	if(src != assailant.get_active_hand())
		return // Note that because of this condition, there's no guarantee that target_zone = old_sel
	if(target_zone == new_sel)
		return
	var/old_zone = target_zone
	target_zone = new_sel
	if(!istype(get_targeted_organ(), /obj/item/organ))
		current_grab.let_go(src)
		return
	current_grab.on_target_change(src, old_zone, target_zone)

/obj/item/grab/proc/on_organ_loss(mob/victim, obj/item/organ/lost)
	if(affecting != victim)
		PRINT_STACK_TRACE("A grab switched affecting targets without properly re-registering for dismemberment updates.")
		return
	var/obj/item/organ/O = get_targeted_organ()
	if(!istype(O))
		current_grab.let_go(src)
		return // Sanity check in case the lost organ was improperly removed elsewhere in the code.
	if(lost != O)
		return
	current_grab.let_go(src)

/obj/item/grab/proc/on_affecting_move()
	if(!affecting || !isturf(affecting.loc) || get_dist(affecting, assailant) > 1)
		force_drop()

/obj/item/grab/proc/force_drop()
	assailant.drop_from_inventory(src)

/obj/item/grab/proc/get_affecting_mob()
	if(isobj(affecting))
		var/obj/O = affecting
		return O.buckled_mob
	if(isliving(affecting))
		return affecting

// Returns the organ of the grabbed person that the grabber is targeting
/obj/item/grab/proc/get_targeted_organ()
	var/mob/affecting_mob = get_affecting_mob()
	if(istype(affecting_mob))
		. = affecting_mob.get_organ(target_zone)

/obj/item/grab/proc/resolve_item_attack(var/mob/living/M, var/obj/item/I, var/target_zone)
	if(M && ishuman(M) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	return 0

/obj/item/grab/proc/action_used()
	if(ishuman(assailant))
		var/mob/living/carbon/human/H = assailant
		H.remove_cloaking_source(H.species)
	last_action = world.time
	leave_forensic_traces()

/obj/item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/grab/proc/leave_forensic_traces()
	if(ishuman(affecting))
		var/mob/living/carbon/human/affecting_mob = affecting
		var/obj/item/clothing/C = affecting_mob.get_covering_equipped_item_by_zone(target_zone)
		if(istype(C))
			C.leave_evidence(assailant)
			if(prob(50))
				C.ironed_state = WRINKLES_WRINKLY

/obj/item/grab/proc/upgrade(var/bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		return
	var/decl/grab/upgrab = current_grab.upgrade(src)
	if(upgrab)
		current_grab = upgrab
		last_upgrade = world.time
		adjust_position()
		update_icon()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/grab/proc/downgrade()
	var/decl/grab/downgrab = current_grab.downgrade(src)
	if(downgrab)
		current_grab = downgrab
		update_icon()

/obj/item/grab/on_update_icon()
	if(current_grab.icon)
		icon = current_grab.icon
	if(current_grab.icon_state)
		icon_state = current_grab.icon_state

/obj/item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/grab/proc/adjust_position(var/force = 0)
	if(force)
		affecting.forceMove(assailant.loc)
	if(!assailant || !affecting || !assailant.Adjacent(affecting))
		qdel(src)
		return 0
	var/adir = get_dir(assailant, affecting)
	if(assailant)
		assailant.set_dir(adir)
	if(current_grab.same_tile)
		affecting.forceMove(get_turf(assailant))
		affecting.set_dir(assailant.dir)
	affecting.adjust_pixel_offsets_for_grab(src, adir)

/obj/item/grab/proc/reset_position()
	affecting.reset_pixel_offsets_for_grab(src)

/*
	This section is for the simple procs used to return things from current_grab.
*/
/obj/item/grab/proc/stop_move()
	return current_grab.stop_move

/obj/item/grab/attackby(obj/W, mob/user)
	if(user == assailant)
		current_grab.item_attack(src, W)

/obj/item/grab/proc/can_absorb()
	return current_grab.can_absorb

/obj/item/grab/proc/assailant_reverse_facing()
	return current_grab.reverse_facing

/obj/item/grab/proc/shield_assailant()
	return current_grab.shield_assailant

/obj/item/grab/proc/point_blank_mult()
	return current_grab.point_blank_mult

/obj/item/grab/proc/damage_stage()
	return current_grab.damage_stage

/obj/item/grab/proc/force_danger()
	return current_grab.force_danger

/obj/item/grab/proc/grab_slowdown()
	return max(CEILING(affecting?.get_object_size() * current_grab.grab_slowdown), 1)

/obj/item/grab/proc/assailant_moved()
	affecting.glide_size = assailant.glide_size // Note that this is called _after_ the Move() call resolves, so while it adjusts affecting's move animation, it won't adjust anything else depending on it.
	current_grab.assailant_moved(src)

/obj/item/grab/proc/restrains()
	return current_grab.restrains

/obj/item/grab/proc/resolve_openhand_attack()
	return current_grab.resolve_openhand_attack(src)
