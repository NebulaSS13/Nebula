// Processed meats
/obj/item/chems/food/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	center_of_mass = @'{"x":17,"y":20}'
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/rawcutlet/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 1)

/obj/item/chems/food/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	center_of_mass = @'{"x":17,"y":20}'
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/cutlet/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":15}'
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/rawmeatball/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/meatball/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/plainsteak
	name = "plain steak"
	desc = "A piece of unseasoned cooked meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "steak"
	slice_path = /obj/item/chems/food/cutlet
	slices_num = 3
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 3
	material = /decl/material/solid/organic/meat
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE

/obj/item/chems/food/plainsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/meatsteak
	name = "meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	plate = /obj/item/plate
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/meatsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 4)
	add_to_reagents(/decl/material/solid/sodiumchloride,     1)
	add_to_reagents(/decl/material/solid/blackpepper,        1)

/obj/item/chems/food/meatsteak/synthetic
	name = "meaty steak"
	desc = "A piece of hot spicy pseudo-meat."

/obj/item/chems/food/loadedsteak
	name = "loaded steak"
	desc = "A steak slathered in sauce with sauteed onions and mushrooms."
	icon_state = "meatstake"
	plate = /obj/item/plate
	filling_color = "#7a3d11"
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("onion" = 2, "mushroom" = 2)
	nutriment_amt = 4
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/loadedsteak/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein,     2)
	add_to_reagents(/decl/material/liquid/nutriment/garlicsauce, 2)

/obj/item/chems/food/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	filling_color = "#db0000"
	center_of_mass = @'{"x":17,"y":16}'
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

/obj/item/chems/food/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/bearmeat/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein,     12)
	add_to_reagents(/decl/material/liquid/amphetamines,           5)

/obj/item/chems/food/spider
	name = "giant spider leg"
	desc = "An economical replacement for crab. In space! Would probably be a lot nicer cooked."
	icon_state = "spiderleg"
	filling_color = "#d5f5dc"
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 3
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/spider/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 9)

/obj/item/chems/food/spider/cooked
	name = "boiled spider meat"
	desc = "An economical replacement for crab. In space!"
	icon_state = "spiderleg_c"
	bitesize = 5

/obj/item/chems/food/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43de18"
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 6
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/xenomeat/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 6)
	add_to_reagents(/decl/material/liquid/acid/polyacid,     6)

/obj/item/chems/food/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/sausage/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/fatsausage
	name = "spiced sausage"
	desc = "A piece of mixed, long meat, with some bite to it."
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 2
	material = /decl/material/solid/organic/meat

/obj/item/chems/food/fatsausage/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/organ
	name = "organ"
	desc = "It's good for you, probably."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#e00d34"
	center_of_mass = @'{"x":16,"y":16}'
	bitesize = 3

/obj/item/chems/food/organ/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, rand(3,5))
	add_to_reagents(/decl/material/gas/ammonia,              rand(1,3)) // you probably should not be eating raw organ meat

/obj/item/chems/food/meatkabob
	name = "meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#a85340"
	center_of_mass = @'{"x":17,"y":15}'
	bitesize = 2

/obj/item/chems/food/meatkabob/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/protein, 8)