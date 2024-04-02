/obj/structure/reagent_dispensers/compost_bin
	name                      = "compost bin"
	desc                      = "A squat bin for decomposing organic material."
	icon                      = 'icons/obj/structures/compost.dmi'
	icon_state                = ICON_STATE_WORLD
	anchored                  = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	material                  = /decl/material/solid/organic/wood
	matter                    = null
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	wrenchable                = FALSE

	/// The number of worms influences the rate at which contents are decomposed into compost.
	var/worm_amount           = 0
	var/const/WORM_EAT_AMOUNT = 50
	var/const/MAX_WORMS       = 10
	var/const/MAX_ITEMS       = 50

/obj/structure/reagent_dispensers/compost_bin/Initialize()
	// Building one outside should give you some Free Worms:tm:.
	// Station needs to add worms (when worms are in code).
	var/turf/turf = get_turf(src)
	if(istype(turf))
		worm_amount = round(5 * turf.get_plant_growth_rate())
	. = ..()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER // something seems to be unsetting this :(

/obj/structure/reagent_dispensers/compost_bin/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/reagent_dispensers/compost_bin/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)

		switch(worm_amount)
			if(0)
				to_chat(user, SPAN_WARNING("There are no worms in \the [src]."))
			if(1)
				to_chat(user, SPAN_NOTICE("A lonely worm wiggles around in \the [src]."))
			if(2 to 3)
				to_chat(user, SPAN_NOTICE("A few worms wiggle around in \the [src]."))
			if(4 to 6)
				to_chat(user, SPAN_NOTICE("A healthy number of worms wiggle around in \the [src]."))
			else
				to_chat(user, SPAN_NOTICE("A thriving worm colony wiggles around in \the [src]."))

		var/composting = get_contained_external_atoms()
		if(length(composting))
			to_chat(user, SPAN_NOTICE("[capitalize(english_list(composting, summarize = TRUE))] [length(composting) == 1 ? "is" : "are"] composting inside \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("Nothing is composting within \the [src]."))

/obj/structure/reagent_dispensers/compost_bin/physically_destroyed()
	dump_contents()
	for(var/i = 1 to worm_amount)
		new /obj/item/chems/food/worm(loc)
	worm_amount = 0
	if(reagents)
		reagents.trans_to(loc, reagents.total_volume)
	return ..()

/obj/structure/reagent_dispensers/compost_bin/attack_hand(mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(length(get_contained_external_atoms()))
		var/obj/item/removing = pick(get_contained_external_atoms())
		removing.dropInto(loc)
		user.put_in_hands(removing)
		to_chat(user, SPAN_NOTICE("You fish \the [removing] out of \the [src]."))
		return TRUE

	if(worm_amount)
		worm_amount--
		var/obj/item/chems/food/worm/worm = new(loc)
		user.put_in_hands(worm)
		to_chat(user, SPAN_NOTICE("You fish \the [worm] out of \the [src]."))
		return TRUE

	return ..()

/obj/structure/reagent_dispensers/compost_bin/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	if(istype(W, /obj/item/storage))

		var/is_full = FALSE
		var/transferred = 0
		var/obj/item/storage/plantbag = W
		for(var/obj/item/thing in plantbag.contents)
			if(thing.is_compostable())
				if(length(get_contained_external_atoms()) >= MAX_ITEMS)
					to_chat(user, SPAN_WARNING("\The [src] is full. Give it some time to compost."))
					is_full = TRUE
					break
				transferred++
				plantbag.remove_from_storage(thing, src, TRUE)

		if(transferred)
			plantbag.finish_bulk_removal()
			to_chat(user, SPAN_NOTICE("You dump [transferred] item\s from \the [W] into \the [src]."))
		else if(!is_full)
			to_chat(user, SPAN_WARNING("Nothing in \the [W] is suitable for composting."))
		return TRUE

	if(istype(W, /obj/item/chems/food/worm))
		if(worm_amount < MAX_WORMS)
			if(user.try_unequip(W))
				to_chat(user, SPAN_NOTICE("You drop \the [W] into \the [src]."))
				worm_amount++
				qdel(W)
				if(!is_processing)
					START_PROCESSING(SSobj, src)
		else
			to_chat(user, SPAN_WARNING("\The [src] is already at maximum worm capacity."))
		return TRUE

	if(W.is_compostable())
		if(length(get_contained_external_atoms()) >= MAX_ITEMS)
			to_chat(user, SPAN_WARNING("\The [src] is full. Give it some time to compost."))
		else if(user.try_unequip(W, src))
			to_chat(user, SPAN_NOTICE("You drop \the [W] into \the [src]."))
			update_icon()
			if(!is_processing)
				START_PROCESSING(SSobj, src)
		return TRUE

	return ..()

/obj/structure/reagent_dispensers/compost_bin/Process()
	// No worms means no processing.
	if(worm_amount <= 0)
		return PROCESS_KILL

	// Worm-related tracking values.
	var/worms_are_hungry  = TRUE
	var/worm_eat_amount   = max(1, round(worm_amount * WORM_EAT_AMOUNT))
	var/worm_drink_amount = max(1, round(worm_eat_amount * REAGENT_UNITS_PER_MATERIAL_UNIT))

	// Digest an item.
	var/list/composting_items = get_contained_external_atoms()
	if(length(composting_items))

		var/obj/item/composting = pick(composting_items)
		var/list/composting_matter = composting.get_contained_matter()

		if(composting.is_compostable())

			worms_are_hungry = FALSE

			// We only start composting debris, as we have no proper handling for partial decomposition
			// and cannot really apply our worm decomp rate to non-debris items without it.
			if(istype(composting, /obj/item/debris/scraps))
				var/obj/item/debris/scraps/lump = composting
				for(var/mat in lump.matter)
					var/decl/material/composting_mat = GET_DECL(mat)
					if(!composting_mat.compost_value)
						continue
					var/composting_amount = max(1, round(clamp(worm_eat_amount, 0, lump.matter[mat]) * composting_mat.compost_value * REAGENT_UNITS_PER_MATERIAL_UNIT))
					reagents.add_reagent(/decl/material/liquid/fertilizer/compost, composting_amount)
					lump.matter[mat] -= worm_eat_amount
					if(lump.matter[mat] <= 0)
						LAZYREMOVE(lump.matter, mat)
					lump.update_primary_material()
					break

			else

				for(var/obj/item/thing in composting.get_contained_external_atoms())
					thing.forceMove(src)

				if(composting.reagents?.total_volume)
					composting.reagents.trans_to_holder(reagents, composting.reagents.total_volume)
					composting.reagents.clear_reagents()

				composting.clear_matter()
				qdel(composting)

				var/obj/item/debris/scraps/remains = (locate() in contents) || new(src)
				LAZYINITLIST(remains.matter)
				for(var/mat in composting_matter)
					remains.matter[mat] += composting_matter[mat]
				UNSETEMPTY(remains.matter)
				remains.update_primary_material()

	// Digest reagents.
	if(worms_are_hungry)
		for(var/mat in reagents.reagent_volumes)
			if(ispath(mat, /decl/material/liquid/fertilizer))
				continue
			var/decl/material/material_data = GET_DECL(mat)
			if(!material_data.compost_value)
				continue
			var/clamped_worm_drink_amount = min(worm_drink_amount, reagents.reagent_volumes[mat])
			reagents.add_reagent(/decl/material/liquid/fertilizer/compost, max(1, round(clamped_worm_drink_amount * material_data.compost_value)))
			reagents.remove_reagent(mat, clamped_worm_drink_amount)
			worms_are_hungry = FALSE
			break

	// Feed the worms to grow more worms.
	var/compost_amount = REAGENT_VOLUME(reagents, /decl/material/liquid/fertilizer/compost)
	if(compost_amount > 0)
		// Worms gotta eat...
		if(worms_are_hungry)
			reagents.remove_reagent(/decl/material/liquid/fertilizer/compost, worm_drink_amount * 0.025)
		if(worm_amount < MAX_WORMS && prob(1))
			worm_amount++

/obj/structure/reagent_dispensers/compost_bin/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYREMOVE(., /decl/interaction_handler/toggle_open/reagent_dispenser)
