var/global/obj/temp_reagents_holder = new
var/global/datum/reagents/sink/infinite_reagent_sink = new

/atom/proc/add_to_reagents(decl/material/reagent, amount, data, safety = FALSE, defer_update = FALSE, phase = null)
	return reagents?.add_reagent(reagent, amount, data, safety, defer_update, phase)

/atom/proc/remove_from_reagents(decl/material/reagent, amount, safety = FALSE, defer_update = FALSE)
	return reagents?.remove_reagent(reagent, amount, safety, defer_update)

/atom/proc/remove_any_reagents(amount = 1, defer_update = FALSE, removed_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID), skip_reagents = null)
	return reagents?.remove_any(amount, defer_update, removed_phases, skip_reagents)

/// Adds reagents, but contaminated. A fraction of `amount` is replaced with `contaminant_type` according to `contaminant_proportion`.
/// Handles null contaminant_type and zero contaminant_proportion, but it's probably faster to check before you call this.
/atom/proc/add_to_reagents_contaminated(reagent_type, amount, data, contaminant_type = null, contaminant_proportion = 0, safety = FALSE, defer_update = FALSE, phase = null)
	var/contaminant_to_add = 0
	if(contaminant_type)
		contaminant_to_add = CHEMS_QUANTIZE(amount * contaminant_proportion)
	add_to_reagents(reagent_type, amount - contaminant_to_add, data, safety = safety, defer_update = !!contaminant_to_add, phase = MAT_PHASE_LIQUID)
	if(contaminant_to_add)
		add_to_reagents(contaminant_type, contaminant_to_add, phase = MAT_PHASE_LIQUID)

/atom/proc/get_reagent_space()
	if(!REAGENT_MAXIMUM_VOLUME(reagents))
		return 0
	return REAGENT_MAXIMUM_VOLUME(reagents) - REAGENT_TOTAL_VOLUME(reagents)

/atom/proc/get_reagents()
	return reagents

/atom/proc/take_waste_burn_products(list/materials, exposed_temperature, ambient_pressure)

	// This might not be needed. Leaving it in for safety.
	var/turf/T = get_turf(src)
	if(T != src)
		return T?.take_waste_burn_products(materials, exposed_temperature, ambient_pressure)

	var/datum/reagents/liquids
	var/datum/gas_mixture/vapor
	var/obj/item/debris/scraps/scraps
	for(var/mat in materials)
		var/amount = materials[mat]
		var/decl/material/burn_material = GET_DECL(mat)
		switch(burn_material.phase_at_temperature(exposed_temperature, ambient_pressure))

			if(MAT_PHASE_SOLID)
				if(!scraps)
					scraps = (locate() in src) || new(src)
					LAZYINITLIST(scraps.matter)
				scraps.matter[mat] += amount

			if(MAT_PHASE_LIQUID)
				if(!liquids)
					liquids = get_reagents()
				liquids?.add_reagent(mat, max(1, round(amount * REAGENT_UNITS_PER_MATERIAL_UNIT)), defer_update = TRUE)

			if(MAT_PHASE_GAS)
				if(!vapor)
					vapor = return_air()
				vapor?.adjust_gas_temp(mat, MOLES_PER_MATERIAL_UNIT(amount), exposed_temperature, update = FALSE)

	if(scraps)
		UNSETEMPTY(scraps.matter)
		scraps.update_primary_material()
	vapor?.update_values()
	liquids?.update_total()

// These vars are privated due to the potential for reagents to be either null, a list, or a datum.
// Always use the REAGENT_FOO macros!
/datum/reagents
	VAR_PRIVATE/list/reagent_volumes
	VAR_PRIVATE/list/liquid_volumes
	VAR_PRIVATE/list/solid_volumes // This should be taken as powders/flakes, rather than large solid pieces of material.
	VAR_PRIVATE/list/reagent_data
	VAR_PRIVATE/atom/my_atom
	VAR_PRIVATE/maximum_volume = 120
	VAR_PRIVATE/tmp/cached_color
	VAR_PRIVATE/tmp/primary_reagent
	VAR_PRIVATE/tmp/primary_solid
	VAR_PRIVATE/tmp/primary_liquid
	VAR_PRIVATE/tmp/total_volume = 0
	VAR_PRIVATE/tmp/total_liquid_volume // Used to determine when to create fluids in the world and the like.

// Reagent serde is handled per atom.
/datum/reagents/ShouldSerialize(_age)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/datum/reagents/New(var/maximum_volume = 120, var/atom/my_atom)
	src.maximum_volume = maximum_volume
	src.my_atom = my_atom
	..()

/datum/reagents/Destroy()
	. = ..()
	UNQUEUE_REACTIONS(src) // While marking for reactions should be avoided just before deleting if possible, the async nature means it might be impossible.
	if(SSfluids.holders_to_update[src])
		SSfluids.holders_to_update -= src
	reagent_volumes = null

	liquid_volumes = null
	solid_volumes = null

	reagent_data = null
	if(my_atom)
		if(my_atom.reagents == src)
			my_atom.reagents = null
			if(total_volume > 0) // we can assume 0 reagents and null reagents are broadly identical for the purposes of atom logic
				my_atom.try_on_reagent_change()
		my_atom = null

/datum/reagents/GetCloneArgs()
	return list(maximum_volume, global.temp_reagents_holder) //Always clone with the dummy holder to prevent things being done on the owner atom

