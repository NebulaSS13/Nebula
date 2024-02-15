/*
MRE Stuff
 */

/obj/item/storage/mre
	name = "standard MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	var/main_meal = /obj/item/storage/mrebag
	var/meal_desc = "This one is menu 1, meat pizza."

/obj/item/storage/mre/WillContain()
	. = list(
		main_meal,
		/obj/item/storage/mrebag/dessert,
		/obj/item/storage/box/fancy/crackers,
		/obj/random/mre/spread,
		/obj/random/mre/drink,
		/obj/random/mre/sauce,
		/obj/item/utensil/spork/plastic
	)

/obj/item/storage/mre/Initialize(ml, material_key)
	. = ..()
	if(length(contents))
		make_exact_fit()

/obj/item/storage/mre/examine(mob/user)
	. = ..()
	to_chat(user, meal_desc)

/obj/item/storage/mre/on_update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"

/obj/item/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/storage/mre/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
	. = ..()

/obj/item/storage/mre/menu2
	meal_desc = "This one is menu 2, margherita."
	main_meal = /obj/item/storage/mrebag/menu2

/obj/item/storage/mre/menu3
	meal_desc = "This one is menu 3, vegetable pizza."
	main_meal = /obj/item/storage/mrebag/menu3

/obj/item/storage/mre/menu4
	meal_desc = "This one is menu 4, hamburger."
	main_meal = /obj/item/storage/mrebag/menu4

/obj/item/storage/mre/menu5
	meal_desc = "This one is menu 5, taco."
	main_meal = /obj/item/storage/mrebag/menu5

/obj/item/storage/mre/menu6
	meal_desc = "This one is menu 6, meatbread."
	main_meal = /obj/item/storage/mrebag/menu6

/obj/item/storage/mre/menu7
	meal_desc = "This one is menu 7, salad."
	main_meal = /obj/item/storage/mrebag/menu7

/obj/item/storage/mre/menu8
	meal_desc = " This one is menu 8, hot chili."
	main_meal = /obj/item/storage/mrebag/menu8

/obj/item/storage/mre/menu9
	name = "vegan MRE"
	meal_desc = "This one is menu 9, boiled rice."
	icon_state = "vegmre"
	main_meal = /obj/item/storage/mrebag/menu9

/obj/item/storage/mre/menu9/WillContain()
	. = list(
		main_meal,
		/obj/item/storage/mrebag/dessert/menu9,
		/obj/item/storage/box/fancy/crackers,
		/obj/random/mre/spread/vegan,
		/obj/random/mre/drink,
		/obj/random/mre/sauce/vegan,
		/obj/item/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu10
	name = "protein MRE"
	meal_desc = "This one is menu 10, protein."
	icon_state = "meatmre"
	main_meal = /obj/item/storage/mrebag/menu10

/obj/item/storage/mre/menu10/WillContain()
	. = list(
		main_meal,
		/obj/item/chems/food/candy/proteinbar,
		/obj/item/chems/condiment/small/packet/protein,
		/obj/random/mre/sauce/sugarfree,
		/obj/item/utensil/spoon/plastic
	)

/obj/item/storage/mre/menu11
	name = "crayon MRE"
	meal_desc = "This one doesn't have a menu listing. How very odd."
	icon_state = "crayonmre"
	main_meal = /obj/item/storage/box/fancy/crayons

/obj/item/storage/mre/menu11/WillContain()
	return list(
		main_meal,
		/obj/item/storage/mrebag/dessert/menu11,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon,
		/obj/random/mre/sauce/crayon
	)

/obj/item/storage/mre/menu11/special
	meal_desc = "This one doesn't have a menu listing. How odd. It has the initials \"A.B.\" written on the back."

/obj/item/storage/mre/random
	meal_desc = "The menu label is faded out."
	main_meal = /obj/random/mre/main

/obj/item/storage/mrebag
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	storage_slots = 1
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/bubbles.ogg'
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE)

/obj/item/storage/mrebag/WillContain()
	return list(/obj/item/chems/food/slice/pizza/meat/filled)

/obj/item/storage/mrebag/on_update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)][opened]"

/obj/item/storage/mrebag/attack_self(mob/user)
	open(user)

/obj/item/storage/mrebag/open(mob/user)
	if(!opened)
		to_chat(usr, "<span class='notice'>The pouch heats up as you break the vaccum seal.</span>")
	. = ..()

/obj/item/storage/mrebag/menu2/WillContain()
	return list(/obj/item/chems/food/slice/pizza/margherita/filled)

/obj/item/storage/mrebag/menu3/WillContain()
	return list(/obj/item/chems/food/slice/pizza/vegetable/filled)

/obj/item/storage/mrebag/menu4/WillContain()
	return list(/obj/item/chems/food/hamburger)

/obj/item/storage/mrebag/menu5/WillContain()
	return list(/obj/item/chems/food/taco)

/obj/item/storage/mrebag/menu6/WillContain()
	return list(/obj/item/chems/food/slice/meatbread/filled)

/obj/item/storage/mrebag/menu7/WillContain()
	return list(/obj/item/chems/food/tossedsalad)

/obj/item/storage/mrebag/menu8/WillContain()
	return list(/obj/item/chems/food/hotchili)

/obj/item/storage/mrebag/menu9/WillContain()
	return list(/obj/item/chems/food/boiledrice)

/obj/item/storage/mrebag/menu10/WillContain()
	return list(/obj/item/chems/food/meatcube)

/obj/item/storage/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	open_sound = 'sound/effects/rip1.ogg'

/obj/item/storage/mrebag/dessert/WillContain()
	return list(/obj/random/mre/dessert)

/obj/item/storage/mrebag/dessert/menu9/WillContain()
	return list(/obj/item/chems/food/plumphelmetbiscuit)

/obj/item/storage/mrebag/dessert/menu11/WillContain()
	return list(/obj/item/pen/crayon/rainbow)
