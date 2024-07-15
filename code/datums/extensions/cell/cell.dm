/datum/extension/loaded_cell
	expected_type = /obj/item
	base_type = /datum/extension/loaded_cell
	VAR_PRIVATE/weakref/loaded_cell_ref
	var/load_sound = 'sound/weapons/guns/interaction/energy_magin.ogg'
	var/unload_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
	var/requires_tool
	var/expected_cell_type = /obj/item/cell/device
	var/load_delay = 1 SECOND
	var/unload_delay
	var/can_modify = TRUE

/datum/extension/loaded_cell/New(datum/holder, _expected_cell_type, _create_cell_type, _override_cell_capacity)
	..(holder)
	if(ispath(_expected_cell_type))
		if(!ispath(_expected_cell_type, /obj/item/cell))
			PRINT_STACK_TRACE("Non-cell type supplied to [type] as expected cell type.")
		expected_cell_type = _expected_cell_type
	if(ispath(_create_cell_type))
		create_cell(_create_cell_type, _override_cell_capacity)

/datum/extension/loaded_cell/Destroy()
	var/obj/item/cell/existing_cell = loaded_cell_ref?.resolve()
	if(istype(existing_cell) && !QDELETED(existing_cell) && existing_cell.loc == holder)
		qdel(existing_cell)
	return ..()

/datum/extension/loaded_cell/proc/create_cell(_create_cell_type, _override_cell_capacity)
	if(!ispath(_create_cell_type, expected_cell_type))
		PRINT_STACK_TRACE("Non-expected type '[_create_cell_type]' supplied to [type] as premade cell type (expected '[expected_cell_type]').")
	loaded_cell_ref = weakref(new _create_cell_type(holder, _override_cell_capacity))

/datum/extension/loaded_cell/proc/get_cell()
	var/obj/item/cell/cell = loaded_cell_ref?.resolve()
	if(istype(cell) && !QDELETED(cell) && cell.loc == holder)
		return cell

/datum/extension/loaded_cell/proc/has_tool_unload_interaction(var/obj/item/tool)
	return requires_tool && IS_TOOL(tool, requires_tool)

/datum/extension/loaded_cell/proc/try_load(var/mob/user, var/obj/item/cell/cell)

	// Check inputs.
	var/obj/item/holder_item = holder
	if(!istype(cell) || !istype(user) || QDELETED(cell) || QDELETED(user) || user.incapacitated())
		return FALSE

	if(!can_modify)
		to_chat(user, SPAN_WARNING("\The [holder] power supply cannot be replaced."))
		return TRUE

	// Check type.
	if(!istype(cell, expected_cell_type))
		var/obj/item/expected_cell = expected_cell_type
		to_chat(user, SPAN_WARNING("\The [holder] will only accept \a [initial(expected_cell.name)]."))
		return TRUE // technically a valid interaction.

	// Check existing cell ref.
	var/obj/item/cell/existing_cell = loaded_cell_ref?.resolve()
	if(istype(existing_cell) && !QDELETED(existing_cell) && existing_cell.loc == holder)
		to_chat(user, SPAN_WARNING("\The [holder] already has \a [existing_cell] loaded."))
		return TRUE // technically a valid interaction.

	// Apply delays.
	if(load_delay && !do_after(user, load_delay, holder))
		return FALSE

	// Recheck existing cell ref.
	if(!istype(cell) || !istype(user) || QDELETED(cell) || QDELETED(user) || user.incapacitated())
		return FALSE
	// Recheck existing cell ref.
	existing_cell = loaded_cell_ref?.resolve()
	if(istype(existing_cell) && !QDELETED(existing_cell) && existing_cell.loc == holder)
		to_chat(user, SPAN_WARNING("\The [holder] already has \a [existing_cell] loaded."))
		return TRUE // technically a valid interaction.

	// Load the cell.
	if(user.try_unequip(cell, holder, FALSE))
		user.visible_message(SPAN_NOTICE("\The [user] slots \the [cell] into \the [holder]."))
		loaded_cell_ref = weakref(cell)
		if(load_sound)
			playsound(user.loc, pick(load_sound), 25, 1)
		holder_item.update_icon()
		return TRUE
	return FALSE

