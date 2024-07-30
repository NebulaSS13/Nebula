
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/chems/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = @"[1,5,10]"
	center_of_mass = @'{"x":16,"y":6}'
	randpixel = 6
	volume = 50
	var/obj/item/chems/condiment/is_special_bottle
	var/static/list/special_bottles = list(
		/decl/material/liquid/nutriment/ketchup  = /obj/item/chems/condiment/ketchup,
		/decl/material/liquid/nutriment/barbecue = /obj/item/chems/condiment/barbecue,
		/decl/material/liquid/capsaicin          = /obj/item/chems/condiment/capsaicin,
		/decl/material/liquid/enzyme             = /obj/item/chems/condiment/enzyme,
		/decl/material/liquid/nutriment/soysauce = /obj/item/chems/condiment/small/soysauce,
		/decl/material/liquid/frostoil           = /obj/item/chems/condiment/frostoil,
		/decl/material/solid/sodiumchloride      = /obj/item/chems/condiment/small/saltshaker,
		/decl/material/solid/blackpepper         = /obj/item/chems/condiment/small/peppermill,
		/decl/material/liquid/nutriment/cornoil  = /obj/item/chems/condiment/cornoil,
		/decl/material/liquid/nutriment/sugar    = /obj/item/chems/condiment/sugar,
		/decl/material/liquid/nutriment/mayo     = /obj/item/chems/condiment/mayo,
		/decl/material/liquid/nutriment/vinegar  = /obj/item/chems/condiment/vinegar
	)

/obj/item/chems/condiment/attackby(var/obj/item/W, var/mob/user)
	if(IS_PEN(W))
		var/tmp_label = sanitize_safe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(tmp_label == label_text)
			return
		if(length(tmp_label) > 10)
			to_chat(user, SPAN_NOTICE("The label can be at most 10 characters long."))
		else
			if(length(tmp_label))
				to_chat(user, SPAN_NOTICE("You set the label to \"[tmp_label]\"."))
				label_text = tmp_label
			else
				to_chat(user, SPAN_NOTICE("You remove the label."))
				label_text = null
			update_container_name()
			update_container_desc()
			update_icon()
		return

/obj/item/chems/condiment/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	..()

/obj/item/chems/condiment/proc/update_center_of_mass()
	center_of_mass = is_special_bottle ? initial(is_special_bottle.center_of_mass) : initial(center_of_mass)

/obj/item/chems/condiment/on_reagent_change()
	is_special_bottle = reagents?.total_volume && special_bottles[reagents?.primary_reagent]
	if((. = ..()))
		update_center_of_mass()

/obj/item/chems/condiment/update_container_name()
	name = is_special_bottle ? initial(is_special_bottle.name) : initial(name)
	if(label_text)
		name = addtext(name," ([label_text])")

/obj/item/chems/condiment/update_container_desc()
	desc = is_special_bottle ? initial(is_special_bottle.desc) : initial(desc)

/obj/item/chems/condiment/on_update_icon()
	..()
	if(is_special_bottle)
		icon_state = initial(is_special_bottle.icon_state)
	else if(LAZYLEN(reagents?.reagent_volumes))
		icon_state = "mixedcondiments"
	else
		icon_state = "emptycondiment"

/obj/item/chems/condiment/enzyme
	name = "universal enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/chems/condiment/enzyme/populate_reagents()
	add_to_reagents(/decl/material/liquid/enzyme, reagents.maximum_volume)

/obj/item/chems/condiment/barbecue
	name = "barbecue sauce"
	desc = "Barbecue sauce, it's labeled 'sweet and spicy'"
	icon_state = "barbecue"

/obj/item/chems/condiment/barbecue/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/barbecue, reagents.maximum_volume)

/obj/item/chems/condiment/sugar
	name = "sugar"
	desc = "Cavities in a bottle."

/obj/item/chems/condiment/sugar/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, reagents.maximum_volume)

/obj/item/chems/condiment/ketchup
	name = "ketchup"
	desc = "Tomato, but more liquid, stronger, better."
	icon_state = "ketchup"

/obj/item/chems/condiment/ketchup/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/ketchup, reagents.maximum_volume)

/obj/item/chems/condiment/cornoil
	name = "corn oil"
	desc = "A delicious oil used in cooking. Made from corn."
	icon_state = "oliveoil"

/obj/item/chems/condiment/cornoil/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/cornoil, reagents.maximum_volume)

/obj/item/chems/condiment/vinegar
	name = "vinegar"
	icon_state = "vinegar"
	desc = "As acidic as it gets in the kitchen."

/obj/item/chems/condiment/vinegar/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/vinegar, reagents.maximum_volume)

/obj/item/chems/condiment/mayo
	name = "mayonnaise"
	icon_state = "mayo"
	desc = "Mayonnaise, used for centuries to make things edible."

/obj/item/chems/condiment/mayo/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/mayo, reagents.maximum_volume)

/obj/item/chems/condiment/frostoil
	name = "coldsauce"
	desc = "Leaves the tongue numb in its passage."
	icon_state = "coldsauce"

/obj/item/chems/condiment/frostoil/populate_reagents()
	add_to_reagents(/decl/material/liquid/frostoil, reagents.maximum_volume)

/obj/item/chems/condiment/capsaicin
	name = "hotsauce"
	desc = "You can almost TASTE the stomach ulcers now!"
	icon_state = "hotsauce"

/obj/item/chems/condiment/capsaicin/populate_reagents()
	add_to_reagents(/decl/material/liquid/capsaicin, reagents.maximum_volume)

