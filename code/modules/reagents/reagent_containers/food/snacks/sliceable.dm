///////////////
// Sliceable //
///////////////
// All the food items that can be sliced into smaller bits like meatbread and cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/chems/food/sliceable
	w_class = ITEM_SIZE_NORMAL //whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.
/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/chems/food/slice
	name = "slice of... something"
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
/obj/item/chems/food/slice/Initialize()
	. = ..()
	if(filled)
		var/obj/item/chems/food/whole = new whole_path()
		if(whole && whole.slices_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slices_num
			whole.reagents.trans_to_obj(src, reagent_amount)

		qdel(whole)
