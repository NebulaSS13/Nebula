/obj/item/chems/food/snacks/dough
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
/obj/item/chems/food/snacks/dough/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/rollingpin))
		new /obj/item/chems/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3x doughslices
/obj/item/chems/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/chems/food/snacks/doughslice
	slices_num = 3
	center_of_mass = @"{'x':16,'y':16}"

/obj/item/chems/food/snacks/sliceable/flatdough/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment, 3)

/obj/item/chems/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/chems/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = @"{'x':17,'y':19}"
	nutriment_desc = list("dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	nutriment_desc = list("bun" = 4)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

//Items you can craft together. Like bomb making, but with food and less screwdrivers.

/obj/item/chems/food/snacks/bun/attackby(obj/item/W, mob/user)
	// bun + meatball = burger
	if(istype(W,/obj/item/chems/food/snacks/meatball))
		new /obj/item/chems/food/snacks/plainburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// bun + cutlet = hamburger
	else if(istype(W,/obj/item/chems/food/snacks/cutlet))
		new /obj/item/chems/food/snacks/hamburger(src)
		to_chat(user, "You make a hamburger.")
		qdel(W)
		qdel(src)

	// bun + sausage = hotdog
	else if(istype(W,/obj/item/chems/food/snacks/sausage))
		new /obj/item/chems/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

// burger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/plainburger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/snacks/cheesewedge))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Hamburger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/hamburger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/snacks/cheesewedge))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human burger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/human/burger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/snacks/boiledspagetti/attackby(obj/item/chems/food/snacks/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/meatballspagetti(src)
		to_chat(user, "You add some meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/snacks/meatballspagetti/attackby(obj/item/chems/food/snacks/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/spesslaw(src)
		to_chat(user, "You add some more meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/chems/food/snacks/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread