// This object is sort of a placeholder for a more nuanced melting and item damage system.
// The idea is if your gun is half-melted it should not function as a gun anymore.
/obj/item/scrap_material
	name = "scraps"
	desc = "Tailings and scraps left over from something."
	icon = 'icons/obj/melted_thing.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/slag
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/scrap_material/melted
	name = "melted thing"
	desc = "A half-melted object of some kind."

/obj/item/scrap_material/handle_melting(var/list/meltable_materials)
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
