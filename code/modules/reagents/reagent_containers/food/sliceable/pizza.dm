///////////
// PIZZA //
///////////

/obj/item/chems/food/sliceable/pizza
	slices_num = 6
	filling_color = "#baa14c"

/obj/item/chems/food/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/chems/food/slice/margherita
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 35
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/pizza/margherita/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein,  5)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 6)

/obj/item/chems/food/slice/margherita
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/pizza/margherita

/obj/item/chems/food/slice/margherita/filled
	filled = TRUE

/obj/item/chems/food/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/chems/food/slice/meatpizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/pizza/meatpizza/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein,  34)
	reagents.add_reagent(/decl/material/liquid/nutriment/barbecue, 6)

/obj/item/chems/food/slice/meatpizza
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/pizza/meatpizza

/obj/item/chems/food/slice/meatpizza/filled
	filled = TRUE

/obj/item/chems/food/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/chems/food/slice/mushroompizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "mushroom" = 10)
	nutriment_amt = 35
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/pizza/mushroompizza/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein,  5)

/obj/item/chems/food/slice/mushroompizza
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/pizza/mushroompizza

/obj/item/chems/food/slice/mushroompizza/filled
	filled = TRUE

/obj/item/chems/food/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "Vegetarian pizza huh? What about all the plants that were slaughtered to make this huh?? Hypocrite."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/chems/food/slice/vegetablepizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/sliceable/pizza/vegetablepizza/populate_reagents()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein,  5)
	reagents.add_reagent(/decl/material/liquid/nutriment/ketchup,  6)
	reagents.add_reagent(/decl/material/liquid/eyedrops,           12)

/obj/item/chems/food/slice/vegetablepizza
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/sliceable/pizza/vegetablepizza

/obj/item/chems/food/slice/vegetablepizza/filled
	filled = TRUE

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"
	material = /decl/material/solid/cardboard
	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/chems/food/sliceable/pizza/pizza // content pizza
	var/list/boxes = list()// If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/Initialize(ml, material_key)
	. = ..()
	if(ispath(pizza))
		pizza = new pizza(src)

/obj/item/pizzabox/on_update_icon()
	. = ..()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/mutable_appearance/pizzaimg = new(pizza)
			pizzaimg.pixel_y = -3
			add_overlay(pizzaimg)
		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			add_overlay(image("food.dmi", "pizzabox_tag", pixel_y = (boxes.len * 3)))

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand(mob/user)

	if(open && pizza)
		if(user.check_dexterity(DEXTERITY_GRIP))
			user.put_in_hands(pizza)
			to_chat(user, SPAN_NOTICE("You take \the [src.pizza] out of \the [src]."))
			pizza = null
			update_icon()
		return TRUE

	if(length(boxes) && user.is_holding_offhand(src) && user.check_dexterity(DEXTERITY_GRIP))
		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box
		user.put_in_hands(box)
		to_chat(user, SPAN_WARNING("You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return TRUE

	return ..()

/obj/item/pizzabox/attack_self(mob/user)

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby(obj/item/I, mob/user)
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				if(!user.try_unequip(box, src))
					return TRUE
				box.boxes = list()// clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, "<span class='warning'>You put \the [box] ontop of \the [src]!</span>")
			else
				to_chat(user, "<span class='warning'>The stack is too high!</span>")
		else
			to_chat(user, "<span class='warning'>Close \the [box] first!</span>")

		return TRUE

	if( istype(I, /obj/item/chems/food/sliceable/pizza/) )

		if( src.open )
			if(!user.try_unequip(I, src))
				return TRUE
			src.pizza = I

			update_icon()

			to_chat(user, "<span class='warning'>You put \the [I] in \the [src]!</span>")
		else
			to_chat(user, "<span class='warning'>You try to push \the [I] through the lid but it doesn't work!</span>")
		return TRUE

	if(IS_PEN(I))

		if( src.open )
			return TRUE

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return TRUE
	return ..()

/obj/item/pizzabox/margherita
	pizza = /obj/item/chems/food/sliceable/pizza/margherita
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable
	pizza = /obj/item/chems/food/sliceable/pizza/vegetablepizza
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom
	pizza = /obj/item/chems/food/sliceable/pizza/mushroompizza
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat
	pizza = /obj/item/chems/food/sliceable/pizza/meatpizza
	boxtag = "Meatlover's Supreme"