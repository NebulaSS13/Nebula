/*
 * Some notes on utensils and future plans:
 *
 * Utensil flags should determine how and if they can interact with
 * different food item, ie. forks should not be usable to eat soup,
 * spoons should not be usable to eat steak.
 *
 * The actual mechanics of removing a piece of food should be largely
 * identical between utensil types, with the procs existing to be
 * overidden to provide specific behavior.
 */

/obj/item/utensil

	abstract_type                    = /obj/item/utensil
	icon_state                       = ICON_STATE_WORLD
	w_class                          = ITEM_SIZE_SMALL
	origin_tech                      = @'{"materials":1}'
	attack_verb                      = list("attacked", "stabbed", "poked")
	sharp                            = FALSE
	edge                             = FALSE
	thrown_material_force_multiplier = 0.1
	material                         = /decl/material/solid/metal/aluminium
	material_force_multiplier        = 0.1
	material_alteration              = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

	var/obj/item/chems/food/loaded_food
	var/utensil_flags

/obj/item/utensil/Destroy()
	QDEL_NULL(loaded_food)
	return ..()

/obj/item/utensil/Initialize()
	. = ..()
	if (prob(60))
		default_pixel_y = rand(0, 4)
		reset_offsets(0)
	create_reagents(5)
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_RETRACTOR = TOOL_QUALITY_BAD,
		TOOL_HEMOSTAT =  TOOL_QUALITY_MEDIOCRE
	))

/obj/item/utensil/attack_self(mob/user)
	return loaded_food ? loaded_food.attack_self(user) : ..()

/obj/item/utensil/handle_eaten_by_mob(var/mob/user, var/mob/target)
	. = loaded_food ? loaded_food.handle_eaten_by_mob(user, target) : ..()
	if(QDELETED(loaded_food))
		loaded_food = null
		update_icon()

/obj/item/utensil/get_edible_material_amount(var/mob/eater)
	return loaded_food ? loaded_food.get_edible_material_amount() : ..()

/obj/item/utensil/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(loaded_food)
		var/loaded_state = "[icon_state]_loaded"
		if(check_state_in_icon(loaded_state, icon))
			add_overlay(overlay_image(icon, loaded_state, loaded_food.color, RESET_COLOR))

/obj/item/chems/food
	/// A type used when cloning this food item for utensils.
	var/utensil_type
	/// A set of utensil flags determining which utensil interactions are valid with this food.
	var/utensil_flags = UTENSIL_FLAG_SCOOP | UTENSIL_FLAG_COLLECT

/obj/item/chems/food/Initialize()
	. = ..()
	if(isnull(utensil_type))
		utensil_type = type

// TODO: generalize this for edible non-food items somehow?
/obj/item/chems/food/proc/seperate_chunk(obj/item/utensil/utensil, mob/user)
	if(!istype(utensil))
		return
	var/remove_amt = min(reagents?.total_volume, get_food_default_transfer_amount(user))
	if(remove_amt)

		// Create a dummy copy of the target food item.
		// This ensures we keep all food behavior, strings, sounds, etc.
		utensil.loaded_food = new utensil_type(utensil)
		utensil.loaded_food.trash = null
		utensil.loaded_food.plate = null
		utensil.loaded_food.color = color
		utensil.loaded_food.SetName("\proper some [utensil.loaded_food.name]")

		// Pass over a portion of our reagents.
		utensil.loaded_food.reagents.clear_reagents()
		reagents.trans_to(utensil.loaded_food, remove_amt)
		bitecount++
		if(!reagents.total_volume)
			handle_consumed()
		utensil.update_icon()

	else // This shouldn't happen, but who knows.
		to_chat(user, SPAN_WARNING("None of \the [src] is left!"))
		handle_consumed()
	return TRUE

/obj/item/chems/food/proc/handle_utensil_collection(obj/item/utensil/utensil, mob/user)
	seperate_chunk(utensil, user)
	if(utensil.loaded_food)
		to_chat(user, SPAN_NOTICE("You collect [utensil.loaded_food] with \the [utensil]."))
		return TRUE
	return FALSE

/obj/item/chems/food/proc/handle_utensil_scooping(obj/item/utensil/utensil, mob/user)
	seperate_chunk(utensil, user)
	if(utensil.loaded_food)
		to_chat(user, SPAN_NOTICE("You scoop up [utensil.loaded_food] with \the [utensil]."))
		return TRUE
	return FALSE

// TODO: take some condiment, then another attackby to spread it onto bread/toast/etc.
/obj/item/chems/food/proc/handle_utensil_spreading(obj/item/utensil/utensil, mob/user)
	return FALSE

/obj/item/chems/food/proc/handle_utensil_cutting(obj/item/tool, mob/user)

	if(!is_sliceable())
		// TODO: cut a piece off to prepare a food item for another utensil.
		return FALSE

	if (!(isturf(loc) && ((locate(/obj/structure/table) in loc) || (locate(/obj/machinery/optable) in loc) || (locate(/obj/item/storage/tray) in loc))))
		to_chat(user, SPAN_WARNING("You cannot slice \the [src] here! You need a table or at least a tray to do it."))
		return TRUE

	if (tool.w_class > ITEM_SIZE_NORMAL)
		user.visible_message(
			SPAN_NOTICE("\The [user] crudely slices \the [src] with \the [tool]!"),
			SPAN_NOTICE("You crudely slice \the [src] with your [tool.name]!")
		)
		slices_num -= rand(1,min(1,round(slices_num/2)))
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] slices \the [src]!"),
			SPAN_NOTICE("You slice \the [src]!")
		)
	var/reagents_per_slice = max(1, round(reagents.total_volume / slices_num))
	for(var/i = 1 to slices_num)
		reagents.trans_to_obj(new slice_path(loc), reagents_per_slice)
	qdel(src)
	return TRUE


/obj/item/chems/food/proc/do_utensil_interaction(obj/item/tool, mob/user)

	// Non-utensils.
	if(tool && !istype(tool, /obj/item/utensil))
		return has_edge(tool) && (utensil_flags & UTENSIL_FLAG_SLICE) && handle_utensil_cutting(tool, user)

	var/obj/item/utensil/utensil = tool
	if(!istype(utensil) || !utensil.utensil_flags)
		return FALSE
	if(utensil.loaded_food && (utensil.utensil_flags & UTENSIL_FLAG_SPREAD))
		if(!handle_utensil_spreading(utensil, user))
			to_chat(user, SPAN_WARNING("You already have something on \the [utensil]."))
		return TRUE
	if((utensil.edge || (utensil.utensil_flags & UTENSIL_FLAG_SLICE)) && (utensil_flags & UTENSIL_FLAG_SLICE) && handle_utensil_cutting(utensil, user))
		return TRUE
	if((utensil.sharp || (utensil.utensil_flags & UTENSIL_FLAG_COLLECT)) && (utensil_flags & UTENSIL_FLAG_COLLECT) && handle_utensil_collection(utensil, user))
		return TRUE
	if((utensil.utensil_flags & UTENSIL_FLAG_SCOOP) && (utensil_flags & UTENSIL_FLAG_SCOOP) && handle_utensil_scooping(utensil, user))
		return TRUE
	return FALSE
