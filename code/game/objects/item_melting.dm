/obj/item/ProcessAtomTemperature()

	if(material && material.bakes_into_material && !isnull(material.bakes_into_at_temperature) && temperature >= material.bakes_into_at_temperature)
		set_material(material.bakes_into_material)

	. = ..()

	if(QDELETED(src))
		return

	// Handle being burned by items that are too hot for you to touch.
	// TODO: check holding organ coverage and be burned by hot items
	// TODO: that one spell from D&D that heats up your armour
	if(ismob(loc))
		var/mob/holder = loc
		try_burn_wearer(holder, holder.get_equipped_slot_for_item(src))

/*
	// Check if this is meltable at all.
	var/list/meltable_materials
	for(var/mat in matter)
		var/decl/material/melt_material = GET_DECL(mat)
		if(!isnull(melt_material.melting_point) && temperature >= melt_material.melting_point)
			LAZYDISTINCTADD(meltable_materials, melt_material)
	if(length(meltable_materials))
		. = null // Don't return PROCESS_KILL here.
		handle_melting(meltable_materials)
*/

/obj/item/place_melted_product(list/meltable_materials)

	// Create the thing and copy over relevant info.
	var/obj/item/melted_thing/melty_thing = new(null, material?.type)
	melty_thing.name        = "half-melted [name]"
	melty_thing.w_class     = w_class
	melty_thing.desc        = "[melty_thing.desc] It looks like it was once \a [src]."
	melty_thing.matter      = matter?.Copy() // avoid mutation
	LAZYCLEARLIST(matter)

	// Start it cooking for next time.
	melty_thing.temperature = temperature
	QUEUE_TEMPERATURE_ATOM(melty_thing)

	melty_thing.forceMove(loc)

	// Destroy the old thing.
	qdel(src)
	// This will be recursive if the melty thing does not override this proc.
	return melty_thing.handle_melting(meltable_materials)

// This object is sort of a placeholder for a more nuanced melting and item damage system.
// The idea is if your gun is half-melted it should not function as a gun anymore.
/obj/item/melted_thing
	name = "melted thing"
	desc = "A half-melted object of some kind."
	icon = 'icons/obj/melted_thing.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/slag
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/melted_thing/handle_melting(var/list/meltable_materials)
	SHOULD_CALL_PARENT(FALSE)
	if(!LAZYLEN(matter) || !LAZYLEN(meltable_materials))
		return // Nothing to melt, don't automatically destroy non-matter objects here.
	var/remaining_volume = loc?.get_reagent_space() ||  0
	for(var/decl/material/melt_material as anything in meltable_materials)
		var/melting_amount = max(1, max(min(matter[melt_material.type], round(remaining_volume / REAGENT_UNITS_PER_MATERIAL_UNIT)), SHEET_MATERIAL_AMOUNT))
		// Remove matter.
		matter[melt_material.type] -= melting_amount
		if(matter[melt_material.type] <= 0)
			LAZYREMOVE(matter, melt_material.type)
		// Add The Goo:tm: to our loc's reagents via a tracking var.
		var/melted_result = melting_amount * REAGENT_UNITS_PER_MATERIAL_UNIT
		if(remaining_volume > 0)
			loc.add_to_reagents(melt_material.type, melted_result)
			remaining_volume = loc.get_reagent_space()
		// If our loc is full, spill into our loc's loc (could probably be handled by a recursive helper?)
		else if(loc?.loc)
			melted_result = min(melted_result, loc.loc.get_reagent_space())
			if(melted_result)
				loc.loc.add_to_reagents(melt_material.type, melted_result)
	// If we've melted all our matter, destroy the object.
	if(!LAZYLEN(matter) && !QDELETED(src))
		material = null
		physically_destroyed()
