/*
MRE Stuff
 */

/obj/item/mre
	name = "standard MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage = /datum/storage/mre
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	var/main_meal = /obj/item/mrebag
	var/meal_desc = "This one is menu 1, meat pizza."

/obj/item/mre/WillContain()
	. = list(
		main_meal,
		/obj/item/mrebag/dessert,
		/obj/item/box/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/random/mre/sauce,
		/obj/item/utensil/spork/plastic
	)

/obj/item/mre/Initialize(ml, material_key)
	. = ..()
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/mre/examine(mob/user)
	. = ..()
	to_chat(user, meal_desc)

/obj/item/mre/on_update_icon()
	. = ..()
	if(storage?.opened)
		icon_state = "[initial(icon_state)][storage.opened]"

/obj/item/mre/attack_self(mob/user)
	if(storage && !storage.opened)
		storage.open(user)
		return TRUE
	return ..()

/obj/item/mre/menu2
	meal_desc = "This one is menu 2, margherita."
	main_meal = /obj/item/mrebag/menu2

/obj/item/mre/menu3
	meal_desc = "This one is menu 3, vegetable pizza."
	main_meal = /obj/item/mrebag/menu3

/obj/item/mre/menu4
	meal_desc = "This one is menu 4, hamburger."
	main_meal = /obj/item/mrebag/menu4

/obj/item/mre/menu5
	meal_desc = "This one is menu 5, taco."
	main_meal = /obj/item/mrebag/menu5

/obj/item/mre/menu6
	meal_desc = "This one is menu 6, meatbread."
	main_meal = /obj/item/mrebag/menu6

/obj/item/mre/menu7
	meal_desc = "This one is menu 7, salad."
	main_meal = /obj/item/mrebag/menu7

/obj/item/mre/menu8
	meal_desc = " This one is menu 8, hot chili."
	main_meal = /obj/item/mrebag/menu8

/obj/item/mre/menu9
	name = "vegan MRE"
	meal_desc = "This one is menu 9, boiled rice."
	icon_state = "vegmre"
	main_meal = /obj/item/mrebag/menu9

/obj/item/mre/menu9/WillContain()
	. = list(
		main_meal,
		/obj/item/mrebag/dessert/menu9,
		/obj/item/box/fancy/crackers,
		/obj/random/mre/spread/vegan,
		/obj/random/mre/drink,
		/obj/random/mre/sauce/vegan,
		/obj/item/utensil/spoon/plastic
	)

/obj/item/mre/menu10
	name = "protein MRE"
	meal_desc = "This one is menu 10, protein."
	icon_state = "meatmre"
	main_meal = /obj/item/mrebag/menu10

/obj/item/mre/menu10/WillContain()
	. = list(
		main_meal,
		/obj/item/food/candy/proteinbar,
		/obj/item/chems/condiment/small/packet/protein,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/utensil/spoon/plastic
	)

/obj/item/mre/menu11
	name = "crayon MRE"
	meal_desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	main_meal = /obj/item/box/fancy/crayons

/obj/item/mre/menu11/WillContain()
	return list(
		main_meal,
		/obj/item/mrebag/dessert/menu11,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon
	)

/obj/item/mre/menu11/special
	meal_desc = "This one doesn't have a menu listing. How odd. It has the initials \"A.B.\" written on the back."

/obj/item/mre/random
	meal_desc = "The menu label is faded out."
	main_meal = /obj/random/mre/main

/obj/item/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	storage = /datum/storage/mrebag
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE)

/obj/item/mrebag/WillContain()
	return list(/obj/item/food/slice/pizza/meat/filled)

/obj/item/mrebag/on_update_icon()
	. = ..()
	if(storage?.opened)
		icon_state = "[initial(icon_state)][storage.opened]"

/obj/item/mrebag/attack_self(mob/user)
	if(storage && !storage.opened)
		storage.open(user)
		return TRUE
	return ..()

/obj/item/mrebag/menu2/WillContain()
	return list(/obj/item/food/slice/pizza/margherita/filled)

/obj/item/mrebag/menu3/WillContain()
	return list(/obj/item/food/slice/pizza/vegetable/filled)

/obj/item/mrebag/menu4/WillContain()
	return list(/obj/item/food/hamburger)

/obj/item/mrebag/menu5/WillContain()
	return list(/obj/item/food/taco)

/obj/item/mrebag/menu6/WillContain()
	return list(/obj/item/food/slice/meatbread/filled)

/obj/item/mrebag/menu7/WillContain()
	return list(/obj/item/food/tossedsalad)

/obj/item/mrebag/menu8/WillContain()
	return list(/obj/item/food/hotchili)

/obj/item/mrebag/menu9/WillContain()
	return list(/obj/item/food/boiledrice)

/obj/item/mrebag/menu10/WillContain()
	return list(/obj/item/food/meatcube)

/obj/item/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	storage = /datum/storage/mrebag/dessert

/obj/item/mrebag/dessert/WillContain()
	return list(/obj/random/mre/dessert)

/obj/item/mrebag/dessert/menu9/WillContain()
	return list(/obj/item/food/plumphelmetbiscuit)

/obj/item/mrebag/dessert/menu11/WillContain()
	return list(/obj/item/pen/crayon/rainbow)
