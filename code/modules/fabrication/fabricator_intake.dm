#define SUBSTANCE_TAKEN_NONE -1
#define SUBSTANCE_TAKEN_SOME  0
#define SUBSTANCE_TAKEN_FULL  1
#define SUBSTANCE_TAKEN_ALL   2

/obj/machinery/fabricator/proc/take_reagents(var/obj/item/thing, var/mob/user, var/destructive = FALSE)
	if(!thing.reagents || (!destructive && !ATOM_IS_OPEN_CONTAINER(thing)))
		return SUBSTANCE_TAKEN_NONE
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(thing.reagents))
		if(!base_storage_capacity[reagent.type])
			continue
		var/taking_reagent = min(REAGENT_VOLUME(thing.reagents, reagent), floor((storage_capacity[reagent.type] - stored_material[reagent.type]) * REAGENT_UNITS_PER_MATERIAL_UNIT))
		if(taking_reagent <= 0)
			continue
		var/reagent_matter = round(taking_reagent / REAGENT_UNITS_PER_MATERIAL_UNIT)
		if(reagent_matter <= 0)
			continue
		thing.remove_from_reagents(reagent, taking_reagent)
		stored_material[reagent.type] += reagent_matter
		// If we're destroying this, take everything.
		if(destructive)
			. = SUBSTANCE_TAKEN_ALL
			continue
		// Otherwise take the first applicable and useful reagent.
		if(stored_material[reagent.type] == storage_capacity[reagent.type])
			return SUBSTANCE_TAKEN_FULL
		else if(REAGENT_TOTAL_VOLUME(thing.reagents) > 0)
			return SUBSTANCE_TAKEN_SOME
		else
			return SUBSTANCE_TAKEN_ALL
	return SUBSTANCE_TAKEN_NONE

/obj/machinery/fabricator/proc/take_materials(var/obj/item/thing, var/mob/user)
	. = SUBSTANCE_TAKEN_NONE

	var/obj/item/stack/stack_ref = istype(thing, /obj/item/stack) && thing
	var/stack_matter_div = stack_ref ? max(1, ceil(SHEET_MATERIAL_AMOUNT * stack_ref.matter_multiplier)) : 1
	var/stacks_used = 0

	var/mat_colour = thing.color
	for(var/mat in thing.matter)

		var/decl/material/ingest_material = GET_DECL(mat)
		if(!ingest_material || !base_storage_capacity[mat])
			continue

		var/taking_material = min(thing.matter[mat], storage_capacity[mat] - stored_material[mat])
		if(taking_material <= 0)
			continue

		if(!mat_colour)
			mat_colour = ingest_material.color

		stored_material[mat] += taking_material
		if(stack_ref)
			stacks_used = max(stacks_used, ceil(taking_material/stack_matter_div))

		if(storage_capacity[mat] == stored_material[mat])
			. = SUBSTANCE_TAKEN_FULL
		else if(. != SUBSTANCE_TAKEN_FULL)
			. = SUBSTANCE_TAKEN_ALL

	if(. != SUBSTANCE_TAKEN_NONE)
		if(mat_colour)
			var/image/adding_mat_overlay = image(icon, "[base_icon_state]_mat")
			adding_mat_overlay.color = mat_colour
			material_overlays += adding_mat_overlay
			update_icon()
			addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/fabricator, remove_mat_overlay), adding_mat_overlay), 1 SECOND)

		if(stack_ref && stacks_used)
			stack_ref.use(stacks_used)
			if(stack_ref.amount <= 0 || QDELETED(stack_ref))
				. = SUBSTANCE_TAKEN_ALL
			else if(. != SUBSTANCE_TAKEN_FULL)
				. = SUBSTANCE_TAKEN_SOME

/obj/machinery/fabricator/proc/can_ingest(var/obj/item/thing)
	if(istype(thing, /obj/item/debris))
		return TRUE
	var/obj/item/stack/material/stack = thing
	return istype(stack) && !stack.reinf_material

/obj/machinery/fabricator/proc/show_intake_message(var/mob/user, var/value, var/thing, var/took_reagents)
	if(value == SUBSTANCE_TAKEN_FULL)
		to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with \the [thing]."))
	else if(value == SUBSTANCE_TAKEN_SOME)
		to_chat(user, SPAN_NOTICE("You fill \the [src] from \the [thing]."))
	else if(value == SUBSTANCE_TAKEN_ALL)
		to_chat(user, SPAN_NOTICE("You [took_reagents ? "empty" : "dump"] \the [thing] into \the [src]."))
	else
		to_chat(user, SPAN_WARNING("\The [src] cannot process \the [thing]."))

