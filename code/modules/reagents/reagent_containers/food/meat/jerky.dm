/obj/item/food/jerky
	name = "dried meat"
	icon = 'icons/obj/food/butchery/jerky.dmi'
	icon_state = "jerky"
	bitesize = 2
	w_class = ITEM_SIZE_TINY
	dry = TRUE
	nutriment_type = /decl/material/solid/organic/meat
	nutriment_amt = 5
	color = "#81492e"
	var/meat_name = "meat"

/obj/item/food/jerky/get_drying_state()
	return "meat"

/obj/item/food/jerky/Initialize(mapload, material_key, skip_plate = FALSE)
	. = ..()
	if(meat_name)
		set_meat_name(meat_name)

/obj/item/food/jerky/proc/set_meat_name(new_meat_name)
	meat_name = new_meat_name
	name = "dried [meat_name]"

/obj/item/food/jerky/fish
	desc = "A piece of dried fish, with a couple of scales still attached."
	meat_name = "fish"
	color = "#ffd997"

/obj/item/food/jerky/meat
	desc = "A piece of chewy dried meat. It has the texture of leather."
	meat_name = "beef"

/obj/item/food/jerky/cutlet
	name = "dried meat stick"
	desc = "A stick of chewy dried meat. Great for travel rations."
	nutriment_amt = 2
	color = "#81492e"

/obj/item/food/jerky/cutlet/set_meat_name(new_meat_name)
	. = ..()
	SetName("[name] stick")

/obj/item/food/jerky/spider
	desc = "A piece of green, stringy, dried meat, full of tubes. It smells faintly of acid."
	meat_name = "spider meat"
	color = "#6f5b4a"

/obj/item/food/jerky/spider/poison
	color = "#546145"

/obj/item/food/jerky/spider/poison/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/venom, 3)
