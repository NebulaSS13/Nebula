/obj/item/chems/food/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211f02"
	center_of_mass = @"{'x':16,'y':12}"
	bitesize = 2

/obj/item/chems/food/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/bromide, 1)
	reagents.add_reagent(/decl/material/solid/carbon, 3)

/obj/item/chems/food/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#c9ac83"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_amt = 3
	nutriment_desc = list("dryness" = 2, "bread" = 2)
	bitesize = 1

/obj/item/chems/food/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	filling_color = "#fffad4"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("popcorn" = 3)
	nutriment_amt = 2
	bitesize = 0.1

/obj/item/chems/food/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9c7a68"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("baked potato" = 3)
	nutriment_amt = 3
	bitesize = 2

/obj/item/chems/food/loadedbakedpotato/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/spacylibertyduff
	name = "party jelly"
	desc = "LoOk aT aLl tHe PrEtTy CoLoUrS"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42b873"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("mushroom" = 5, "rainbow" = 1)
	nutriment_amt = 6
	bitesize = 3

/obj/item/chems/food/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/psychotropics, 6)

/obj/item/chems/food/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ed0758"
	center_of_mass = @"{'x':16,'y':5}"
	nutriment_desc = list("jelly" = 3, "mushroom" = 3)
	nutriment_amt = 6
	bitesize = 3

/obj/item/chems/food/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/amatoxin, 6)
	reagents.add_reagent(/decl/material/liquid/psychotropics, 3)

/obj/item/chems/food/enchiladas
	name = "enchiladas"
	desc = "Not to be confused with an echidna, though I don't know how you would."
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#a36a1f"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("tortilla" = 3, "corn" = 3)
	nutriment_amt = 2
	bitesize = 4

/obj/item/chems/food/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)
	reagents.add_reagent(/decl/material/liquid/capsaicin, 6)

/obj/item/chems/food/monkeysdelight
	name = "monkey's delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5c3c11"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 6

/obj/item/chems/food/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)
	reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 5)
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)

/obj/item/chems/food/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#f21873"
	center_of_mass = @"{'x':15,'y':13}"
	nutriment_desc = list("apple" = 3, "caramel" = 3, "sweetness" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/chems/food/mint
	name = "mint"
	desc = "A tasty after-dinner mint. It is only wafer thin."
	icon_state = "mint"
	filling_color = "#f2f2f2"
	center_of_mass = @"{'x':16,'y':14}"
	bitesize = 1

/obj/item/chems/food/mint/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/syrup/mint, 1)

/obj/item/chems/food/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#cfb4c4"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("mushroom" = 4)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent(/decl/material/liquid/nutriment, 3)
		reagents.add_reagent(/decl/material/liquid/regenerator, 5)

/obj/item/chems/food/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#ffff00"
	center_of_mass = @"{'x':16,'y':18}"
	nutriment_desc = list("apple" = 8)
	nutriment_amt = 8
	bitesize = 3

/obj/item/chems/food/appletart/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/metal/gold, 5)

/obj/item/chems/food/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#f5deb8"
	center_of_mass = @"{'x':17,'y':6}"
	nutriment_desc = list("salt" = 1, "cracker" = 2)
	w_class = ITEM_SIZE_TINY
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

/obj/item/chems/food/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	center_of_mass = @"{'x':21,'y':12}"
	nutriment_desc = list("cheese" = 2,"taco shell" = 2)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/taco/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/pelmen
	name = "meat pelmen"
	desc = "Raw meat appetizer."
	icon_state = "pelmen"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2

/obj/item/chems/food/pelmen/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)

/obj/item/chems/food/pelmeni_boiled
	name = "boiled pelmeni"
	desc = "A dish consisting of boiled pieces of meat wrapped in dough. Delicious!"
	icon_state = "pelmeni_boiled"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2

/obj/item/chems/food/pelmeni_boiled/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 30)