/datum/extension/loaded_cell/proc/try_unload(var/mob/user, var/obj/item/tool)

	// Check inputs.
	var/obj/item/holder_item = holder
	if(!istype(user) || QDELETED(user) || user.incapacitated())
		return FALSE

	if(!can_modify)
		if(tool)
			to_chat(user, SPAN_WARNING("\The [holder]'s power supply cannot be removed."))
			return TRUE // Tool interactions should get a warning, inhand interactions should just default to regular attack_hand.
		return FALSE

	// Check existing cell.
	var/obj/item/cell/existing_cell = loaded_cell_ref?.resolve()
	if(!istype(existing_cell) || QDELETED(existing_cell) || existing_cell.loc != holder)
		to_chat(user, SPAN_WARNING("\The [holder] has no cell loaded."))
		if(loaded_cell_ref)
			loaded_cell_ref = null
			holder_item.update_icon()
		return TRUE // technically a valid interaction.

	// Apply tool checks.
	if(requires_tool)
		// No tool provided means we're probably using an empty hand - don't print a warning if it's a tool based removal.
		if(!istype(tool) || QDELETED(tool))
			return FALSE
		if(!IS_TOOL(tool, requires_tool))
			var/decl/tool_archetype/tool_arch = GET_DECL(requires_tool)
			to_chat(user, SPAN_WARNING("\The [holder] requires \a [tool_arch.name] to remove the cell."))
			return TRUE // technically a valid interaction.
		if(unload_delay && !tool.do_tool_interaction(requires_tool, user, holder, unload_delay))
			return FALSE
	else if(istype(tool))
		return FALSE
	// Apply general delay.
	else if(unload_delay && !do_after(user, unload_delay, holder))
		return FALSE

	// Recheck inputs.
	if(!istype(user) || QDELETED(user) || user.incapacitated())
		return FALSE
	// Recheck existing cell.
	existing_cell = loaded_cell_ref?.resolve()
	if(!istype(existing_cell) || QDELETED(existing_cell) || existing_cell.loc != holder)
		to_chat(user, SPAN_WARNING("\The [holder] has no cell loaded."))
		if(loaded_cell_ref)
			loaded_cell_ref = null
			holder_item.update_icon()
		return TRUE // technically a valid interaction.

	// Unload the cell.
	user.visible_message(
		SPAN_NOTICE("\The [user] removes \the [existing_cell] from \the [holder]."),
		SPAN_NOTICE("You remove \the [existing_cell] from \the [holder].")
	)
	existing_cell.dropInto(get_turf(holder))
	user.put_in_active_hand(existing_cell)
	holder_item.update_icon()
	if(unload_sound)
		playsound(user.loc, pick(unload_sound), 25, TRUE)
	return TRUE

/datum/extension/loaded_cell/proc/get_examine_text(var/obj/item/cell/current_cell)
	. = list()
	if(current_cell)
		. += SPAN_NOTICE("\The [holder] has \a [current_cell] installed.")
		. += SPAN_NOTICE("\The [holder] is [round(current_cell.percent())]% charged.")
		if(can_modify)
			if(requires_tool)
				var/decl/tool_archetype/needed_tool = GET_DECL(requires_tool)
				. += SPAN_NOTICE("\The [holder] power supply requires \a [needed_tool.name] to remove.")
			else
				. += SPAN_NOTICE("Hold \the [holder] in an off-hand and click it with an empty hand to remove the power supply.")
		else
			. += SPAN_NOTICE("\The [holder] power supply cannot be removed.")
	else
		var/obj/item/cell = expected_cell_type
		. += SPAN_WARNING("\The [holder] has no power source installed.")
		if(can_modify)
			. += SPAN_NOTICE("\The [holder] is compatible with \a [initial(cell.name)].")
		else
			. += SPAN_NOTICE("\The [holder] power supply cannot be replaced.")
