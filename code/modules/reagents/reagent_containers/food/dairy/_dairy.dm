/obj/item/food/dairy
	abstract_type = /obj/item/food/dairy
	nutriment_type = /decl/material/liquid/drink/milk
	bitesize = 2
	icon_state = ICON_STATE_WORLD
	var/data_name_field  = DATA_MILK_NAME
	var/data_color_field = DATA_MILK_COLOR

/obj/item/food/dairy/get_mechanics_info()
	. = ..()
	LAZYADD(., "Dairy products are made from milk, either by skimming or from mixing milk with enzymes or rennet and applying heat. Rennet can be obtained from the stomachs of grazing animals.")

// Set default strings so it shows as 'a wedge of cheese' in recipes instead of 'a wedge'.
/obj/item/food/dairy/Initialize(ml, material_key, skip_plate)
	set_dairy_name(get_default_dairy_name())
	set_color(get_default_dairy_color())
	. = ..()

/obj/item/food/dairy/proc/get_default_dairy_color()
	return COLOR_WHITE

/obj/item/food/dairy/proc/get_default_dairy_name()
	return "milk"

/obj/item/food/dairy/proc/set_dairy_name(milk_name)
	SetName("[milk_name] [initial(name)]")

/obj/item/food/dairy/on_reagent_change()

	. = ..()

	if(!REAGENT_TOTAL_VOLUME(reagents))
		return

	var/list/data = REAGENT_DATA(reagents, nutriment_type)
	var/milk_name = LAZYACCESS(data, data_name_field)
	if(milk_name)
		set_dairy_name(milk_name)
		set_color(LAZYACCESS(data, data_color_field) || get_default_dairy_color())
	else
		set_dairy_name(get_default_dairy_name())
		set_color(get_default_dairy_color())
	filling_color = get_color()
