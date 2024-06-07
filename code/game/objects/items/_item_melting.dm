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

	// Temp gate until generalized temperature-based melting works properly.
	if(istype(loc, /obj/item/chems/crucible))
		// Check if this is meltable at all.
		var/list/meltable_materials
		for(var/mat in matter)
			var/decl/material/melt_material = GET_DECL(mat)
			if(!isnull(melt_material.melting_point) && temperature >= melt_material.melting_point)
				LAZYDISTINCTADD(meltable_materials, melt_material)
		if(length(meltable_materials))
			. = null // Don't return PROCESS_KILL here.
			handle_melting(meltable_materials)

/obj/item/place_melted_product(list/meltable_materials)

	// Create the thing and copy over relevant info.
	var/obj/item/debris/melted/melty_thing = new(null, material?.type)
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