/obj/item/chems/condiment/small
	name = "small condiment container"
	possible_transfer_amounts = @"[1,2,5,8,10,20]"
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/chems/condiment/small/update_center_of_mass()
	return

/obj/item/chems/condiment/small/update_container_name()
	return

/obj/item/chems/condiment/small/update_container_desc()
	return

/obj/item/chems/condiment/small/on_update_icon()
	return

/obj/item/chems/condiment/small/saltshaker
	name = "salt shaker"
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	center_of_mass = @'{"x":16,"y":9}'

/obj/item/chems/condiment/small/saltshaker/populate_reagents()
	add_to_reagents(/decl/material/solid/sodiumchloride, reagents.maximum_volume)

/obj/item/chems/condiment/small/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	center_of_mass = @'{"x":16,"y":8}'

/obj/item/chems/condiment/small/peppermill/populate_reagents()
	add_to_reagents(/decl/material/solid/blackpepper, reagents.maximum_volume)

/obj/item/chems/condiment/small/sugar
	name = "sugar"
	desc = "Sweetness in a bottle"
	icon_state = "sugarsmall"
	center_of_mass = @'{"x":17,"y":9}'

/obj/item/chems/condiment/small/sugar/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, reagents.maximum_volume)

/obj/item/chems/condiment/small/mint
	name = "mint essential oil"
	desc = "A small bottle of the essential oil of some kind of mint plant."
	icon = 'icons/obj/food.dmi'
	icon_state = "coldsauce"

/obj/item/chems/condiment/small/mint/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/syrup/mint, reagents.maximum_volume)

/obj/item/chems/condiment/small/soysauce
	name = "soy sauce"
	desc = "A dark, salty, savoury flavoring."
	icon_state = "soysauce"

/obj/item/chems/condiment/small/soysauce/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/soysauce, reagents.maximum_volume)

//MRE condiments and drinks.

/obj/item/chems/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEM_SIZE_TINY
	possible_transfer_amounts = @"[1,2,5,10]"
	amount_per_transfer_from_this = 1
	volume = 10

/obj/item/chems/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"

/obj/item/chems/condiment/small/packet/salt/populate_reagents()
	add_to_reagents(/decl/material/solid/sodiumchloride, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"

/obj/item/chems/condiment/small/packet/pepper/populate_reagents()
	add_to_reagents(/decl/material/solid/blackpepper, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"

/obj/item/chems/condiment/small/packet/sugar/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	icon_state = "packet_medium"

/obj/item/chems/condiment/small/packet/jelly/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	icon_state = "packet_medium"

/obj/item/chems/condiment/small/packet/honey/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"

/obj/item/chems/condiment/small/packet/capsaicin/populate_reagents()
	add_to_reagents(/decl/material/liquid/capsaicin, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"

/obj/item/chems/condiment/small/packet/ketchup/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/ketchup, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"

/obj/item/chems/condiment/small/packet/mayo/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/mayo, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"

/obj/item/chems/condiment/small/packet/soy/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/soysauce, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/coffee
	name = "instant coffee powder packet"
	desc = "Contains 5u of instant coffee powder. Mix with 25u of water."

/obj/item/chems/condiment/small/packet/coffee/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/coffee/instant, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/tea
	name = "instant tea powder packet"
	desc = "Contains 5u of instant black tea powder. Mix with 25u of water."

/obj/item/chems/condiment/small/packet/tea/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/tea/instant, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."

/obj/item/chems/condiment/small/packet/cocoa/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/coco, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."

/obj/item/chems/condiment/small/packet/grape/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/grape, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."

/obj/item/chems/condiment/small/packet/orange/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/orange, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."

/obj/item/chems/condiment/small/packet/watermelon/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/watermelon, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."

/obj/item/chems/condiment/small/packet/apple/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/apple, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon_state = "packet_medium"

/obj/item/chems/condiment/small/packet/protein/populate_reagents()
	add_to_reagents(/decl/material/solid/organic/meat, reagents.maximum_volume/2)

/obj/item/chems/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."

/obj/item/chems/condiment/small/packet/crayon/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/red/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/red, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/orange/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/orange, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/yellow/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/yellow, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/green/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/green, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/blue/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/blue, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/purple/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/purple, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/grey/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/grey, reagents.maximum_volume)

/obj/item/chems/condiment/small/packet/crayon/brown/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/brown, reagents.maximum_volume)

//End of MRE stuff.

/obj/item/chems/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	randpixel = 10

/obj/item/chems/condiment/flour/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/flour, reagents.maximum_volume)

/obj/item/chems/condiment/flour/update_container_name()
	return

/obj/item/chems/condiment/flour/update_container_desc()
	return

/obj/item/chems/condiment/flour/on_update_icon()
	return

/obj/item/chems/condiment/large
	name = "large condiment container"
	possible_transfer_amounts = @"[1,5,10,20,50,100]"
	volume = 500
	w_class = ITEM_SIZE_LARGE

/obj/item/chems/condiment/large/salt
	name = "big bag of salt"
	desc = "A nonsensically large bag of salt. Carefully refined from countless shifts."
	icon = 'icons/obj/food.dmi'
	icon_state = "salt"
	item_state = "flour"
	randpixel = 10

/obj/item/chems/condiment/large/salt/populate_reagents()
	add_to_reagents(/decl/material/solid/sodiumchloride, reagents.maximum_volume)

/obj/item/chems/condiment/large/salt/update_container_name()
	return

/obj/item/chems/condiment/large/salt/update_container_desc()
	return

/obj/item/chems/condiment/large/salt/on_update_icon()
	return
