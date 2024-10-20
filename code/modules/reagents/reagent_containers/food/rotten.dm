//inedible old vendor food

/obj/item/food/old
	name = "master old-food"
	desc = "they're all inedible and potentially dangerous items"
	center_of_mass = @'{"x":15,"y":12}'
	nutriment_desc = list("rot" = 5, "mold" = 5)
	nutriment_amt = 10
	bitesize = 3
	filling_color = "#336b42"
	abstract_type = /obj/item/food/old

/obj/item/food/old/populate_reagents()
	. = ..()
	add_to_reagents(pick(
				/decl/material/liquid/fuel,
				/decl/material/liquid/amatoxin,
				/decl/material/liquid/carpotoxin,
				/decl/material/liquid/zombiepowder,
				/decl/material/liquid/presyncopics,
				/decl/material/liquid/psychotropics), 5)

/obj/item/food/old/pizza
	name = "pizza"
	desc = "It's so stale you could probably cut something with the cheese."
	icon = 'icons/obj/food/old/pizza.dmi'

/obj/item/food/old/burger
	name = "\improper Giga Burger!"
	desc = "At some point in time this probably looked delicious."
	icon = 'icons/obj/food/old/burger.dmi'

/obj/item/food/old/hamburger
	name = "\improper Horse Burger!"
	desc = "Even if you were hungry enough to eat a horse, it'd be a bad idea to eat this."
	icon = 'icons/obj/food/old/hamburger.dmi'

/obj/item/food/old/fries
	name = "chips"
	desc = "The salt appears to have preserved these, still stale and gross."
	icon = 'icons/obj/food/old/fries.dmi'

/obj/item/food/old/hotdog
	name = "hotdog"
	desc = "This is probably only marginally less safe to eat than when it was first created."
	icon = 'icons/obj/food/old/hotdog.dmi'

/obj/item/food/old/taco
	name = "taco"
	desc = "Interestingly, the shell has gone soft and the contents have gone stale."
	icon = 'icons/obj/food/old/taco.dmi'
