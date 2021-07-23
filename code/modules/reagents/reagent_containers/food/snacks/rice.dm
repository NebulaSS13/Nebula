//////////
// Rice //
//////////

/obj/item/chems/food/boiledrice
	name = "boiled rice"
	desc = "White rice, a very important staple food. Goes excellent with many many things."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/boiledrice/chazuke
	name = "chazuke"
	desc = "An ancient way of using up day-old rice, this dish is composed of plain green tea poured over plain white rice. Hopefully you have something else to put in."
	icon_state = "chazuke"
	filling_color = "#f1ffdb"
	nutriment_desc = list("chazuke" = 2)
	bitesize = 3

/obj/item/chems/food/katsucurry
	name = "katsu curry"
	desc = "An oriental curry dish made from apples, potatoes, and carrots. Served with rice and breaded chicken."
	icon_state = "katsu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#faa005"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2, "apple" = 2, "potato" = 2, "carrot" = 2, "bread" = 2, )
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 4
	bitesize = 2