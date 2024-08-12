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

	var/total_matter = 0

	for(var/mat in matter)
		var/mat_amt = matter[mat]
		if(!highest_mat || matter[highest_mat] < mat_amt)
			highest_mat = mat
		var/decl/material/material_decl = GET_DECL(mat)
		mat_names += material_decl.solid_name
		total_matter += mat_amt

	// Safety check, although this should be prevented for player side interactions
	if(total_matter > MAX_SCRAP_MATTER)
		var/divisor = ceil(total_matter / MAX_SCRAP_MATTER)
		var/list/matter_per_pile = list()

		for(var/mat in matter)
			matter_per_pile[mat] = round(matter[mat] / divisor)

		for(var/i in 1 to (divisor - 1))
			var/obj/item/debris/scraps/pile = new type(get_turf(src))
			pile.matter = matter_per_pile.Copy()
			pile.update_primary_material()

		matter = matter_per_pile

	if(!highest_mat)
		qdel(src)
	else
		material = GET_DECL(highest_mat)
		name     = "[english_list(mat_names)] [initial(name)]"
		color    = material.color

/obj/item/debris/scraps/proc/get_total_matter()
	. = 0
	for(var/mat in matter)
		. += matter[mat]

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
		var/obj/item/debris/scraps/other = W
		var/space_remaining = MAX_SCRAP_MATTER - get_total_matter()
		var/other_total_matter = other.get_total_matter()
		LAZYINITLIST(matter)

		if(space_remaining <= 0)
			to_chat(user, SPAN_WARNING("You can't add any more material to \the [src]!"))
			user.put_in_hands(other)
			return TRUE

		else if(space_remaining >= other_total_matter)
			for(var/mat in other.matter)
				matter[mat] += other.matter[mat]

			other.matter = null
			other.material = null
			to_chat(user, SPAN_NOTICE("You combine \the [src] and \the [other]."))
			qdel(other)
			update_primary_material()
			user.put_in_hands(src)
		else
			for(var/mat in other.matter)
				var/ratio = other.matter[mat] / other_total_matter
				matter[mat] += round(space_remaining*ratio)
				other.matter[mat]  -= round(space_remaining*ratio)

			to_chat(user, SPAN_NOTICE("You partially combine \the [src] and \the [other]."))
			update_primary_material()
			other.update_primary_material()
			if(!QDELETED(other))
				user.put_in_hands(other)

		UNSETEMPTY(matter)

		return TRUE
	. = ..()

// Override as squashing items produces this item type.
/obj/item/debris/scraps/squash_item(skip_qdel = FALSE)
	return

// Physical object for holding solid reagents which are out of solution or slurry.
/obj/item/debris/scraps/chemical
	desc = "A pile of dust and small filings."

	// Track this to stop endless creation and deletion while fluids settle.
	var/time_created

/obj/item/debris/scraps/chemical/Initialize(ml, material_key)
	. = ..()
	time_created = REALTIMEOFDAY

/obj/item/debris/scraps/chemical/fluid_act(datum/reagents/fluids)
	SHOULD_CALL_PARENT(FALSE)

	if(!istype(loc, /turf))
		return
	if((REALTIMEOFDAY - time_created) < 5 SECONDS)
		return
	if(!QDELETED(src) && fluids?.total_liquid_volume >= FLUID_SLURRY)
		var/free_space = REAGENTS_FREE_SPACE(fluids)
		for(var/matter_type in matter)
			if(free_space <= MINIMUM_CHEMICAL_VOLUME)
				break
			var/reagents_added = min(free_space, MATERIAL_UNITS_TO_REAGENTS_UNITS(matter[matter_type]))
			fluids.add_reagent(matter_type, reagents_added, defer_update = TRUE, phase = MAT_PHASE_SOLID)
			matter[matter_type] -= reagents_added/REAGENT_UNITS_PER_MATERIAL_UNIT
			if(matter[matter_type] <= 0)
				matter -= matter_type

			free_space -= reagents_added

		fluids.handle_update()
		update_primary_material()

/obj/item/debris/scraps/chemical/afterattack(atom/target, mob/user, proximity)
	if(!ATOM_IS_OPEN_CONTAINER(target) || !proximity || !target.reagents)
		return ..()

	var/free_space = target.get_reagent_space()
	if(free_space <= 0)
		to_chat(user, SPAN_WARNING("\The [target] is full!"))
		return FALSE

	var/total_matter = get_total_matter()

	for(var/matter_type in matter)
		if(free_space <= MINIMUM_CHEMICAL_VOLUME)
			break

		var/adj_mat_amt = min(1, (free_space/REAGENT_UNITS_PER_MATERIAL_UNIT)/total_matter)*matter[matter_type]
		var/reagents_added = max(min(free_space, MATERIAL_UNITS_TO_REAGENTS_UNITS(adj_mat_amt)), MINIMUM_CHEMICAL_VOLUME)
		target.reagents.add_reagent(matter_type, reagents_added, defer_update = TRUE, phase = MAT_PHASE_SOLID)
		matter[matter_type] -= reagents_added/REAGENT_UNITS_PER_MATERIAL_UNIT
		if(matter[matter_type] <= 0)
			matter -= matter_type

		free_space -= reagents_added

	if(!length(matter))
		to_chat(user, SPAN_NOTICE("You carefully dump \the [src] into \the [target]."))
		user?.drop_from_inventory(src)
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You carefully dump some of \the [src] into \the [target]."))
		update_primary_material()

	playsound(src, 'sound/effects/refill.ogg', 25, 1)
	return TRUE

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