//Don't forget to call set_holder() after getting the copy!
/datum/reagents/PopulateClone(datum/reagents/clone)
	clone.primary_reagent = primary_reagent
	clone.reagent_volumes = reagent_volumes?.Copy()
	clone.liquid_volumes  = liquid_volumes?.Copy()
	clone.solid_volumes   = solid_volumes?.Copy()
	clone.reagent_data    = listDeepClone(reagent_data, TRUE)
	clone.total_volume    = total_volume
	clone.maximum_volume  = maximum_volume
	clone.cached_color    = cached_color
	return clone

/datum/reagents/proc/get_reaction_loc(chemical_reaction_flags)
	if((chemical_reaction_flags & CHEM_REACTION_FLAG_OVERFLOW_CONTAINER) && my_atom.reaction_can_overflow())
		return get_turf(my_atom)
	return my_atom

/datum/reagents/proc/get_primary_reagent_name(var/codex = FALSE) // Returns the name of the reagent with the biggest volume.
	var/decl/material/reagent = get_primary_reagent_decl()
	if(reagent)
		if(codex && reagent.codex_name)
			. = reagent.codex_name
		else
			if(LIQUID_VOLUME(src, reagent.type) >= SOLID_VOLUME(src, reagent.type))
				return reagent.get_reagent_name(src, MAT_PHASE_LIQUID)
			else
				return reagent.get_reagent_name(src, MAT_PHASE_SOLID)

/datum/reagents/proc/get_primary_reagent_type()
	return primary_reagent

/datum/reagents/proc/get_primary_reagent_decl()
	return RESOLVE_TO_DECL(primary_reagent)

/datum/reagents/proc/update_total() // Updates volume.
	total_volume = 0
	total_liquid_volume = 0
	primary_reagent = null

	reagent_volumes = list()
	primary_liquid = null
	for(var/decl/material/reagent as anything in liquid_volumes)
		var/vol = CHEMS_QUANTIZE(liquid_volumes[reagent])
		if(vol < MINIMUM_CHEMICAL_VOLUME)
			clear_reagent(reagent, defer_update = TRUE, force = TRUE) // defer_update is important to avoid infinite recursion
		else
			LAZYSET(liquid_volumes, reagent, vol)
			LAZYSET(reagent_volumes, reagent, vol)
			total_volume += vol
			total_liquid_volume += vol
			if(!primary_liquid || liquid_volumes[primary_liquid] < vol)
				primary_liquid = reagent

	primary_solid = null
	for(var/decl/material/reagent as anything in solid_volumes)
		var/vol = CHEMS_QUANTIZE(solid_volumes[reagent])
		if(vol < MINIMUM_CHEMICAL_VOLUME)
			clear_reagent(reagent, defer_update = TRUE, force = TRUE)
		else
			LAZYSET(solid_volumes, reagent, vol)
			if(!reagent_volumes?[reagent])
				LAZYSET(reagent_volumes, reagent, vol)
			else
				reagent_volumes[reagent] += vol
			total_volume += vol
			if(!primary_solid || (solid_volumes[primary_solid] < vol))
				primary_solid = reagent

	if(solid_volumes?[primary_solid] > liquid_volumes?[primary_liquid])
		primary_reagent = primary_solid
	else // By default, take the primary_liquid as the primary_reagent.
		primary_reagent = primary_liquid

	UNSETEMPTY(reagent_volumes)

	if(total_volume > maximum_volume)
		remove_any(total_volume-maximum_volume)


