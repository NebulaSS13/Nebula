//inedible old vendor food

/obj/item/chems/food/old
	name = "master old-food"
	desc = "they're all inedible and potentially dangerous items"
	center_of_mass = @"{'x':15,'y':12}"
	nutriment_desc = list("rot" = 5, "mold" = 5)
	nutriment_amt = 10
	bitesize = 3
	filling_color = "#336b42"

/obj/item/chems/food/old/Initialize()
	. = ..()
	reagents.add_reagent(pick(list(
				/decl/material/liquid/fuel,
				/decl/material/liquid/amatoxin,
				/decl/material/liquid/carpotoxin,
				/decl/material/liquid/zombiepowder,
				/decl/material/liquid/presyncopics,
				/decl/material/liquid/psychotropics)), 5)


/obj/item/chems/food/old/pizza
	name = "pizza"
	desc = "It's so stale you could probably cut something with the cheese."
	icon_state = "ancient_pizza"

/obj/item/chems/food/old/burger
	name = "\improper Giga Burger!"
	desc = "At some point in time this probably looked delicious."
	icon_state = "ancient_burger"

/obj/item/chems/food/old/hamburger
	name = "\improper Horse Burger!"
	desc = "Even if you were hungry enough to eat a horse, it'd be a bad idea to eat this."
	icon_state = "ancient_hburger"

/obj/item/chems/food/old/fries
	name = "chips"
	desc = "The salt appears to have preserved these, still stale and gross."
	icon_state = "ancient_fries"

/obj/item/chems/food/old/hotdog
	name = "hotdog"
	desc = "This one is probably only marginally less safe to eat than when it was first created.."
	icon_state = "ancient_hotdog"

/obj/item/chems/food/old/taco
	name = "taco"
	desc = "Interestingly, the shell has gone soft and the contents have gone stale."
	icon_state = "ancient_taco"