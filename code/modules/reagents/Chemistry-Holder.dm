GLOBAL_DATUM_INIT(temp_reagents_holder, /obj, new)

/datum/reagents
	var/primary_reagent
	var/list/reagent_volumes
	var/list/reagent_data
	var/total_volume = 0
	var/maximum_volume = 120
	var/atom/my_atom
	var/cached_color

/datum/reagents/New(var/maximum_volume = 120, var/atom/my_atom)
	src.maximum_volume = maximum_volume
	if(!istype(my_atom))
#ifdef DISABLE_DEBUG_CRASH
		return ..()
#else
		CRASH("Invalid reagents holder: [log_info_line(my_atom)]")
#endif
	..()
	src.my_atom = my_atom

/datum/reagents/Destroy()
	. = ..()
	UNQUEUE_REACTIONS(src) // While marking for reactions should be avoided just before deleting if possible, the async nature means it might be impossible.
	reagent_volumes = null
	reagent_data = null
	my_atom = null

/datum/reagents/proc/get_primary_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/decl/material/reagent = get_primary_reagent_decl()
	if(reagent)
		. = reagent.name

/datum/reagents/proc/get_primary_reagent_decl()
	. = primary_reagent && decls_repository.get_decl(primary_reagent)

/datum/reagents/proc/update_total() // Updates volume.
	cached_color = null
	total_volume = 0
	primary_reagent = null
	for(var/R in reagent_volumes)
		var/vol = reagent_volumes[R]
		if(vol < MINIMUM_CHEMICAL_VOLUME)
			LAZYREMOVE(reagent_volumes, R)
			LAZYREMOVE(reagent_data, R)
		else
			total_volume += vol
			if(!primary_reagent || reagent_volumes[primary_reagent] < vol)
				primary_reagent = R
	if(total_volume > maximum_volume)
		remove_any(maximum_volume - total_volume)

/datum/reagents/proc/process_reactions()

	if(!my_atom?.loc)
		return 0

	if(my_atom.atom_flags & ATOM_FLAG_NO_REACT)
		return 0

	var/reaction_occured = FALSE
	var/list/eligible_reactions = list()

	var/temperature = my_atom ? my_atom.temperature : T20C
	for(var/thing in reagent_volumes)
		var/decl/material/R = decls_repository.get_decl(thing)

		// Check if the reagent is decaying or not.
		var/list/replace_self_with
		var/replace_message
		var/replace_sound
	
		if(!isnull(R.chilling_point) && R.type != R.bypass_cooling_products_for_root_type && LAZYLEN(R.chilling_products) && temperature <= R.chilling_point)
			replace_self_with = R.chilling_products
			if(R.chilling_message)
				replace_message = "\The [lowertext(R.name)] [R.chilling_message]"
			replace_sound = R.chilling_sound

		else if(!isnull(R.heating_point) && R.type != R.bypass_heating_products_for_root_type && LAZYLEN(R.heating_products) && temperature >= R.heating_point)
			replace_self_with = R.heating_products
			if(R.heating_message)
				replace_message = "\The [lowertext(R.name)] [R.heating_message]"
			replace_sound = R.heating_sound

		else if(!isnull(R.dissolves_in) && LAZYLEN(R.dissolves_into))
			for(var/other in reagent_volumes)
				if(other == thing)
					continue
				var/decl/material/solvent = decls_repository.get_decl(other)
				if(solvent.solvent_power >= R.dissolves_in)
					replace_self_with = R.dissolves_into
					if(R.dissolve_message)
						replace_message = "\The [lowertext(R.name)] [R.dissolve_message] \the [lowertext(solvent.name)]."
					replace_sound = R.dissolve_sound
					break

		// If it is, handle replacing it with the decay product.
		if(replace_self_with)
			var/replace_amount = REAGENT_VOLUME(src, R.type)
			clear_reagent(R.type)
			for(var/product in replace_self_with)
				add_reagent(product, replace_self_with[product] * replace_amount)
			reaction_occured = TRUE

			if(my_atom)
				if(replace_message)
					my_atom.visible_message("<span class='notice'>[html_icon(my_atom)] [replace_message]</span>")
				if(replace_sound)
					playsound(my_atom, replace_sound, 80, 1)

		else // Otherwise, collect all possible reactions.
			eligible_reactions |= SSmaterials.chemical_reactions_by_id[R.type]

	var/list/active_reactions = list()

	for(var/datum/chemical_reaction/C in eligible_reactions)
		if(C.can_happen(src))
			active_reactions[C] = 1 // The number is going to be 1/(fraction of remaining reagents we are allowed to use), computed below
			reaction_occured = 1

	var/list/used_reagents = list()
	// if two reactions share a reagent, each is allocated half of it, so we compute this here
	for(var/datum/chemical_reaction/C in active_reactions)
		var/list/adding = C.get_used_reagents()
		for(var/R in adding)
			LAZYADD(used_reagents[R], C)

	for(var/R in used_reagents)
		var/counter = length(used_reagents[R])
		if(counter <= 1)
			continue // Only used by one reaction, so nothing we need to do.
		for(var/datum/chemical_reaction/C in used_reagents[R])
			active_reactions[C] = max(counter, active_reactions[C])
			counter-- //so the next reaction we execute uses more of the remaining reagents
			// Note: this is not guaranteed to maximize the size of the reactions we do (if one reaction is limited by reagent A, we may be over-allocating reagent B to it)
			// However, we are guaranteed to fully use up the most profligate reagent if possible.
			// Further reactions may occur on the next tick, when this runs again.

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.process(src, active_reactions[C])

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.post_reaction(src)

	update_total()

	if(reaction_occured)
		HANDLE_REACTIONS(src) // Check again in case the new reagents can react again

	return reaction_occured

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/reagent_type, var/amount, var/data = null, var/safety = 0)

	if(amount <= 0)
		return FALSE

	amount = min(amount, REAGENTS_FREE_SPACE(src))
	var/decl/material/newreagent = decls_repository.get_decl(reagent_type)
	LAZYINITLIST(reagent_volumes)
	if(!reagent_volumes[reagent_type])
		reagent_volumes[reagent_type] = amount
		var/tmp_data = newreagent.initialize_data(data)
		if(tmp_data)
			LAZYSET(reagent_data, reagent_type, tmp_data)
	else
		reagent_volumes[reagent_type] += amount
		if(!isnull(data))
			LAZYSET(reagent_data, reagent_type, newreagent.mix_data(src, data, amount))
	UNSETEMPTY(reagent_volumes)

	update_total()
	if(!safety)
		HANDLE_REACTIONS(src)
	if(my_atom)
		SSmaterials.queue_reagent_change(my_atom)

	return TRUE

