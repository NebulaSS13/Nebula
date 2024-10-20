//////////////////
// Veggie Foods //
//////////////////

/obj/item/food/aesirsalad
	name = "\improper Aether salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon = 'icons/obj/food/salads/salad.dmi'
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468c00"
	center_of_mass = @'{"x":17,"y":11}'
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 4, "quintessence" = 2)
	bitesize = 3

/obj/item/food/aesirsalad/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/regenerator, 8)

/obj/item/food/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon = 'icons/obj/food/salads/salad.dmi'
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = @'{"x":17,"y":11}'
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/food/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon = 'icons/obj/food/salads/salad.dmi'
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = @'{"x":17,"y":11}'
	nutriment_desc = list("100% real salad")
	nutriment_amt = 6
	bitesize = 3

/obj/item/food/validsalad/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/food/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon = 'icons/obj/food/butchery/mushroom.dmi'
	filling_color = "#e0d7c5"
	center_of_mass = @'{"x":17,"y":16}'
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "mushroom" = 2)
	bitesize = 6

/obj/item/food/hugemushroomslice/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/psychotropics, 3)
