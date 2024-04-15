/obj/item/chems/food/jerky
	name = "mystery jerky"
	icon = 'icons/obj/food_jerky.dmi'
	bitesize = 2
	w_class = ITEM_SIZE_TINY
	dry = TRUE

/obj/item/chems/food/jerky/fish
	name = "dried fish"
	desc = "A piece of dried fish, with a couple of scales still attached."
	icon_state = "fishjerky"

/obj/item/chems/food/jerky/fish/get_drying_state()
	return "fish_dried"

/obj/item/chems/food/jerky/fish/Initialize()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 5)

/obj/item/chems/food/jerky/meat
	name = "dried meat"
	desc = "A piece of chewy dried meat. It has the texture of leather."
	icon_state = "meatjerky"

/obj/item/chems/food/jerky/meat/get_drying_state()
	return "meat_dried"

/obj/item/chems/food/jerky/meat/Initialize()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 5)


/obj/item/chems/food/jerky/cutlet
	name = "dried meat stick"
	desc = "A stick of chewy dried meat. Great for travel rations."
	icon_state = "smallmeatjerky"

/obj/item/chems/food/jerky/cutlet/get_drying_state()
	return "meat_dried_small"

/obj/item/chems/food/jerky/cutlet/Initialize()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/chems/food/jerky/spider
	name = "dried spider meat"
	desc = "A piece of green, stringy dried meat, full of tubes. It smells faintly of acid."
	icon_state = "spiderjerky_charred"

/obj/item/chems/food/jerky/spider/get_drying_state()
	return "meat_dried"

/obj/item/chems/food/jerky/spider/Initialize()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 5)

/obj/item/chems/food/jerky/spider/poison
	icon_state = "spiderjerky"

/obj/item/chems/food/jerky/spider/poison/Initialize()
	. = ..()
	add_to_reagents(/decl/material/liquid/venom, 3)
