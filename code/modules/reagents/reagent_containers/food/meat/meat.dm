/obj/item/food/meatball/raw/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/food/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon = 'icons/obj/food/butchery/meatball.dmi'
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/food/meatball/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)

/obj/item/food/meatball/raw
	desc = "A raw meatball."
	icon = 'icons/obj/food/butchery/rawmeatball.dmi'
	cooked_food = FOOD_RAW
	backyard_grilling_product = /obj/item/food/meatball
	backyard_grilling_announcement = "sizzles as it is grilled through."

/obj/item/food/plainsteak
	name = "plain steak"
	desc = "A piece of unseasoned cooked meat."
	icon = 'icons/obj/food/butchery/steak.dmi'
	slice_path = /obj/item/food/butchery/cutlet
	slice_num = 3
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 3
	material = /decl/material/solid/organic/meat
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE

/obj/item/food/plainsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)

/obj/item/food/meatsteak/grilled
	plate = null

/obj/item/food/meatsteak/grilled/add_seasoning()
	return

/obj/item/food/meatsteak
	name = "meat steak"
	desc = "A slab of meat, cooked medium-rare."
	icon = 'icons/obj/food/butchery/steak.dmi'
	plate = /obj/item/plate
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/food/meatsteak/proc/add_seasoning()
	add_to_reagents(/decl/material/solid/sodiumchloride, 1)
	add_to_reagents(/decl/material/solid/blackpepper,    1)

/obj/item/food/meatsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)
	add_seasoning()

/obj/item/food/meatsteak/synthetic
	name = "meaty steak"
	desc = "A piece of hot spicy pseudo-meat."

/obj/item/food/loadedsteak
	name = "loaded steak"
	desc = "A steak slathered in sauce with sauteed onions and mushrooms."
	icon = 'icons/obj/food/butchery/steak.dmi' // Missing icon state?
	plate = /obj/item/plate
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("onion" = 2, "mushroom" = 2)
	nutriment_amt = 4
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/food/loadedsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat,     2)
	add_to_reagents(/decl/material/liquid/nutriment/garlicsauce, 2)

/obj/item/food/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon = 'icons/obj/food/butchery/tomato.dmi'
	filling_color = "#db0000"
	center_of_mass = @'{"x":17,"y":16}'
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

// Shouldn't this be poisonous?
/obj/item/food/spider
	name = "giant spider leg"
	desc = "An economical replacement for crab. In space! Would probably be a lot nicer cooked."
	icon = 'icons/obj/food/butchery/spider_leg.dmi'
	filling_color = "#d5f5dc"
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 3
	material = /decl/material/solid/organic/meat
	drying_wetness = 60
	dried_type = /obj/item/food/jerky/spider/poison
	backyard_grilling_product = /obj/item/food/spider/charred
	backyard_grilling_announcement = "smokes as the poison burns away."

/obj/item/food/spider/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat/xeno, 9)

/obj/item/food/spider/charred
	name = "charred spider meat"
	desc = "A slab of green meat with char lines. The poison has been burned out of it."
	color = COLOR_RED_LIGHT
	backyard_grilling_product = /obj/item/food/badrecipe
	dried_product_takes_color = FALSE
	dried_type = /obj/item/food/jerky/spider

/obj/item/food/spider/cooked
	name = "boiled spider meat"
	desc = "An economical replacement for crab. In space!"
	icon = 'icons/obj/food/butchery/spider_leg_cooked.dmi'
	bitesize = 5

/obj/item/food/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food/butchery/sausage.dmi'
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/food/sausage/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 6)

/obj/item/food/fatsausage
	name = "spiced sausage"
	desc = "A piece of mixed, long meat, with some bite to it."
	icon = 'icons/obj/food/butchery/sausage.dmi'
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/food/fatsausage/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 8)

/obj/item/food/organ
	name = "organ"
	desc = "It's good for you, probably."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#e00d34"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 3

/obj/item/food/organ/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, rand(3,5))
	add_to_reagents(/decl/material/gas/ammonia,              rand(1,3)) // you probably should not be eating raw organ meat