/obj/machinery/fabricator/attackby(var/obj/item/used_item, var/mob/user)
	if((. = component_attackby(used_item, user)))
		return
	if(panel_open && (IS_MULTITOOL(used_item) || IS_WIRECUTTER(used_item)))
		attack_hand_with_interaction_checks(user)
		return TRUE
	if((obj_flags & OBJ_FLAG_ANCHORABLE) && (IS_WRENCH(used_item) || IS_HAMMER(used_item)))
		return ..()
	if(stat & (NOPOWER | BROKEN))
		return TRUE

	// Gate some simple interactions beind intent so people can still feed lathes disks.
	if(!user.check_intent(I_FLAG_HARM))

		// Set or update our local network.
		if(IS_MULTITOOL(used_item))
			var/datum/extension/local_network_member/fabnet = get_extension(src, /datum/extension/local_network_member)
			fabnet.get_new_tag(user)
			return TRUE

		// Install new designs.
		if(istype(used_item, /obj/item/disk/design_disk))
			var/obj/item/disk/design_disk/disk = used_item
			if(!disk.blueprint)
				to_chat(user, SPAN_WARNING("\The [used_item] is blank."))
				return TRUE
			if(disk.blueprint in installed_designs)
				to_chat(user, SPAN_WARNING("\The [src] is already loaded with the blueprint stored on \the [used_item]."))
				return TRUE
			installed_designs += disk.blueprint
			design_cache |= disk.blueprint
			visible_message(SPAN_NOTICE("\The [user] inserts \the [used_item] into \the [src], and after a second or so of loud clicking, the fabricator beeps and spits it out again."))
			return TRUE

	// Attempt to bash on harm intent.
	// I'd like for this to be a more general parent call but instead it's just a direct check-and-call.
	else if(!(used_item.item_flags & ITEM_FLAG_NO_BLUDGEON) && (. = bash(used_item, user))) // Bash successful, no need to try intake.
		return

	// TEMP HACK FIX:
	// Autolathes currently do not process atom contents. As a workaround, refuse all atoms with contents.
	if(length(used_item.contents) && !ignore_input_contents_length)
		to_chat(user, SPAN_WARNING("\The [src] cannot process an object containing other objects. Empty it out first."))
		return TRUE
	// REMOVE FIX WHEN LATHES TAKE CONTENTS PLS.

	// Take reagents, if any are applicable.
	var/atom_name = used_item.name
	var/reagents_taken = take_reagents(used_item, user)
	if(reagents_taken != SUBSTANCE_TAKEN_NONE)
		show_intake_message(user, reagents_taken, atom_name, took_reagents = TRUE)
		updateUsrDialog()
		return TRUE

	if(!can_ingest(used_item))
		to_chat(user, SPAN_WARNING("\The [src] cannot process \the [used_item]."))
		return TRUE

	// Take everything if we have a recycler.
	if(!is_robot_module(used_item) && user.try_unequip(used_item))
		var/result = max(take_materials(used_item, user), max(reagents_taken, take_reagents(used_item, user, TRUE)))
		show_intake_message(user, result, atom_name)
		if(result == SUBSTANCE_TAKEN_NONE)
			user.put_in_active_hand(used_item)
			return TRUE
		if(istype(used_item, /obj/item/stack))
			var/obj/item/stack/stack = used_item
			if(!QDELETED(stack) && stack.amount > 0)
				user.put_in_active_hand(stack)
		else
			qdel(used_item)
		updateUsrDialog()
		return TRUE
	. = ..()

/obj/machinery/fabricator/physical_attack_hand(mob/user)
	if(fab_status_flags & FAB_SHOCKED)
		shock(user, 50)
		return TRUE
	return FALSE

/obj/machinery/fabricator/interface_interact(mob/user)
	if((fab_status_flags & FAB_DISABLED) && !panel_open)
		to_chat(user, SPAN_WARNING("\The [src] is disabled!"))
		return TRUE
	ui_interact(user)
	return TRUE