/datum/reagents/proc/process_reactions()

	var/atom/location = get_reaction_loc()
	var/check_flags = location?.atom_flags || 0

	if((check_flags & ATOM_FLAG_NO_REACT) && (check_flags & ATOM_FLAG_NO_PHASE_CHANGE) && (check_flags & ATOM_FLAG_NO_DISSOLVE))
		return 0

	var/reaction_occurred = FALSE
	var/list/eligible_reactions = list()

	var/temperature = location?.temperature || T20C
	for(var/decl/material/reagent as anything in reagent_volumes)

		// Check if the reagent is decaying or not.
		var/list/replace_self_with
		var/replace_message
		var/replace_sound

		if(!(check_flags & ATOM_FLAG_NO_PHASE_CHANGE))
			if(!isnull(reagent.chilling_point) && LAZYLEN(reagent.chilling_products) && temperature <= reagent.chilling_point)
				replace_self_with = reagent.chilling_products
				if(reagent.chilling_message)
					replace_message = "\The [reagent.get_reagent_name(src)] [reagent.chilling_message]"
				replace_sound = reagent.chilling_sound
			else if(!isnull(reagent.heating_point) && LAZYLEN(reagent.heating_products) && temperature >= reagent.heating_point)
				replace_self_with = reagent.heating_products
				if(reagent.heating_message)
					replace_message = "\The [reagent.get_reagent_name(src)] [reagent.heating_message]"
				replace_sound = reagent.heating_sound

		if(isnull(replace_self_with) && !isnull(reagent.dissolves_in) && !(check_flags & ATOM_FLAG_NO_DISSOLVE) && LAZYLEN(reagent.dissolves_into))
			for(var/decl/material/solvent as anything in reagent_volumes)
				if(solvent == reagent)
					continue
				if(solvent.solvent_power >= reagent.dissolves_in)
					replace_self_with = reagent.dissolves_into
					if(reagent.dissolve_message)
						replace_message = "\The [reagent.get_reagent_name(src)] [reagent.dissolve_message] \the [solvent.get_reagent_name(src)]."
					replace_sound = reagent.dissolve_sound
					break

		// If it is, handle replacing it with the decay product.
		if(replace_self_with)
			var/replace_amount = REAGENT_VOLUME(src, reagent)
			clear_reagent(reagent)
			for(var/product in replace_self_with)
				add_reagent(product, replace_self_with[product] * replace_amount)
			reaction_occurred = TRUE

			if(location)
				if(replace_message)
					location.visible_message("<span class='notice'>[html_icon(location)] [replace_message]</span>")
				if(replace_sound)
					playsound(location, replace_sound, 80, 1)

		else if(!(check_flags & ATOM_FLAG_NO_REACT)) // Otherwise, collect all possible reactions.
			eligible_reactions |= SSmaterials.chemical_reactions_by_id[reagent.type]

	if(!(check_flags & ATOM_FLAG_NO_REACT))
		var/list/active_reactions = list()

		for(var/decl/chemical_reaction/reaction in eligible_reactions)
			if(reaction.can_happen(src))
				active_reactions[reaction] = 1 // The number is going to be 1/(fraction of remaining reagents we are allowed to use), computed below
				reaction_occurred = 1

		var/list/used_reagents = list()
		// if two reactions share a reagent, each is allocated half of it, so we compute this here
		for(var/decl/chemical_reaction/reaction in active_reactions)
			var/list/adding = reaction.get_used_reagents()
			for(var/reagent in adding)
				LAZYADD(used_reagents[reagent], reaction)

		for(var/reagent in used_reagents)
			var/counter = length(used_reagents[reagent])
			if(counter <= 1)
				continue // Only used by one reaction, so nothing we need to do.
			for(var/decl/chemical_reaction/reaction in used_reagents[reagent])
				active_reactions[reaction] = max(counter, active_reactions[reaction])
				counter-- //so the next reaction we execute uses more of the remaining reagents
				// Note: this is not guaranteed to maximize the size of the reactions we do (if one reaction is limited by reagent A, we may be over-allocating reagent B to it)
				// However, we are guaranteed to fully use up the most profligate reagent if possible.
				// Further reactions may occur on the next tick, when this runs again.

		for(var/decl/chemical_reaction/reaction as anything in active_reactions)
			reaction.process(src, active_reactions[reaction])

		for(var/decl/chemical_reaction/reaction as anything in active_reactions)
			reaction.post_reaction(src)

	update_total()

	if(reaction_occurred)
		HANDLE_REACTIONS(src) // Check again in case the new reagents can react again

	return reaction_occurred

/* Holder-to-chemical */
/datum/reagents/proc/handle_update(var/safety)
	if(QDELETED(src))
		return
	SSfluids.holders_to_update -= src
	update_total()
	if(!safety)
		HANDLE_REACTIONS(src)
	my_atom?.try_on_reagent_change()

///Set and call updates on the target holder.
/datum/reagents/proc/set_holder(var/obj/new_holder)
	if(my_atom == new_holder)
		return
	my_atom = new_holder
	my_atom?.try_on_reagent_change()
	handle_update()

/datum/reagents/proc/add_reagent(var/decl/material/reagent, var/amount, var/data = null, var/safety = 0, var/defer_update = FALSE, var/phase)

	amount = CHEMS_QUANTIZE(min(amount, REAGENTS_FREE_SPACE(src)))
	if(amount <= 0)
		return FALSE

	reagent = RESOLVE_TO_DECL(reagent)
	if(!istype(reagent))
		return FALSE

	if(!phase)
		// By default, assume the reagent phase at STP.
		phase = reagent.phase_at_temperature()
		// Assume it's in solution, somehow.
		if(phase == MAT_PHASE_GAS)
			phase = MAT_PHASE_LIQUID

	var/list/phase_volumes
	if(phase == MAT_PHASE_LIQUID)
		LAZYINITLIST(liquid_volumes)
		phase_volumes = liquid_volumes
	else
		LAZYINITLIST(solid_volumes)
		phase_volumes = solid_volumes

	if(!phase_volumes[reagent])
		phase_volumes[reagent] = amount
	else
		phase_volumes[reagent] += amount

	LAZYINITLIST(reagent_volumes)
	if(!reagent_volumes[reagent])
		reagent_volumes[reagent] = amount
		var/tmp_data = reagent.initialize_data(data)
		if(tmp_data)
			LAZYSET(reagent_data, reagent, tmp_data)
		if(reagent_volumes.len == 1) // if this is the first reagent, uncache color
			cached_color = null
	else
		reagent_volumes[reagent] += amount
		if(!isnull(data))
			LAZYSET(reagent_data, reagent, reagent.mix_data(src, data, amount))
	if(reagent_volumes.len > 1) // otherwise if we have a mix of reagents, uncache as well
		cached_color = null

	UNSETEMPTY(reagent_volumes)
	UNSETEMPTY(phase_volumes)

	if(defer_update)
		total_volume = clamp(total_volume + amount, 0, maximum_volume) // approximation, call update_total() if deferring
	else
		handle_update(safety)
	return TRUE