/datum/reagents/proc/remove_reagent(var/reagent_type, var/amount, var/safety = 0)
	if(!isnum(amount) || REAGENT_VOLUME(src, reagent_type) <= 0)
		return FALSE
	reagent_volumes[reagent_type] -= amount
	update_total()
	if(!safety)
		HANDLE_REACTIONS(src)
	if(my_atom)
		SSmaterials.queue_reagent_change(my_atom)
	return TRUE

/datum/reagents/proc/clear_reagent(var/reagent_type)
	. = !!(REAGENT_VOLUME(src, reagent_type) || REAGENT_DATA(src, reagent_type))
	if(.)
		LAZYREMOVE(reagent_volumes, reagent_type)
		LAZYREMOVE(reagent_data, reagent_type)
		if(primary_reagent == reagent_type)
			primary_reagent = null
		update_total()
		if(my_atom)
			SSmaterials.queue_reagent_change(my_atom)

/datum/reagents/proc/has_reagent(var/reagent_type, var/amount)
	. = REAGENT_VOLUME(src, reagent_type)
	if(. && amount)
		. = (. >= amount)

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/check in check_reagents)
		var/vol = REAGENT_VOLUME(src, check)
		if(vol > 0 && vol >= check_reagents[check])
			return TRUE
	return FALSE

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	for(var/check in check_reagents)
		if(REAGENT_VOLUME(src, check) < check_reagents[check])
			return FALSE
	return TRUE

/datum/reagents/proc/clear_reagents()
	reagent_volumes = null
	reagent_data = null
	total_volume = 0

/datum/reagents/proc/get_overdose(var/decl/material/current)
	if(current)
		return initial(current.overdose)
	return 0

/datum/reagents/proc/get_reagents(scannable_only = 0, precision)
	. = list()
	for(var/rtype in reagent_volumes)
		var/decl/material/current= decls_repository.get_decl(rtype)
		if(scannable_only && !current.scannable)
			continue
		var/volume = REAGENT_VOLUME(src, rtype)
		if(precision)
			volume = round(volume, precision)
		if(volume)
			. += "[current.name] ([volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	. = min(amount, total_volume)
	if(.)
		var/part = . / total_volume
		for(var/current in reagent_volumes)
			remove_reagent(current, REAGENT_VOLUME(src, current) * part, 1)
		update_total()
		HANDLE_REACTIONS(src)

// Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier].
// Returns actual amount removed from [src] (not amount transferred to [target]).
// Use safety = 1 for temporary targets to avoid queuing them up for processing.
/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/safety = 0)
	if(!target || !istype(target))
		return

	amount = max(0, min(amount, total_volume, REAGENTS_FREE_SPACE(target) / multiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/rtype in reagent_volumes)
		var/amount_to_transfer = REAGENT_VOLUME(src, rtype) * part
		target.add_reagent(rtype, amount_to_transfer * multiplier, REAGENT_DATA(src, rtype), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(rtype, amount_to_transfer, 1)

	if(!copy)
		HANDLE_REACTIONS(src)
	if(!safety)
		HANDLE_REACTIONS(target)
	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	touch(target) //First, handle mere touch effects

	if(ismob(target))
		return splash_mob(target, amount, copy)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target) && ATOM_IS_OPEN_CONTAINER(target))
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/min_spill=0, var/max_spill=60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill, max_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill, multiplier, copy, min_spill, max_spill)

	trans_to(target, amount, multiplier, copy)

/datum/reagents/proc/trans_type_to(var/atom/target, var/type, var/amount = 1, var/multiplier = 1)
	if (!target || !target.reagents || !target.simulated)
		return

	amount = min(amount, REAGENT_VOLUME(src, type))

	if(!amount)
		return

	var/datum/reagents/F = new(amount, GLOB.temp_reagents_holder)
	F.add_reagent(type, amount, REAGENT_DATA(src, type))
	remove_reagent(type, amount)
	. = F.trans_to(target, amount, multiplier) // Let this proc check the atom's type

	qdel(F)

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target)
	if(ismob(target))
		touch_mob(target)
	if(isturf(target))
		touch_turf(target)
	if(isobj(target))
		touch_obj(target)

/datum/reagents/proc/touch_mob(var/mob/target)
	if(!target || !istype(target) || !target.simulated)
		return
	for(var/rtype in reagent_volumes)
		var/decl/material/current = decls_repository.get_decl(rtype)
		current.touch_mob(target, REAGENT_VOLUME(src, rtype), src)
	update_total()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target) || !target.simulated)
		return
	for(var/rtype in reagent_volumes)
		var/decl/material/current = decls_repository.get_decl(rtype)
		current.touch_turf(target, REAGENT_VOLUME(src, rtype), src)
	update_total()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target) || !target.simulated)
		return
	for(var/rtype in reagent_volumes)
		var/decl/material/current = decls_repository.get_decl(rtype)
		current.touch_obj(target, REAGENT_VOLUME(src, rtype), src)
	update_total()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount * perm, CHEM_TOUCH, 1, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_INJECT, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target) || !target.simulated)
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_INJECT)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.get_ingested_reagents()
			return C.ingest(src, R, amount, multiplier, copy) //perhaps this is a bit of a hack, but currently there's no common proc for eating reagents
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount, GLOB.temp_reagents_holder)
		. = trans_to_holder(R, amount, multiplier, copy, 1)
		R.touch_mob(target)
		qdel(R)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target || !target.simulated)
		return
	var/datum/reagents/R = new /datum/reagents(amount * multiplier, GLOB.temp_reagents_holder)
	. = trans_to_holder(R, amount, multiplier, copy, 1)
	var/obj/effect/fluid/F = locate() in target
	if(!F) F = new(target)
	trans_to_holder(F.reagents, amount, multiplier, copy)

/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target || !target.simulated)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier, GLOB.temp_reagents_holder)
		. = trans_to_holder(R, amount, multiplier, copy, 1)
		R.touch_obj(target)
		qdel(R)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	if(reagents)
		log_debug("Attempted to create a new reagents holder when already referencing one: [log_info_line(src)]")
		reagents.maximum_volume = max(reagents.maximum_volume, max_vol)
	else
		reagents = new/datum/reagents(max_vol, src)
	return reagents

/datum/reagents/Topic(href, href_list)
	. = ..()
	if(!. && href_list["deconvert"])
		var/list/data = REAGENT_DATA(src, /decl/material/liquid/water)
		if(LAZYACCESS(data, "holy"))
			var/mob/living/carbon/C = locate(href_list["deconvert"])
			if(istype(C) && !QDELETED(C) && C.mind)
				var/decl/special_role/godcult = decls_repository.get_decl(/decl/special_role/godcultist)
				godcult.remove_antagonist(C.mind,1)
