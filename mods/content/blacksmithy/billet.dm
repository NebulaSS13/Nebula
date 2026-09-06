// Turning billets back into bars.
/obj/item/stack/material/bar/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/billet) && used_item.material == material && !reinf_material)
		var/obj/item/billet/billet = used_item
		if(billet.current_forging_step && billet.current_forging_step.type != /decl/forging_step/billet)
			to_chat(user, SPAN_WARNING("\The [used_item] will need to be melted down and recast before you can reuse it as a bar."))
			return TRUE
		if(!user.try_unequip(used_item, loc))
			return TRUE
		if(get_amount() >= get_max_amount())
			return TRUE
		add(1)
		qdel(used_item)
		return TRUE
	. = ..()

/// Whether or not this item is considered forgable (e.g. there is a temperature at which it can be forged)
/obj/item/proc/is_forgable()
	if(!istype(material) || isnull(material.melting_point) || !material.forgable)
		return FALSE
	return TRUE

/obj/item/proc/hot_enough_to_forge(melting_point_percent = 0.25)
	if(!is_forgable())
		return FALSE
	// Defaults to >25% of the way to melting to be considered 'forgable'
	return temperature >= ((material.melting_point - T20C) * melting_point_percent) + T20C

/obj/item/billet
	name                = "billet"
	desc                = "An unworked or partially-worked length of metal used to forge items and tools."
	icon                = 'mods/content/blacksmithy/icons/billet.dmi'
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/metal/iron
	color               = /decl/material/solid/metal/iron::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/decl/forging_step/current_forging_step = /decl/forging_step/billet

/obj/item/billet/Initialize(ml, material_key)
	if(ispath(current_forging_step))
		set_forging_step(current_forging_step, force = TRUE)
	. = ..()

/obj/item/billet/proc/set_forging_step(decl/forging_step/new_step, force)
	if(ispath(new_step))
		new_step = GET_DECL(new_step)
	if(!istype(new_step) || (!force && current_forging_step == new_step))
		return FALSE
	current_forging_step = new_step
	. = current_forging_step.apply_to(src)
	if(!QDELETED(src))
		update_name()
		update_icon()
		update_heat_glow(anim_time = 0) // reset heat color to avoid weird visual jitter

/obj/item/billet/attackby(obj/item/used_item, mob/user)

	// Merging billets back into bars.
	if(istype(used_item, /obj/item/billet) && material == used_item.material)
		if(current_forging_step && current_forging_step.type != /decl/forging_step/billet)
			to_chat(user, SPAN_WARNING("\The [src] will need to be melted down and recast before you can reuse it as a bar."))
			return TRUE
		var/obj/item/billet/billet = used_item
		if(billet.current_forging_step && billet.current_forging_step.type != /decl/forging_step/billet)
			to_chat(user, SPAN_WARNING("\The [billet] will need to be melted down and recast before you can reuse it as a bar."))
			return TRUE
		if(user.try_unequip(used_item, loc))
			var/obj/item/stack/material/bar/bars = new(loc, 2, material.type)
			bars.dropInto(loc)
			qdel(used_item)
			qdel(src)
		return TRUE

	// Picking up in tongs.
	if(istype(used_item, /obj/item/tongs))
		var/obj/item/tongs/tongs = used_item
		if(tongs.holding_bar)
			return ..()
		var/mob/holder = loc
		if(istype(holder))
			if(!holder.try_unequip(src, tongs))
				return TRUE
		else if(loc?.storage)
			if(!loc.storage.remove_from_storage(user, src, tongs))
				return TRUE
		else
			forceMove(tongs)
		if(loc == tongs)
			tongs.holding_bar = src
			tongs.update_icon()
		return TRUE

	if(!istype(used_item, /obj/item/tool/hammer/forge) || user.check_intent(I_FLAG_HARM))
		return ..()

	// Check for surface.
	var/obj/structure/anvil/anvil = locate() in loc
	if(!istype(anvil))
		to_chat(user, SPAN_WARNING("\The [src] can only be worked on an anvil."))
		return TRUE

	// Check for heat.
	if(!hot_enough_to_forge())
		to_chat(user, SPAN_WARNING("\The [src] is too cold to be worked on the anvil."))
		return TRUE

	// Sanity check.
	if(!length(current_forging_step?.steps)) // how tho
		to_chat(user, SPAN_WARNING("You cannot see any further way to refine \the [src]."))
		return TRUE

	// Handle the actual forging process.
	var/last_step = current_forging_step
	var/decl/forging_step/next_step = show_radial_menu(user, src, current_forging_step.get_radial_choices(), radius = 42, use_labels = RADIAL_LABELS_CENTERED, require_near = TRUE, check_locs = list(src))

	if(!standard_forging_checks(user, used_item, last_step, next_step, anvil))
		return TRUE

	if(user.get_stamina() < 10)
		to_chat(user, SPAN_WARNING("You are too exhausted to swing \the [used_item]."))
		return TRUE

	user.adjust_stamina(-10)
	anvil.start_working(user)

	// Skill checks!
	if(!user.do_skilled(3 SECONDS, next_step.work_skill, anvil))
		anvil?.stop_working()
		return TRUE

	if(!istype(next_step) || (next_step.skill_fail_prob && user.skill_fail_prob(next_step.work_skill, next_step.skill_fail_prob, next_step.skill_level, next_step.skill_factor)))
		to_chat(user, SPAN_WARNING("You fumble the work and fail to reshape \the [src]."))
		anvil?.stop_working()
		return TRUE

	// Since we have a sleep() above, we recheck our basic conditions.
	if(!standard_forging_checks(user, used_item, last_step, next_step, anvil))
		anvil?.stop_working()
		return TRUE

	if(user.get_stamina() < 10)
		to_chat(user, SPAN_WARNING("You are too exhausted to keep swinging \the [used_item]."))
		anvil?.stop_working()
		return TRUE

	user.adjust_stamina(-10)

	// Update the billet (which may produce an item!)
	var/obj/item/forged_thing = set_forging_step(next_step)
	if(istype(forged_thing))
		user.visible_message(SPAN_NOTICE("\The [user] has [next_step.work_verb] the billet into \a [forged_thing]."))
	// Forging gradually degrades anvils.
	if(!QDELETED(anvil))
		anvil.stop_working()
		anvil.take_damage(rand(10, 20), BRUTE, silent = TRUE) // We are already going CLANG CLANG CLANG, don't need a THUNK
	return TRUE

