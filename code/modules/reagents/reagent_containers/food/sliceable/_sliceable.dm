///////////////
// Sliceable //
///////////////
// All the food items that can be sliced into smaller bits like meatbread and cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/food/sliceable
	abstract_type = /obj/item/food/sliceable
	w_class = ITEM_SIZE_NORMAL //whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE

/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/food/slice
	name = "slice of... something"
	abstract_type = /obj/item/food/slice
	var/whole_path // path for the item from which this slice comes
	var/filled = FALSE // should the slice spawn with any reagents

/**
 *  Spawn a new slice of food
 *
 *  If the slice's filled is TRUE, this will also fill the slice with the
 *  appropriate amount of reagents. Note that this is done by spawning a new
 *  whole item, transferring the reagents and deleting the whole item, which may
 *  have performance implications.
 */
/obj/item/food/slice/Initialize(mapload, material_key, skip_plate = FALSE)
	. = ..()
	if(filled)
		var/obj/item/food/whole = new whole_path()
		if(whole && whole.slice_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slice_num
			whole.reagents.trans_to_obj(src, reagent_amount)

		qdel(whole)
