/obj/item/stack/get_single_monetary_worth()
	. = ..()
	if(!material && !length(matter))
		. *= amount
