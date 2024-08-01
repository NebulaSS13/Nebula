///////////////////////
// Bread-Based Foods //
///////////////////////

/obj/item/food/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce!"
	icon_state = "sandwich"
	plate = /obj/item/plate
	filling_color = "#d9be29"
	center_of_mass = @'{"x":16,"y":4}'
	nutriment_desc = list("bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2
	backyard_grilling_product = /obj/item/food/toastedsandwich
	backyard_grilling_announcement = "is toasted golden brown."

/obj/item/food/sandwich/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)

/obj/item/food/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	plate = /obj/item/plate
	filling_color = "#d9be29"
	center_of_mass = @'{"x":16,"y":4}'
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/food/toastedsandwich/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)
	add_to_reagents(/decl/material/solid/carbon,             2)

/obj/item/food/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	plate = /obj/item/plate
	filling_color = "#d9be29"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/grilledcheese/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)

/obj/item/food/baguette
	name = "baguette"
	desc = "Good for pretend sword fights."
	icon_state = "baguette"
	filling_color = "#e3d796"
	center_of_mass = @'{"x":18,"y":12}'
	nutriment_desc = list("long bread" = 6)
	nutriment_amt = 6
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/baguette/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/blackpepper,    1)
	add_to_reagents(/decl/material/solid/sodiumchloride, 1)

/obj/item/food/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	plate = /obj/item/plate
	filling_color = "#b572ab"
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 1
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/jelliedtoast/cherry/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/food/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	plate = /obj/item/plate
	filling_color = "#9e3a78"
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 2
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/jellysandwich/cherry/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/food/twobread
	name = "\improper Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#dbcc9a"
	center_of_mass = @'{"x":15,"y":12}'
	nutriment_desc = list("sourness" = 2, "bread" = 2)
	nutriment_amt = 2
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/threebread
	name = "\improper Three Bread"
	desc = "Is such a thing even possible?"
	icon_state = "threebread"
	filling_color = "#dbcc9a"
	center_of_mass = @'{"x":15,"y":12}'
	nutriment_desc = list("sourness" = 2, "bread" = 3)
	nutriment_amt = 3
	bitesize = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":16}'
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread