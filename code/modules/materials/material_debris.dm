/obj/item/debris
	is_spawnable_type = FALSE
	abstract_type = /obj/item/debris
	icon = 'icons/obj/debris.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/debris/scraps
	name = "scraps"
	desc = "A small pile of tailings and scraps."

/obj/item/debris/scraps/proc/update_primary_material()

	var/list/mat_names = list()
	var/highest_mat
	for(var/mat in matter)
		if(!highest_mat || matter[highest_mat] < matter[mat])
			highest_mat = mat
		var/decl/material/material_decl = GET_DECL(mat)
		mat_names += material_decl.solid_name

	if(!highest_mat)
		qdel(src)
	else
		material = GET_DECL(highest_mat)
		name     = "[english_list(mat_names)] [initial(name)]"
		color    = material.color

/obj/item/debris/scraps/attack_self(mob/user)

	// We can only split up scraps that are pure.
	if(length(matter) == 1)
		var/decl/material/split_material = GET_DECL(matter[1])
		var/sheet_amount = round(matter[split_material.type] / SHEET_MATERIAL_AMOUNT)
		if(sheet_amount < 1)
			to_chat(user, SPAN_WARNING("There is not enough [split_material.solid_name] to shape into lumps."))
			return TRUE
		var/obj/item/stack/material/lump/lumps = new(get_turf(user), sheet_amount, split_material.type)
		matter[split_material.type] -= sheet_amount * SHEET_MATERIAL_AMOUNT
		if(matter[split_material.type] <= 0)
			qdel(src)
		to_chat(user, SPAN_NOTICE("You separate the [split_material.solid_name] into [sheet_amount] lump\s."))
		user.put_in_hands(lumps)
		return TRUE

	return ..()

/obj/item/debris/scraps/attackby(obj/item/W, mob/user)
	if(istype(W, type) && user.try_unequip(W))
		LAZYINITLIST(matter)
		for(var/mat in W.matter)
			matter[mat] += W.matter[mat]
		UNSETEMPTY(matter)
		W.matter = null
		W.material = null
		to_chat(user, SPAN_NOTICE("You combine \the [src] and \the [W]."))
		qdel(W)
		update_primary_material()
		user.put_in_hands(src)
		return TRUE
	. = ..()

// Override as squashing items produces this item type.
/obj/item/debris/scraps/squash_item(skip_qdel = FALSE)
	return

// This object is sort of a placeholder for a more nuanced melting and item damage system.
// The idea is if your gun is half-melted it should not function as a gun anymore.
/obj/item/debris/melted
	name = "melted thing"
	desc = "A half-melted object of some kind."
	material = /decl/material/solid/slag

/obj/item/debris/melted/handle_melting(var/list/meltable_materials)
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
