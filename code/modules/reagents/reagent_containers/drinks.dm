////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/drinks
	name = "drink"
	desc = "Yummy!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_HOLLOW
	possible_transfer_amounts = null
	amount_per_transfer_from_this = 5
	randpixel = 6
	volume = 50
	abstract_type = /obj/item/chems/drinks

	var/filling_states   // List of percentages full that have icons
	var/base_icon = null // Base icon name for fill states

/obj/item/chems/drinks/Initialize()
	base_name ||= name
	. = ..()

/obj/item/chems/drinks/dragged_onto(var/mob/user)
	return attack_self(user)

/obj/item/chems/drinks/attack_self(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		open(user)
	else if(is_edible(user))
		use_on_mob(user, user)
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
	return TRUE

/obj/item/chems/drinks/proc/open(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
		to_chat(user, SPAN_NOTICE("You open \the [src] with an audible pop!"))
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		return TRUE
	return FALSE

/obj/item/chems/drinks/proc/do_open_check(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("You need to open \the [src]!"))
		return FALSE
	return TRUE

/obj/item/chems/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/chems/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	return do_open_check(user) && ..()

/obj/item/chems/drinks/standard_pour_into(var/mob/user, var/atom/target)
	return do_open_check(user) && ..()

/obj/item/chems/drinks/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(!reagents || reagents.total_volume == 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty!"))
	else if (reagents.total_volume <= volume * 0.25)
		to_chat(user, SPAN_NOTICE("\The [src] is almost empty!"))
	else if (reagents.total_volume <= volume * 0.66)
		to_chat(user, SPAN_NOTICE("\The [src] is half full!"))
	else if (reagents.total_volume <= volume * 0.90)
		to_chat(user, SPAN_NOTICE("\The [src] is almost full!"))
	else
		to_chat(user, SPAN_NOTICE("\The [src] is full!"))

/obj/item/chems/drinks/proc/get_filling_state()
	var/percent = round((reagents.total_volume / volume) * 100)
	for(var/k in cached_json_decode(filling_states))
		if(percent <= k)
			return k

/obj/item/chems/drinks/get_base_name()
	. = base_name

/obj/item/chems/drinks/on_update_icon()
	. = ..()
	if(LAZYLEN(reagents?.reagent_volumes) && filling_states)
		add_overlay(overlay_image(icon, "[base_icon][get_filling_state()]", reagents.get_color()))


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/chems/drinks/golden_cup
	desc = "A golden cup."
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	w_class = ITEM_SIZE_HUGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	_base_attack_force = 14

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/chems/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = @'{"x":16,"y":9}'

/obj/item/chems/drinks/milk/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/milk, reagents.maximum_volume)

/obj/item/chems/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = @'{"x":16,"y":9}'

/obj/item/chems/drinks/soymilk/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/milk/soymilk, reagents.maximum_volume)

/obj/item/chems/drinks/milk/smallcarton
	name = "small milk carton"
	volume = 30
	icon_state = "mini-milk"

/obj/item/chems/drinks/milk/smallcarton/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/milk, reagents.maximum_volume)

/obj/item/chems/drinks/milk/smallcarton/chocolate
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."

/obj/item/chems/drinks/milk/smallcarton/chocolate/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/milk/chocolate, reagents.maximum_volume)

/obj/item/chems/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = @'{"x":15,"y":10}'

/obj/item/chems/drinks/coffee/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/coffee, reagents.maximum_volume)

/obj/item/chems/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = @'{"x":15,"y":10}'

/obj/item/chems/drinks/ice/populate_reagents()
	add_to_reagents(/decl/material/solid/ice, reagents.maximum_volume)

/obj/item/chems/drinks/h_chocolate
	name = "cup of hot cocoa"
	desc = "A tall plastic cup of creamy hot chocolate."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = @'{"x":15,"y":13}'

/obj/item/chems/drinks/h_chocolate/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/hot_coco, reagents.maximum_volume)

/obj/item/chems/drinks/dry_ramen
	name = "cup ramen"
	gender = PLURAL
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = @'{"x":16,"y":11}'

/obj/item/chems/drinks/dry_ramen/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/dry_ramen, reagents.maximum_volume)

/obj/item/chems/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = @'{"x":16,"y":12}'

/obj/item/chems/drinks/sillycup/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"


//////////////////////////pitchers, pots, flasks and cups //
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/chems/drinks/teapot
	name = "china teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = @'{"x":17,"y":7}'
	material = /decl/material/solid/stone/ceramic
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/drinks/pitcher
	name = "insulated pitcher"
	desc = "A stainless steel insulated pitcher. Everyone's best friend in the morning."
	icon_state = "pitcher"
	volume = 120
	amount_per_transfer_from_this = 10
	center_of_mass = @'{"x":16,"y":9}'
	filling_states = @"[15,30,50,70,85,100]"
	base_icon = "pitcher"
	material = /decl/material/solid/metal/stainlesssteel
	obj_flags = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE

/obj/item/chems/drinks/flask
	name = "\improper Captain's flask"
	desc = "A metal flask belonging to the captain."
	icon_state = "flask"
	volume = 60
	center_of_mass = @'{"x":17,"y":7}'

/obj/item/chems/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/chems/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/chems/drinks/flask/detflask
	name = "\improper Detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = @'{"x":17,"y":8}'

/obj/item/chems/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = @'{"x":17,"y":7}'

/obj/item/chems/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = @'{"x":15,"y":4}'

//tea and tea accessories
/obj/item/chems/drinks/tea
	name = "cup of tea master item"
	desc = "A tall plastic cup full of the concept and ideal of tea."
	icon_state = "coffee"
	item_state = "coffee"
	center_of_mass = @'{"x":16,"y":14}'
	filling_states = @"[100]"
	base_name = "cup"
	base_icon = "cup"
	volume = 30
	presentation_flags = PRESENTATION_FLAG_NAME

/obj/item/chems/drinks/tea/black
	name = "cup of black tea"
	desc = "A tall plastic cup of hot black tea."

/obj/item/chems/drinks/tea/black/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/tea/black, reagents.maximum_volume)

/obj/item/chems/drinks/tea/green
	name = "cup of green tea"
	desc = "A tall plastic cup of hot green tea."

/obj/item/chems/drinks/tea/green/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/tea/green, reagents.maximum_volume)

/obj/item/chems/drinks/tea/chai
	name = "cup of chai tea"
	desc = "A tall plastic cup of hot chai tea."

/obj/item/chems/drinks/tea/chai/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/tea/chai, reagents.maximum_volume)

