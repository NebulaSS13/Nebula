/obj/item/food/dairy/butter
	abstract_type  = /obj/item/food/dairy/butter
	nutriment_type = /decl/material/liquid/nutriment/butter
	color = "#ffe864"
	nutriment_desc = list("butter" = 1)

/obj/item/food/dairy/butter/get_default_dairy_color()
	return "#ffe864"

/obj/item/food/dairy/butter/get_default_dairy_name()
	return "butter"

/obj/item/food/dairy/butter/stick
	name = "stick"
	desc = "A stick of pure butterfat made from milk products."
	icon = 'icons/obj/food/dairy/butter.dmi'
	center_of_mass = @'{"x":16,"y":16}'
	nutriment_amt = 20
	slice_path = /obj/item/food/dairy/butter/pat
	slice_num = 5

/obj/item/food/dairy/butter/pat
	name = "pat"
	desc = "A small pat of butter, separated from some greater whole."
	icon = 'icons/obj/food/dairy/butter_pat.dmi'
	nutriment_amt = 1

// Mappable subtypes below.
/obj/item/food/dairy/butter/stick/margarine
	desc = "A stick of emulsified plant oil, often used as a substitute for butter."
	nutriment_type = /decl/material/liquid/nutriment/margarine
	slice_path = /obj/item/food/dairy/butter/pat/margarine
	color = "#f3f2be"
	nutriment_desc = list("oil" = 1)

/obj/item/food/dairy/butter/stick/margarine/get_nutriment_data()
	. = ..()
	LAZYSET(., data_name_field, "margarine")
	LAZYSET(., data_color_field, "#f3f2be")

/obj/item/food/dairy/butter/pat/margarine
	desc = "A small pat of margarine, separated from some greater whole."
	nutriment_desc = list("oil" = 1)

/obj/item/food/dairy/butter/pat/margarine/get_nutriment_data()
	. = ..()
	LAZYSET(., data_name_field, "margarine")
	LAZYSET(., data_color_field, "#f3f2be")
