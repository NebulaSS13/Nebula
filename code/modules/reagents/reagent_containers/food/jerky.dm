/obj/item/food/jerky
	name = "dried meat"
	icon = 'icons/obj/food_jerky.dmi'
	bitesize = 2
	w_class = ITEM_SIZE_TINY
	dry = TRUE
	nutriment_type = /decl/material/solid/organic/meat
	nutriment_amt = 5
	var/meat_name = "meat"

/obj/item/food/jerky/Initialize()
	. = ..()
	if(meat_name)
		set_meat_name(meat_name)

/obj/item/food/jerky/proc/set_meat_name(new_meat_name)
	meat_name = new_meat_name
	name = "dried [meat_name]"

/obj/item/food/jerky/fish
	desc = "A piece of dried fish, with a couple of scales still attached."
	icon_state = "fishjerky"
	meat_name = "fish"

/obj/item/food/jerky/fish/get_drying_state()
	return "fish_dried"

/obj/item/food/jerky/meat
	desc = "A piece of chewy dried meat. It has the texture of leather."
	icon_state = "meatjerky"
	meat_name = "beef"

/obj/item/food/jerky/meat/get_drying_state()
	return "meat_dried"

/obj/item/food/jerky/cutlet
	name = "dried meat stick"
	desc = "A stick of chewy dried meat. Great for travel rations."
	icon_state = "smallmeatjerky"
	nutriment_amt = 2

/obj/item/food/jerky/cutlet/set_meat_name(new_meat_name)
	. = ..()
	SetName("[name] stick")

/obj/item/food/jerky/cutlet/get_drying_state()
	return "meat_dried_small"

/obj/item/food/jerky/spider
	desc = "A piece of green, stringy dried meat, full of tubes. It smells faintly of acid."
	icon_state = "spiderjerky_charred"
	meat_name = "spider meat"

/obj/item/food/jerky/spider/get_drying_state()
	return "meat_dried"

/obj/item/food/jerky/spider/poison
	icon_state = "spiderjerky"

/obj/item/food/jerky/spider/poison/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/venom, 3)
