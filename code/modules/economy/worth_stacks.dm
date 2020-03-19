/obj/item/stack/get_single_monetary_worth()
	. = ..()
	if(!material && !length(matter))
		. *= amount

/obj/item/stack/apply_additional_item_value(var/initial_value)
	. = initial_value
