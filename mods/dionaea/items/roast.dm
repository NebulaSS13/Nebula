/obj/item/chems/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754b"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("a chorus of flavor" = 6)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/dionaroast/Initialize()
	.=..()
	reagents.add_reagent(MAT_RADIUM, 2)
