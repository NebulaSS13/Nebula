/obj/machinery/nuclear_cylinder_storage
	name = "nuclear cylinder storage"
	desc = "It's a secure, armored storage unit embedded into the floor for storing the nuclear cylinders."
	icon = 'icons/obj/machines/self_destruct_storage.dmi'
	icon_state = "base"
	anchored = TRUE
	density = FALSE

	required_interaction_dexterity = DEXTERITY_HOLD_ITEM
	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/nuclear_cylinder_storage/buildable

	uncreated_component_parts = null

	var/locked = TRUE
	var/open = FALSE

	var/interact_time = 8 SECONDS

	var/list/cylinders = list()
	var/list/max_cylinders = 6
	var/list/prefilled = FALSE

/obj/machinery/nuclear_cylinder_storage/buildable
	locked = FALSE
	open = TRUE

/obj/machinery/nuclear_cylinder_storage/Initialize()
	. = ..()

	if(prefilled)
		fill_with_rods()

	update_icon()

/obj/machinery/nuclear_cylinder_storage/Destroy()
	QDEL_LIST(cylinders)
	return ..()

/obj/machinery/nuclear_cylinder_storage/proc/fill_with_rods()
	QDEL_LIST(cylinders)

	for(var/i in 1 to max_cylinders)
		cylinders += new /obj/item/nuclear_cylinder()

/// Special subtype for mapping.
/obj/machinery/nuclear_cylinder_storage/prefilled
	prefilled = TRUE

/obj/machinery/nuclear_cylinder_storage/emag_act(remaining_charges, mob/user, emag_source)
	to_chat(user, SPAN_WARNING("The card fails to do anything. It seems this device has an advanced encryption system."))
	return NO_EMAG_ACT

// I hate this but can't think of a better way aside from skipping the testing entirely for this type,
// which is worse. Basically, we just need to ensure we pass the cannot_transition_to check.
/obj/machinery/nuclear_cylinder_storage/fail_construct_state_unit_test()
	locked = FALSE
	open = TRUE
	var/list/old_cylinders = cylinders // This is evil.
	cylinders = list()
	. = ..()
	cylinders = old_cylinders

/obj/machinery/nuclear_cylinder_storage/components_are_accessible(path)
	return !locked && open && ..()

/obj/machinery/nuclear_cylinder_storage/cannot_transition_to(state_path, mob/user)
	if(locked)
		return SPAN_WARNING("You must unlock \the [src] first!")
	if(!open)
		return SPAN_WARNING("You must open \the [src] first!")
	if(length(cylinders))
		return SPAN_WARNING("You must remove all cylinders from \the [src] first!")
	return ..()

/obj/machinery/nuclear_cylinder_storage/physical_attack_hand(mob/user)
	if(!panel_open)
		if(!locked)
			open = !open
			user.visible_message(
				"\The [user] [open ? "opens" : "closes"] \the [src].",
				"You [open ? "open" : "close"] \the [src]."
			)
			update_icon()
			return TRUE
		if(operable() && check_access(user))
			locked = FALSE
			user.visible_message(
				"\The [user] unlocks \the [src].",
				"You unlock \the [src]."
			)
			update_icon()
			return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] is currently in maintenance mode!"))
		return TRUE
	return FALSE

/obj/machinery/nuclear_cylinder_storage/attackby(obj/item/used_item, mob/user)
	if(!open && operable() && istype(used_item, /obj/item/card/id))
		if(panel_open)
			to_chat(user, SPAN_WARNING("\The [src] is currently in maintenance mode!"))
			return TRUE

		var/obj/item/card/id/id = used_item
		if(check_access(id))
			locked = !locked
			user.visible_message(
				"\The [user] [locked ? "locks" : "unlocks"] \the [src].",
				"You [locked ? "lock" : "unlock"] \the [src]."
			)
			update_icon()
		return TRUE

	if(open && istype(used_item, /obj/item/nuclear_cylinder) && (length(cylinders) < max_cylinders))
		if(panel_open)
			to_chat(user, SPAN_WARNING("\The [src] is currently in maintenance mode!"))
			return TRUE

		user.visible_message(
			"\The [user] begins inserting \the [used_item] into storage.",
			"You begin inserting \the [used_item] into storage."
		)
		if(do_after(user, interact_time, src) && open && (length(cylinders) < max_cylinders) && user.try_unequip(used_item, src))
			user.visible_message(
				"\The [user] places \the [used_item] into storage.",
				"You place \the [used_item] into storage."
			)
			cylinders.Add(used_item)
			update_icon()
		return TRUE

	return ..()

/obj/machinery/nuclear_cylinder_storage/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && open && !panel_open && length(cylinders))
		var/cylinder = cylinders[1]
		user.visible_message(
			"\The [user] begins to extract \the [cylinder].",
			"You begin to extract \the [cylinder]."
		)
		if(do_after(user, interact_time, src) && open && cylinders.Find(cylinder))
			user.visible_message(
				"\The [user] picks up \the [cylinder].",
				"You pick up \the [cylinder]."
			)
			user.put_in_hands(cylinder)
			cylinders.Remove(cylinder)
			update_icon()

		add_fingerprint(user)
		return TRUE

	. = ..()

/obj/machinery/nuclear_cylinder_storage/on_update_icon()
	cut_overlays()

	if(length(cylinders))
		/// We have only 6 rod overlays, so lets clamp it.
		add_overlay("rods_[clamp(length(cylinders), 0, 6)]")

	if(!open)
		add_overlay("hatch")

	if(operable())
		if(locked)
			add_overlay("red_light")
		else
			add_overlay("green_light")