/obj/item/billet/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	for(var/decl/forging_step/next_step in current_forging_step?.steps)
		if(user.skill_check(next_step.work_skill, next_step.skill_level))
			LAZYADD(., SPAN_INFO("It can be [next_step.work_verb] into \a [next_step.get_product_name(material)] on an anvil."))

/obj/item/billet/proc/standard_forging_checks(mob/user, obj/item/used_item, decl/forging_step/last_step, decl/forging_step/next_step, obj/structure/anvil/anvil)
	// We cancelled or changed state, abort.
	if(!next_step || current_forging_step != last_step || !(next_step in current_forging_step.steps))
		return FALSE
	// Something has been destroyed since we started forging.
	if(QDELETED(src) || QDELETED(used_item) || QDELETED(anvil) || QDELETED(user))
		return FALSE
	// Something else has changed, very unfortunate.
	if(loc != anvil.loc || !CanPhysicallyInteract(user) || user.get_active_held_item() != used_item)
		return FALSE
	return hot_enough_to_forge()

/obj/item/billet/on_update_icon()
	. = ..()
	if(!istype(current_forging_step))
		return
	if(current_forging_step.billet_icon)
		set_icon(current_forging_step.billet_icon)
	else
		set_icon(initial(icon))
	icon_state = get_world_inventory_state()
	if(current_forging_step.billet_icon_state)
		icon_state = "[icon_state]-[current_forging_step.billet_icon_state]"

/obj/item/billet/get_world_inventory_state()
	if(!current_forging_step?.billet_icon_state)
		return ..()
	if(!check_state_in_icon("[ICON_STATE_INV]-[current_forging_step.billet_icon_state]", icon))
		return ICON_STATE_WORLD
	return ..()

/obj/item/billet/update_name()
	if(!istype(current_forging_step))
		base_name   = initial(base_name)
		name_prefix = initial(name_prefix)
		desc        = initial(desc)
		return ..()
	base_name   = current_forging_step.billet_name
	name_prefix = current_forging_step.billet_name_prefix
	. = ..()
	desc = current_forging_step.billet_desc
	if(istype(material))
		desc = "[desc] This one is made of [material.solid_name]."

/obj/item/billet/ProcessAtomTemperature()
	. = ..()
	update_heat_glow()

// Arbitrary value to give people enough time to forge the bloody thing.
/obj/item/billet/get_thermal_mass_coefficient(delta)
	// Only delay cooling if we're over our forging point.
	return delta < 0 && hot_enough_to_forge() ? 0.01 : ..()
