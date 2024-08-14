/obj/item/handle_eaten_by_mob(var/mob/user, var/mob/target)
	. = ..()
	if(. == EATEN_SUCCESS && !QDELETED(src))
		add_trace_DNA(target)

// Used to get a piece of food from an item.
/obj/item/proc/seperate_food_chunk(obj/item/utensil/utensil, mob/user)
	var/utensil_food_type = get_utensil_food_type()
	if(!istype(utensil) || !utensil_food_type)
		return
	var/remove_amt = min(reagents?.total_volume, get_food_default_transfer_amount(user))
	if(remove_amt)

		// Create a dummy copy of the target food item.
		// This ensures we keep all food behavior, strings, sounds, etc.
		utensil.loaded_food = new utensil_food_type(utensil, material?.type, TRUE)
		QDEL_NULL(utensil.loaded_food.trash)
		QDEL_NULL(utensil.loaded_food.plate)
		utensil.loaded_food.color = color
		utensil.loaded_food.filling_color = get_food_filling_color()
		utensil.loaded_food.SetName("\proper some [utensil.loaded_food.name]")

		// Pass over a portion of our reagents.
		utensil.loaded_food.reagents.clear_reagents()
		reagents.trans_to(utensil.loaded_food, remove_amt)
		handle_chunk_separated()
		if(!reagents.total_volume)
			handle_consumed()
		utensil.update_icon()

	else // This shouldn't happen, but who knows.
		to_chat(user, SPAN_WARNING("None of \the [src] is left!"))
		handle_consumed()
	return TRUE

/obj/item/proc/get_food_filling_color()
	return color

/obj/item/proc/get_utensil_food_type()
	return

/obj/item/proc/handle_chunk_separated()
	return
