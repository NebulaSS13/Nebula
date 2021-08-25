/obj/item/chems/food/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("dough" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

// Dough + rolling pin = flat dough
/obj/item/chems/food/dough/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/rollingpin))
		var/obj/item/chems/food/sliceable/flatdough/result = new()
		result.dropInto(loc)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3x doughslices
/obj/item/chems/food/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/chems/food/doughslice
	slices_num = 3
	center_of_mass = @"{'x':16,'y':16}"

/obj/item/chems/food/sliceable/flatdough/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment, 3)

/obj/item/chems/food/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/chems/food/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = @"{'x':17,'y':19}"
	nutriment_desc = list("dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	nutriment_desc = list("bun" = 4)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread
	attack_products = list(
		/obj/item/chems/food/meatball = /obj/item/chems/food/plainburger,
		/obj/item/chems/food/cutlet = /obj/item/chems/food/hamburger,
		/obj/item/chems/food/sausage = /obj/item/chems/food/hotdog
	)

/obj/item/chems/food/plainburger/attack_products = list(/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger)
/obj/item/chems/food/hamburger/attack_products = list(/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger)
/obj/item/chems/food/human/burger/attack_products = list(/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger)

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/boiledspagetti/attack_products = list(/obj/item/chems/food/meatball = /obj/item/chems/food/meatballspagetti)

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/meatballspagetti/attack_products = list(/obj/item/chems/food/meatball = /obj/item/chems/food/spesslaw)

/obj/item/chems/food/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread