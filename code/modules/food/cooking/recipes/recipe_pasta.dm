// Notes on process:
// - Boil pasta
// - Put pasta on plate
// - Boil or simmer sauce
// - Put sauce in pasta

/decl/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/spagetti)
	result = /obj/item/chems/food/pastatomato

/decl/recipe/meatballspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 2,
	)
	result = /obj/item/chems/food/meatballspagetti

/decl/recipe/spesslaw
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 4,
	)
	result = /obj/item/chems/food/spesslaw

/decl/recipe/nanopasta
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/stack/nanopaste
	)
	result = /obj/item/chems/food/nanopasta
