///////////
// Soups //
///////////

/obj/item/chems/food/meatballsoup
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	center_of_mass = @"{'x':16,'y':8}"
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/bloodsoup
	name = "tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#ff0000"
	center_of_mass = @"{'x':16,'y':7}"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)
	reagents.add_reagent(/decl/material/liquid/blood, 10)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/clownstears
	name = "clown's tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#c4fbff"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	nutriment_amt = 4
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/clownstears/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/food/vegetablesoup
	name = "vegetable soup"
	desc = "A highly nutritious blend of vegetative goodness. Guaranteed to leave you with a, er, \"souped-up\" sense of wellbeing."
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/vegetablesoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/nettlesoup
	name = "nettle soup"
	desc = "A mean, green, calorically lean dish derived from a poisonous plant. It has a rather acidic bite to its taste."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("salad" = 4, "egg" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/water, 5)
	reagents.add_reagent(/decl/material/liquid/regenerator, 5)

/obj/item/chems/food/mysterysoup
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f082ff"
	center_of_mass = @"{'x':16,'y':6}"
	nutriment_desc = list("backwash" = 1)
	nutriment_amt = 1
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/mysterysoup/proc/get_random_fillings()
	return list(
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/capsaicin =           3,
			/decl/material/liquid/drink/juice/tomato =  2
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/frostoil =            3,
			/decl/material/liquid/drink/juice/tomato =  2
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/water =               5,
			/decl/material/liquid/regenerator =         5
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/water =              10
		),
		list(
			/decl/material/liquid/nutriment =           2,
			/decl/material/liquid/drink/juice/banana = 10
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/blood =              10
		),
		list(
			/decl/material/solid/carbon =              10,
			/decl/material/liquid/bromide =            10
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/drink/juice/tomato = 10
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/drink/juice/tomato =  5,
			/decl/material/liquid/eyedrops =            5
		)
	)

/obj/item/chems/food/mysterysoup/Initialize()
	. = ..()
	var/list/fillings = pick(get_random_fillings())
	for(var/filling in fillings)
		reagents.add_reagent(filling, fillings[filling])

/obj/item/chems/food/wishsoup
	name = "\improper Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d1f4ff"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/water, 10)
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent(/decl/material/liquid/nutriment, 8, list("something good" = 8))

/obj/item/chems/food/hotchili
	name = "hot chili"
	desc = "Sound the fire alarm!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ff3c00"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chilli peppers" = 2, "burning" = 1)
	nutriment_amt = 3
	bitesize = 5

/obj/item/chems/food/hotchili/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/liquid/capsaicin, 3)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)

/obj/item/chems/food/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2b00ff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chilly peppers" = 3)
	nutriment_amt = 3
	trash = /obj/item/trash/snack_bowl
	bitesize = 5

/obj/item/chems/food/coldchili/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/liquid/frostoil, 3)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)

/obj/item/chems/food/tomatosoup
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d92929"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("soup" = 5)
	nutriment_amt = 5
	bitesize = 3
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 10)

/obj/item/chems/food/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9e673a"
	center_of_mass = @"{'x':16,'y':5}"
	nutriment_desc = list("tomato" = 2, "potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	nutriment_amt = 6
	bitesize = 10

/obj/item/chems/food/stew/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 5)
	reagents.add_reagent(/decl/material/liquid/eyedrops, 5)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/milosoup
	name = "milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("soy" = 8)
	nutriment_amt = 8
	bitesize = 4
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/milosoup/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e386bf"
	center_of_mass = @"{'x':17,'y':10}"
	nutriment_desc = list("mushroom" = 8, "milk" = 2)
	nutriment_amt = 8
	bitesize = 3
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fac9ff"
	center_of_mass = @"{'x':15,'y':8}"
	nutriment_desc = list("tomato" = 4, "beet" = 4)
	nutriment_amt = 8
	bitesize = 2
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/beetsoup/Initialize()
	. = ..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))