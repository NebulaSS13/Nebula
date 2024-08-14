//////////
// Rice //
//////////

/obj/item/food/boiledrice
	name = "boiled rice"
	desc = "White rice, a very important staple food. Goes excellent with many many things."
	icon = 'icons/obj/food/rice/boiled.dmi'
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @'{"x":17,"y":11}'
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/chazuke
	name = "chazuke"
	desc = "An ancient way of using up day-old rice, this dish is composed of plain green tea poured over plain white rice. Hopefully you have something else to put in."
	icon = 'icons/obj/food/rice/chazuke.dmi'
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f1ffdb"
	nutriment_desc = list("green tea" = 2, "mild rice" = 2)
	bitesize = 3
	nutriment_amt = 5
	nutriment_type = /decl/material/liquid/nutriment/rice

/obj/item/food/chazuke/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/tea/green, 1)

/obj/item/food/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon = 'icons/obj/food/rice/pudding.dmi'
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @'{"x":17,"y":11}'
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 4
	bitesize = 2