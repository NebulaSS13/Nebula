/datum/recipe/spellburger
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/snacks/spellburger

/obj/item/chems/food/snacks/spellburger
	name = "spell burger"
	desc = "This is absolutely magical."
	icon_state = "spellburger"
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

/datum/recipe/ghostburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/chems/food/snacks/ghostburger

/obj/item/chems/food/snacks/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#fff2ff"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2