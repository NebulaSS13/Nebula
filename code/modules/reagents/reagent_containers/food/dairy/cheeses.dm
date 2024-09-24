/obj/item/food/dairy/cheese
	nutriment_type   = /decl/material/liquid/nutriment/cheese
	abstract_type    = /obj/item/food/dairy/cheese
	data_name_field  = DATA_CHEESE_NAME
	data_color_field = DATA_CHEESE_COLOR

/obj/item/food/dairy/cheese/get_default_dairy_color()
	return "#ffd000"

/obj/item/food/dairy/cheese/get_default_dairy_name()
	return "cheese"

/obj/item/food/dairy/cheese/wedge
	name = "wedge"
	desc = "A wedge of delicious cheese. The cheese wheel it was cut from can't have gone far."
	icon = 'icons/obj/food/dairy/cheese_wedge.dmi'
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_amt = 5

/obj/item/food/dairy/cheese/wedge/slice
	nutriment_amt = 0

/obj/item/food/dairy/cheese/wheel
	name = "wheel"
	desc = "A big wheel of delcious cheese."
	icon = 'icons/obj/food/dairy/cheese_wheel.dmi'
	slice_path = /obj/item/food/dairy/cheese/wedge/slice
	slice_num = 5
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_amt = 20
	w_class = ITEM_SIZE_NORMAL
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE

// Mappable subtypes below.
/obj/item/food/dairy/cheese/wheel/goat/get_nutriment_data()
	. = ..()
	LAZYSET(., data_name_field, "feta")
	LAZYSET(., data_color_field, "#f3f2be")
