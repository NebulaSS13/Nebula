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
		new /obj/item/chems/food/sliceable/flatdough(src)
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

//Items you can craft together. Like bomb making, but with food and less screwdrivers.
/obj/item/chems/food/bun/attackby(obj/item/W, mob/user)
	// bun + meatball = burger
	if(istype(W,/obj/item/chems/food/meatball))
		new /obj/item/chems/food/plainburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// bun + cutlet = hamburger
	else if(istype(W,/obj/item/chems/food/cutlet))
		new /obj/item/chems/food/hamburger(src)
		to_chat(user, "You make a hamburger.")
		qdel(W)
		qdel(src)

	// bun + sausage = hotdog
	else if(istype(W,/obj/item/chems/food/sausage))
		new /obj/item/chems/food/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

// burger + cheese wedge = cheeseburger
/obj/item/chems/food/plainburger/attackby(var/obj/item/chems/food/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/cheesewedge))
		new /obj/item/chems/food/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Hamburger + cheese wedge = cheeseburger
/obj/item/chems/food/hamburger/attackby(var/obj/item/chems/food/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/cheesewedge))
		new /obj/item/chems/food/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human burger + cheese wedge = cheeseburger
/obj/item/chems/food/human/burger/attackby(var/obj/item/chems/food/cheesewedge/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/boiledspagetti/attackby(var/obj/item/chems/food/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/meatballspagetti(src)
		to_chat(user, "You add some meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/meatballspagetti/attackby(var/obj/item/chems/food/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/spesslaw(src)
		to_chat(user, "You add some more meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/chems/food/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread