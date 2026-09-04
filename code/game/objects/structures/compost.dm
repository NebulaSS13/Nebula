/// The number of worms influences the rate at which contents are decomposed into compost.
var/global/const/COMPOST_WORM_EAT_AMOUNT    = 50
var/global/const/COMPOST_MAX_WORMS          = 10
var/global/const/COMPOST_WORM_HUNGER_FACTOR = MINIMUM_CHEMICAL_VOLUME

/obj/structure/reagent_dispensers/compost_bin
	name                      = "compost bin"
	desc                      = "A squat bin for decomposing organic material."
	icon                      = 'icons/obj/structures/compost.dmi'
	icon_state                = ICON_STATE_WORLD
	anchored                  = TRUE
	density                   = TRUE
	atom_flags                = ATOM_FLAG_CLIMBABLE
	matter                    = null
	material                  = /decl/material/solid/organic/wood/oak
	material_alteration       = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	wrenchable                = FALSE
	possible_transfer_amounts = @"[10,25,50,100]"
	chem_volume               = 2000
	storage                   = /datum/storage/hopper/industrial/compost

/obj/structure/reagent_dispensers/compost_bin/Initialize()
	// Building one outside should give you some Free Worms:tm:.
	// Station needs to add worms (when worms are in code).
	var/turf/turf = get_turf(src)
	if(istype(turf))
		var/worms = round(5 * turf.get_plant_growth_rate())
		if(worms)
			for(var/i = 1 to worms)
				var/obj/item/food/worm/worm = new(src)
				if(!storage.handle_item_insertion(null, worm))
					qdel(worm)
					break
	. = ..()

/obj/structure/reagent_dispensers/compost_bin/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/reagent_dispensers/compost_bin/on_update_icon()
	. = ..()
	icon_state = ICON_STATE_WORLD
	if(ATOM_IS_OPEN_CONTAINER(src))
		add_overlay(overlay_image(icon, "[icon_state]-hinges-open", null, RESET_COLOR))
		add_overlay(overlay_image(icon, "[icon_state]-open", get_color(), RESET_COLOR)) // leaving the door open for separate lid materials in the future
	else
		add_overlay(overlay_image(icon, "[icon_state]-hinges", null, RESET_COLOR))

/obj/structure/reagent_dispensers/compost_bin/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)

		var/worms = 0
		for(var/obj/item/food/worm/worm in get_stored_inventory())
			worms++

		switch(worms)
			if(0)
				. += SPAN_WARNING("There are no worms in \the [src].")
			if(1)
				. += SPAN_NOTICE("A lonely worm wiggles around in \the [src].")
			if(2 to 3)
				. += SPAN_NOTICE("A few worms wiggle around in \the [src].")
			if(4 to 6)
				. += SPAN_NOTICE("A healthy number of worms wiggle around in \the [src].")
			else
				. += SPAN_NOTICE("A thriving worm colony wiggles around in \the [src].")

		var/list/composting = list()
		for(var/thing in get_stored_inventory())
			if(!istype(thing, /obj/item/food/worm))
				composting += thing

		if(length(composting))
			. += SPAN_NOTICE("[capitalize(english_list(composting, summarize = TRUE))] [length(composting) == 1 ? "is" : "are"] composting inside \the [src].")
		else
			. += SPAN_NOTICE("Nothing is composting within \the [src].")

/obj/structure/reagent_dispensers/compost_bin/Entered(var/atom/movable/AM, atom/old_loc)
	. = ..()
	if(!is_processing)
		START_PROCESSING(SSobj, src)

/obj/structure/reagent_dispensers/compost_bin/physically_destroyed()
	dump_contents()
	var/reagent_volume = REAGENT_TOTAL_VOLUME(reagents)
	if(reagent_volume)
		reagents.trans_to(loc, reagent_volume)
	return ..()

/obj/structure/reagent_dispensers/compost_bin/attackby(obj/item/used_item, mob/user)

	if(user.check_intent(I_FLAG_HARM))
		return ..()

	if(used_item.storage)

		var/emptied = FALSE
		for(var/obj/item/O in used_item.get_stored_inventory())
			if(storage.can_be_inserted(O))
				used_item.storage.remove_from_storage(null, O, loc, skip_update = TRUE)
				storage.handle_item_insertion(null, O, skip_update = TRUE)
				emptied = TRUE

		if(emptied)
			used_item.storage.finish_bulk_removal()
			storage.update_ui_after_item_insertion()
			if(length(used_item.get_stored_inventory()))
				to_chat(user, SPAN_NOTICE("You partially empty \the [used_item] into \the [src]'s hopper."))
			else
				to_chat(user, SPAN_NOTICE("You empty \the [used_item] into \the [src]'s hopper."))
			used_item.update_icon()
			return TRUE

	return ..()

/obj/structure/reagent_dispensers/compost_bin/Process()

	var/worms = 0
	var/list/current_contents = get_stored_inventory()
	if(islist(current_contents))
		current_contents = current_contents.Copy()

	for(var/obj/item/food/worm/worm in current_contents)
		current_contents -= worm
		worms++

	// No worms means no processing.
	if(worms <= 0)
		return PROCESS_KILL

	// Digest an item.
	var/worm_eat_amount = max(1, round(worms * COMPOST_WORM_EAT_AMOUNT))
	if(length(current_contents))

		var/obj/item/composting = pick(current_contents)

		if(composting.is_compostable())

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

				if(REAGENT_TOTAL_VOLUME(composting.reagents))
					composting.reagents.trans_to_holder(reagents, REAGENT_TOTAL_VOLUME(composting.reagents))
					composting.reagents.clear_reagents()

				composting.clear_matter()
				qdel(composting)

				var/obj/item/debris/scraps/remains = (locate() in contents) || new(src)
				LAZYINITLIST(remains.matter)
				var/list/composting_matter = composting.get_contained_matter()
				for(var/mat in composting_matter)
					remains.matter[mat] += composting_matter[mat]
				UNSETEMPTY(remains.matter)
				remains.update_primary_material()

	// Digest reagents.
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
		if(istype(reagent, /decl/material/liquid/fertilizer))
			continue
		if(!reagent.compost_value)
			continue
		var/clamped_worm_drink_amount = min(round(worm_eat_amount * REAGENT_UNITS_PER_MATERIAL_UNIT), REAGENT_VOLUME(reagents, reagent))
		reagents.add_reagent(/decl/material/liquid/fertilizer/compost, max(1, round(clamped_worm_drink_amount * reagent.compost_value)))
		reagents.remove_reagent(reagent, clamped_worm_drink_amount)
		break

	// Grow more worms.
	if(REAGENT_VOLUME(reagents, /decl/material/liquid/fertilizer/compost) > 0 && prob(0.1) && worms < COMPOST_MAX_WORMS)
		var/obj/item/food/worm/worm = new(src)
		if(!storage.handle_item_insertion(null, worm))
			qdel(worm)

/obj/structure/reagent_dispensers/compost_bin/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/reagent_dispensers/compost_bin/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color