/datum/reagents/proc/remove_reagent(var/decl/material/reagent, var/amount, var/safety = 0, var/defer_update = FALSE, var/removed_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	amount = CHEMS_QUANTIZE(amount)
	if(!isnum(amount) || amount <= 0 || REAGENT_VOLUME(src, reagent) <= 0)
		return FALSE

	reagent = RESOLVE_TO_DECL(reagent)
	if(!istype(reagent))
		return FALSE

	var/removed = 0
	if((removed_phases & MAT_PHASE_LIQUID) && LIQUID_VOLUME(src, reagent) > 0)

		removed += min(liquid_volumes[reagent], amount)
		liquid_volumes[reagent] -= removed

	// If both liquid and solid reagents are being removed, we prioritize the liquid reagents.
	if((removed < amount) && (removed_phases & MAT_PHASE_SOLID) && SOLID_VOLUME(src, reagent) > 0)

		var/solid_removed = min(solid_volumes[reagent], amount - removed)
		solid_volumes[reagent] -= solid_removed

		removed += solid_removed

	if(removed == 0)
		return FALSE

	// If removed < amount, a reagent has been removed completely from a state, so uncache the color.
	if((LAZYLEN(liquid_volumes) > 1 || LAZYLEN(solid_volumes) > 1) || (removed < amount))
		cached_color = null
	if(defer_update)
		total_volume = clamp(total_volume - removed, 0, maximum_volume) // approximation, call update_total() if deferring
	else
		handle_update(safety)
	return TRUE

/datum/reagents/proc/clear_reagent(var/decl/material/reagent, var/defer_update = FALSE, var/force = FALSE)

	reagent = RESOLVE_TO_DECL(reagent)
	if(!istype(reagent))
		return FALSE

	. = force || !!REAGENT_DATA(src, reagent) || !!REAGENT_VOLUME(src, reagent)
	if(.)

		var/amount = LAZYACCESS(reagent_volumes, reagent)
		LAZYREMOVE(liquid_volumes, reagent)
		LAZYREMOVE(solid_volumes, reagent)

		LAZYREMOVE(reagent_volumes, reagent)
		LAZYREMOVE(reagent_data, reagent)
		if(primary_reagent == reagent)
			primary_reagent = null
		if(primary_liquid == reagent)
			primary_liquid = null
		if(primary_solid == reagent)
			primary_solid = null
		cached_color = null

		if(defer_update)
			total_volume = clamp(total_volume - amount, 0, maximum_volume) // approximation, call update_total() if deferring
		else
			handle_update()

/datum/reagents/proc/has_reagent(var/decl/material/reagent, var/amount, var/phases)
	. = 0
	reagent = RESOLVE_TO_DECL(reagent)
	if(!istype(reagent))
		return
	if(phases)
		if(phases & MAT_PHASE_SOLID)
			. += SOLID_VOLUME(src, reagent)
		if(phases & MAT_PHASE_LIQUID)
			. += LIQUID_VOLUME(src, reagent)
	else
		. = REAGENT_VOLUME(src, reagent)
	if(. && amount)
		. = (. >= amount)

/datum/reagents/proc/has_any_reagent(var/list/check_reagents, var/phases)
	for(var/check in check_reagents)
		if(has_reagent(check, check_reagents[check], phases))
			return TRUE
	return FALSE

/datum/reagents/proc/has_all_reagents(var/list/check_reagents, var/phases)
	. = TRUE
	for(var/check in check_reagents)
		. = min(., has_reagent(RESOLVE_TO_DECL(check), check_reagents[check], phases))
		if(!.)
			return

/datum/reagents/proc/clear_reagents()
	for(var/decl/material/reagent as anything in reagent_volumes)
		clear_reagent(reagent, defer_update = TRUE)

	LAZYCLEARLIST(liquid_volumes)
	LAZYCLEARLIST(solid_volumes)
	LAZYCLEARLIST(reagent_volumes)
	LAZYCLEARLIST(reagent_data)
	total_volume = 0
	my_atom?.try_on_reagent_change()

/datum/reagents/proc/get_overdose(var/decl/material/reagent)
	if(reagent)
		return initial(reagent.overdose)
	return 0

/datum/reagents/proc/get_reagents(scannable_only = 0, precision)
	. = list()
	for(var/decl/material/reagent as anything in liquid_volumes)
		if(scannable_only && !reagent.scannable)
			continue
		var/scan_volume = REAGENT_VOLUME(src, reagent)
		if(precision)
			scan_volume = round(scan_volume, precision)
		if(scan_volume)
			. += "[reagent.get_reagent_name(src, MAT_PHASE_LIQUID)] ([scan_volume])"
	for(var/decl/material/reagent as anything in solid_volumes)
		if(scannable_only && !reagent.scannable)
			continue
		var/scan_volume = REAGENT_VOLUME(src, reagent)
		if(precision)
			scan_volume = round(scan_volume, precision)
		if(scan_volume)
			. += "[reagent.get_reagent_name(src, MAT_PHASE_SOLID)] ([scan_volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/datum/reagents/proc/get_dirtiness()
	for(var/decl/material/reagent as anything in reagent_volumes)
		. += reagent.dirtiness
	return . / length(reagent_volumes)

/datum/reagents/proc/get_accelerant_value()
	for(var/decl/material/reagent as anything in reagent_volumes)
		. += reagent.accelerant_value
	return . / length(reagent_volumes)

/* Holder-to-holder and similar procs */
/// Removes up to [amount] of reagents from [src]. Returns actual amount removed.
/datum/reagents/proc/remove_any(var/amount = 1, var/defer_update = FALSE, var/removed_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID), skip_reagents = null)

	if(amount <= 0)
		return 0

	if(skip_reagents) // use the infinite sink for this
		return trans_to_holder(global.infinite_reagent_sink, amount, skip_reagents = skip_reagents, transferred_phases = removed_phases)

	// The list we're iterating over to remove reagents.
	var/list/removing_volumes
	var/removing_volumes_total
	// Shortcut if we're removing both liquids and solids (most cases).
	if((removed_phases & MAT_PHASE_LIQUID) && (removed_phases & MAT_PHASE_SOLID))
		if(amount >= total_volume)
			. = total_volume
			clear_reagents()
			return

		removing_volumes = reagent_volumes
		removing_volumes_total = total_volume

	else if(removed_phases & MAT_PHASE_LIQUID)
		if(!LAZYLEN(liquid_volumes))
			return 0

		removing_volumes = liquid_volumes
		removing_volumes_total = total_liquid_volume

	else if(removed_phases & MAT_PHASE_SOLID)
		if(!LAZYLEN(solid_volumes))
			return 0

		removing_volumes = solid_volumes
		removing_volumes_total = total_volume - total_liquid_volume
	else
		return 0

	var/removing = clamp(CHEMS_QUANTIZE(amount), 0, total_volume) // not ideal but something is making total_volume become NaN
	if(!removing || total_volume <= 0)
		. = 0
		clear_reagents()
		return

	// Some reagents may be too low to remove from, so do multiple passes.
	. = 0
	var/part = removing / removing_volumes_total
	var/failed_remove = FALSE
	while(removing >= MINIMUM_CHEMICAL_VOLUME && total_volume >= MINIMUM_CHEMICAL_VOLUME && !failed_remove)
		failed_remove = TRUE
		for(var/decl/material/reagent as anything in removing_volumes)
			var/removing_amt = min(CHEMS_QUANTIZE(removing_volumes[reagent] * part), removing)
			if(removing_amt <= 0)
				continue
			failed_remove = FALSE
			removing -= removing_amt
			. += removing_amt
			remove_reagent(reagent, removing_amt, TRUE, TRUE, removed_phases = removed_phases)

	if(!defer_update)
		handle_update()

// Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier].
// Returns actual amount removed from [src] (not amount transferred to [target]).
// Use safety = 1 for temporary targets to avoid queuing them up for processing.
// Reagent phases are preserved.
/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/safety = 0, var/defer_update = FALSE, var/list/skip_reagents, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))

	if(!target || !istype(target))
		return 0

	amount = max(0, min(amount, total_volume, REAGENTS_FREE_SPACE(target) / multiplier))
	if(!amount)
		return 0

	var/part = amount
	if(skip_reagents)
		var/using_volume = total_volume
		for(var/reagent in skip_reagents)
			using_volume -= LAZYACCESS(reagent_volumes, reagent)
		if(using_volume <= 0)
			return 0
		part /= using_volume
	else
		var/using_volume = total_volume
		if(!(transferred_phases & MAT_PHASE_LIQUID))
			using_volume -= total_liquid_volume
		else if(!(transferred_phases & MAT_PHASE_SOLID))
			using_volume = total_liquid_volume
		part /= using_volume

	. = 0
	for(var/decl/material/reagent as anything in reagent_volumes - skip_reagents)
		var/amount_to_transfer = CHEMS_QUANTIZE(REAGENT_VOLUME(src, reagent) * part)

		// Prioritize liquid transfers
		if(transferred_phases & MAT_PHASE_LIQUID)
			var/liquid_transferred = min(amount_to_transfer, CHEMS_QUANTIZE(LIQUID_VOLUME(src, reagent)))
			target.add_reagent(reagent, liquid_transferred * multiplier, REAGENT_DATA(src, reagent), TRUE, TRUE, MAT_PHASE_LIQUID)  // We don't react until everything is in place

			. += liquid_transferred
			amount_to_transfer -= liquid_transferred

			if(!copy)
				remove_reagent(reagent, liquid_transferred, TRUE, TRUE, MAT_PHASE_LIQUID)

		if(transferred_phases & MAT_PHASE_SOLID)
			var/solid_transferred = (min(amount_to_transfer, CHEMS_QUANTIZE(SOLID_VOLUME(src, reagent))))
			target.add_reagent(reagent, solid_transferred * multiplier, REAGENT_DATA(src, reagent), TRUE, TRUE, MAT_PHASE_SOLID)  // Ditto
			. += solid_transferred
			amount_to_transfer -= solid_transferred

			if(!copy)
				remove_reagent(reagent, solid_transferred, TRUE, TRUE, MAT_PHASE_SOLID)


	// Due to rounding, we may have taken less than we wanted.
	// If we're up short, add the remainder taken from the primary reagent.
	// If we're skipping the primary reagent we just don't do this step.
	if(. < amount)
		var/remainder = CHEMS_QUANTIZE(amount - .)

		var/liquid_remainder
		if((transferred_phases & MAT_PHASE_LIQUID) && primary_liquid && !(primary_liquid in skip_reagents) && LIQUID_VOLUME(src, primary_liquid) > 0)
			liquid_remainder = min(remainder, LIQUID_VOLUME(src, primary_liquid))
		var/solid_remainder
		if((transferred_phases & MAT_PHASE_SOLID) && primary_solid && !(primary_solid in skip_reagents) && SOLID_VOLUME(src, primary_solid) > 0)
			solid_remainder = min(remainder - liquid_remainder, SOLID_VOLUME(src, primary_solid))

		if(liquid_remainder > 0)
			target.add_reagent(primary_reagent, liquid_remainder * multiplier, REAGENT_DATA(src, primary_reagent), TRUE, TRUE, MAT_PHASE_LIQUID)
			. += liquid_remainder
			remainder -= liquid_remainder
		if(solid_remainder > 0)
			target.add_reagent(primary_reagent, solid_remainder * multiplier, REAGENT_DATA(src, primary_reagent), TRUE, TRUE, MAT_PHASE_SOLID)
			. += solid_remainder
			remainder -= solid_remainder
		if(!copy)
			if(liquid_remainder > 0)
				remove_reagent(primary_reagent, liquid_remainder, TRUE, TRUE, MAT_PHASE_LIQUID)
			if(solid_remainder > 0)
				remove_reagent(primary_reagent, solid_remainder, TRUE, TRUE, MAT_PHASE_SOLID)

	if(!defer_update)
		target.handle_update(safety)
		handle_update(safety)
		if(!copy)
			HANDLE_REACTIONS(src)

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	if(ismob(target))
		touch_mob(target)
		if(QDELETED(target))
			return 0
		return splash_mob(target, amount, copy, defer_update = defer_update)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
	if(isobj(target))
		touch_obj(target)
		if(!QDELETED(target) && target.can_be_poured_into(my_atom))
			return trans_to_obj(target, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
		return 0
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well. All phases are transferred by default
/datum/reagents/proc/splash(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/min_spill=0, var/max_spill=60, var/defer_update = FALSE)

	if(!istype(target))
		return

	if(isturf(target))
		trans_to_turf(target, amount, multiplier, copy, defer_update = defer_update)
		return

	if(isturf(target.loc) && min_spill && max_spill)
		var/spill = floor(amount*(rand(min_spill, max_spill)/100))
		if(spill)
			amount -= spill
			trans_to_turf(target.loc, spill, multiplier, copy, defer_update)
	if(amount)
		trans_to(target, amount, multiplier, copy, defer_update = defer_update)

//Spreads the contents of this reagent holder all over the vicinity of the target turf.
/datum/reagents/proc/splash_area(var/turf/epicentre, var/range = 3, var/portion = 1.0, var/multiplier = 1, var/copy = 0)
	var/list/things = list()
	DVIEW(things, range, epicentre, INVISIBILITY_LIGHTING)

	var/list/turfs = list()
	for (var/turf/T in things)
		turfs += T

	if (!turfs.len)
		return//Nowhere to splash to, somehow

	//Create a temporary holder to hold all the amount that will be spread
	var/datum/reagents/reagent = new /datum/reagents(total_volume * portion * multiplier, global.temp_reagents_holder)
	trans_to_holder(reagent, total_volume * portion, multiplier, copy)

	//The exact amount that will be given to each turf
	var/turfportion = reagent.total_volume / turfs.len
	for (var/turf/T in turfs)
		reagent.splash_turf(T, amount = turfportion, multiplier = 1, copy = FALSE)
	qdel(reagent)

//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever's left on the turf itself
/datum/reagents/proc/splash_turf(var/turf/T, var/amount = null, var/multiplier = 1, var/copy = 0)
	if (isnull(amount))
		amount = total_volume
	else
		amount = min(amount, total_volume)
	if (amount <= 0)
		return

	var/list/mobs = list()
	for (var/mob/M in T)
		mobs += M

	var/list/objs = list()
	for (var/obj/O in T)
		//Todo: Add some check here to not hit wires/pipes that are hidden under floor tiles.
		//Maybe also not hit things under tables.
		objs += O

	if (objs.len)
		var/objportion = (amount * 0.2) / objs.len
		for (var/o in objs)
			var/obj/O = o

			trans_to(O, objportion, multiplier, copy)

	amount = min(amount, total_volume)

	if (mobs.len)
		var/mobportion = (amount * 0.5) / mobs.len
		for (var/m in mobs)
			var/mob/M = m
			trans_to(M, mobportion, multiplier, copy)

	trans_to(T, total_volume, multiplier, copy)

	if (total_volume <= 0)
		qdel(src)

/datum/reagents/proc/trans_type_to(var/atom/target, var/type, var/amount = 1, var/multiplier = 1, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	if (!target || !target.reagents || !target.simulated || !transferred_phases)
		return

	amount = max(0, min(amount, REAGENT_VOLUME(src, type), REAGENTS_FREE_SPACE(target.reagents) / multiplier))

	if(!amount)
		return

	// Small check for optimization.
	if (!(transferred_phases & MAT_PHASE_LIQUID))
		if(!SOLID_VOLUME(src, type))
			return

	if (!(transferred_phases & MAT_PHASE_SOLID))
		if(!LIQUID_VOLUME(src, type))
			return

	var/datum/reagents/F = new(amount, global.temp_reagents_holder)

	var/amount_remaining = amount

	// Prioritize liquid transfers.
	if(transferred_phases & MAT_PHASE_LIQUID)
		var/liquid_transferred = NONUNIT_FLOOR(min(amount_remaining, LIQUID_VOLUME(src, type)), MINIMUM_CHEMICAL_VOLUME)
		F.add_reagent(type, liquid_transferred, REAGENT_DATA(src, type), defer_update = TRUE, phase = MAT_PHASE_LIQUID)
		remove_reagent(type, liquid_transferred, defer_update = TRUE, removed_phases = MAT_PHASE_LIQUID)
		amount_remaining -= liquid_transferred

	if(transferred_phases & MAT_PHASE_SOLID)
		var/solid_transferred = NONUNIT_FLOOR(min(amount_remaining, SOLID_VOLUME(src, type)), MINIMUM_CHEMICAL_VOLUME)
		F.add_reagent(type, solid_transferred, REAGENT_DATA(src, type), defer_update = TRUE, phase = MAT_PHASE_SOLID)
		remove_reagent(type, solid_transferred, defer_update = TRUE, removed_phases = MAT_PHASE_SOLID)
		amount_remaining -= solid_transferred

	// Now that both liquid and solid components are removed, we can update if necessary.
	if(!defer_update)
		handle_update()

	. = F.trans_to(target, amount, multiplier, defer_update = defer_update, transferred_phases = transferred_phases) // Let this proc check the atom's type
	qdel(F)

/datum/reagents/proc/trans_type_to_holder(var/datum/reagents/target, var/type, var/amount = 1, var/multiplier = 1, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	if (!target)
		return

	amount = max(0, min(amount, REAGENT_VOLUME(src, type), REAGENTS_FREE_SPACE(target) / multiplier))

	if(!amount)
		return

	// Small check for optimization.
	if (!(transferred_phases & MAT_PHASE_LIQUID))
		if(!SOLID_VOLUME(src, type))
			return

	if (!(transferred_phases & MAT_PHASE_SOLID))
		if(!LIQUID_VOLUME(src, type))
			return

	var/filtered_types = reagent_volumes - type
	return trans_to_holder(target, amount, multiplier, skip_reagents = filtered_types, defer_update = defer_update, transferred_phases = transferred_phases) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch procs are called to trigger any on-touch effects of the reagent.
// Options are touch_turf(), touch_mob() and touch_obj(). This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.

/datum/reagents/proc/touch_atom(atom/target, touch_atoms = TRUE)
	if(ismob(target))
		return touch_mob(target)
	if(isobj(target))
		return touch_obj(target)
	if(isturf(target))
		return touch_turf(target, touch_atoms)
	return FALSE

/datum/reagents/proc/touch_mob(mob/target)
	if(!target || !istype(target) || !target.simulated)
		return
	for(var/decl/material/reagent as anything in reagent_volumes)
		reagent.touch_mob(target, REAGENT_VOLUME(src, reagent), src)

/datum/reagents/proc/touch_turf(turf/touching_turf, touch_atoms = TRUE)

	if(!istype(touching_turf) || !touching_turf.simulated)
		return

	for(var/decl/material/reagent as anything in reagent_volumes)
		reagent.touch_turf(touching_turf, REAGENT_VOLUME(src, reagent), src)

	var/dirtiness = get_dirtiness()
	if(dirtiness <= DIRTINESS_CLEAN)
		touching_turf.clean()
		touching_turf.remove_cleanables()

	if(dirtiness > DIRTINESS_NEUTRAL)
		touching_turf.add_dirt(ceil(total_volume * dirtiness))
	else if(dirtiness < DIRTINESS_NEUTRAL)
		if(dirtiness <= DIRTINESS_STERILE)
			touching_turf.germ_level -= min(total_volume*20, touching_turf.germ_level)
			for(var/obj/item/I in touching_turf.contents)
				I.was_bloodied = null
			for(var/obj/effect/decal/cleanable/blood/B in touching_turf)
				qdel(B)
		if(dirtiness <= DIRTINESS_CLEAN)
			touching_turf.clean()

	if(touch_atoms)
		for(var/atom/movable/thing in touching_turf.get_contained_external_atoms())
			if(thing.simulated && !istype(thing, /obj/effect/effect/smoke/chem))
				touch_atom(thing)

/datum/reagents/proc/touch_obj(obj/target)
	if(!target || !istype(target) || !target.simulated)
		return
	for(var/decl/material/reagent as anything in reagent_volumes)
		reagent.touch_obj(target, REAGENT_VOLUME(src, reagent), src)

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/copy = 0, var/defer_update = FALSE)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount * perm, CHEM_TOUCH, 1, copy, defer_update = defer_update)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_INJECT, var/multiplier = 1, var/copy = 0, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID)) // Transfer after checking into which holder...
	if(!target || !istype(target) || !target.simulated)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(type == CHEM_INJECT)
			var/datum/reagents/reagent = L.get_injected_reagents()
			if(reagent)
				return trans_to_holder(reagent, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
		if(type == CHEM_INGEST)
			var/datum/reagents/reagent = L.get_ingested_reagents()
			if(reagent)
				return L.ingest(src, reagent, amount, multiplier, copy) //perhaps this is a bit of a hack, but currently there's no common proc for eating reagents
		if(type == CHEM_TOUCH)
			var/datum/reagents/reagent = L.get_contact_reagents()
			if(reagent)
				return trans_to_holder(reagent, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
		if(type == CHEM_INHALE)
			var/datum/reagents/reagent = L.get_inhaled_reagents()
			if(reagent)
				return trans_to_holder(reagent, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
	var/datum/reagents/reagent = new /datum/reagents(amount, global.temp_reagents_holder)
	. = trans_to_holder(reagent, amount, multiplier, copy, TRUE, defer_update = defer_update, transferred_phases = transferred_phases)
	reagent.touch_mob(target)
	qdel(reagent)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	if(!target?.simulated)
		return 0

	// If we're only dumping solids, and there's not enough liquid present on the turf to make a slurry, we dump the solids directly.
	// This avoids creating an unnecessary reagent holder that won't be immediately deleted.
	if((!(transferred_phases & MAT_PHASE_LIQUID) || !total_liquid_volume) && (target.reagents?.total_liquid_volume < FLUID_SLURRY))
		var/datum/reagents/reagent = new /datum/reagents(amount, global.temp_reagents_holder)
		. = trans_to_holder(reagent, amount, multiplier, copy, TRUE, defer_update = defer_update, transferred_phases = MAT_PHASE_SOLID)
		reagent.touch_turf(target)
		target.dump_solid_reagents(reagent)
		qdel(reagent)
		return

	target.create_or_update_reagents(FLUID_MAX_DEPTH)

	. = trans_to_holder(target.reagents, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)
	// Deferred updates are presumably being done by SSfluids.
	// Do an immediate fluid_act call rather than waiting for SSfluids to proc.
	if(!defer_update && REAGENT_TOTAL_VOLUME(target.reagents) >= FLUID_PUDDLE)
		target.fluid_act(target.reagents)

 // Objects may or may not have reagents; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/defer_update = FALSE, var/transferred_phases = (MAT_PHASE_LIQUID | MAT_PHASE_SOLID))
	if(!target || !target.simulated)
		return 0

	if(!target.reagents)
		var/datum/reagents/reagent = new /datum/reagents(amount * multiplier, global.temp_reagents_holder)
		. = trans_to_holder(reagent, amount, multiplier, copy, TRUE, defer_update = defer_update, transferred_phases = transferred_phases)
		reagent.touch_obj(target)
		qdel(reagent)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy, defer_update = defer_update, transferred_phases = transferred_phases)

/datum/reagents/proc/get_skimmable_reagents()
	for(var/decl/material/reagent as anything in reagent_volumes)
		if(reagent.skimmable)
			LAZYADD(., reagent)

/// Used to return strings like "dilute blood" for use in phrases like "It's covered in dilute oily slimy bloody mud!"
/// This is explicitly inspired by Caves of Qud, by the way.
/datum/reagents/proc/get_coated_name()
	/// arbitrary number, number of words that will be included in the name. will always have primary in addition
	var/const/MAX_COATING_NAMES = 4
	if(!total_volume)
		return null
	// sort reagents from low to high, so largest reagent comes last (feels most impactful? idk, it's arbitrary)
	var/list/volumes_temp = sortTim(reagent_volumes.Copy(), /proc/cmp_numeric_asc, associative = TRUE)
	var/list/accumulator = list()
	var/decl/material/primary_reagent_decl = get_primary_reagent_decl() // this also sets src.primary_reagent to the typepath
	for(var/decl/material/reagent as anything in volumes_temp)
		if(reagent == primary_reagent)
			continue // added later
		reagent.build_coated_name(src, accumulator)
		if(length(accumulator) >= MAX_COATING_NAMES)
			break
	var/primary_name = primary_reagent_decl.get_primary_coating_name(src)
	if(get_config_value(/decl/config/enum/colored_coating_names) == CONFIG_COATING_COLOR_COMPONENTS)
		var/primary_color = primary_reagent_decl.get_reagent_color(src)
		primary_name = FONT_COLORED(primary_color, primary_name)
	accumulator += primary_name // add primary to the end
	. = jointext(accumulator, " ") // dilute oily slimy bloody mud
	if(get_config_value(/decl/config/enum/colored_coating_names) == CONFIG_COATING_COLOR_MIXTURE)
		. = FONT_COLORED(get_color(), .)

/// Used to return strings like "inky bloody muddy snowy oily wet" for use in phrases like "You are wearing some inky bloody muddy snowy oily wet leather boots."
/// This is explicitly inspired by Caves of Qud, by the way.
/datum/reagents/proc/get_coated_adjectives()
	var/const/MAX_COATING_ADJECTIVES = 5 // arbitrary number, limit how many reagents will show up in the name on examine
	if(!total_volume)
		return null
	// sort reagents from low to high, so primary reagent comes last (feels most impactful? idk, it's arbitrary)
	// todo: maybe at some point we could make staining have some kind of priority to sort by?
	var/list/volumes_temp = sortTim(reagent_volumes.Copy(), /proc/cmp_numeric_asc, associative = TRUE)
	var/list/accumulator = list()
	for(var/decl/material/reagent in volumes_temp)
		var/coated_name = reagent.get_coated_adjective(src)
		accumulator |= coated_name
		if(length(accumulator) >= MAX_COATING_ADJECTIVES)
			break
	. = jointext(accumulator, " ") // bloody muddy inky slimy wet
	if(get_config_value(/decl/config/enum/colored_coating_names) == CONFIG_COATING_COLOR_MIXTURE)
		. = FONT_COLORED(get_color(), .)

/* Atom reagent creation - use it all the time */
/atom/proc/create_or_update_reagents(vol, override_volume)
	if(islist(reagents))
		return // We are pending serde, this will be handled in initialize_reagents().
	else if(istype(reagents))
		var/use_max_vol = override_volume ? vol : max(vol, REAGENT_MAXIMUM_VOLUME(reagents))
		REAGENT_SET_MAX_VOL(reagents, use_max_vol)
		reagents.update_total()
	else if(isnull(reagents))
		reagents = new /datum/reagents(vol, src)
	return reagents

/// Infinite reagent sink: nothing is ever actually added to it, useful for complex, filtered deletion of reagents without holder churn.
/datum/reagents/sink/add_reagent(var/decl/material/reagent, amount, data, safety, defer_update, phase)
	amount = CHEMS_QUANTIZE(min(amount, REAGENTS_FREE_SPACE(src)))
	if(amount <= 0)
		return FALSE
	reagent = RESOLVE_TO_DECL(reagent)
	if(!istype(reagent))
		return FALSE
	return TRUE

/datum/reagents/proc/get_explosive_power()
	for(var/decl/material/mat in reagent_volumes)
		if(isnull(mat.explosive_power_divisor))
			continue
		. += (reagent_volumes[mat] / mat.explosive_power_divisor)
	. = round(., 1)
