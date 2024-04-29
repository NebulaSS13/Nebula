/// Items you can craft together. Like bomb making, but with food and less screwdrivers.
/// Uses format list(ingredient = result_type).
/// The ingredient can be a typepath or a grown_tag string (used for mobs or plants)
/// The product can be a typepath or a list of typepaths, which will prompt the user.
/// TODO: validate that these products are properly ordered
/obj/item/chems/food/proc/get_combined_food_products()
	return

/obj/item/chems/food/attackby(obj/item/W, mob/living/user)

	if(W?.storage)
		return ..()

	// Plating food.
	if(istype(W, /obj/item/plate))
		var/obj/item/plate/plate = W
		if(plate.try_plate_food(src, user))
			return TRUE

	// Eating with forks
	if(user.a_intent == I_HELP && do_utensil_interaction(W, user))
		return TRUE

	// Hiding items inside larger food items.
	if(user.a_intent != I_HURT && is_sliceable() && W.w_class < w_class && !is_robot_module(W) && !istype(W, /obj/item/chems/condiment))
		if(user.try_unequip(W, src))
			to_chat(user, SPAN_NOTICE("You slip \the [W] inside \the [src]."))
			add_fingerprint(user)
			W.forceMove(src)
		return TRUE

	// Creating food combinations.
	if(try_create_combination(W, user))
		return TRUE

	return ..()

/obj/item/chems/food/proc/get_grown_tag()
	return

/obj/item/chems/food/proc/try_create_combination(obj/item/W, mob/user)
	if(!length(get_combined_food_products()) || !istype(W) || QDELETED(src) || QDELETED(W))
		return FALSE

	// See if we can make anything with this.
	var/list/combined_food_products = get_combined_food_products()
	if(!length(combined_food_products))
		return FALSE

	var/create_type = combined_food_products[W.type]
	if(!create_type && istype(W, /obj/item/chems/food))
		var/obj/item/chems/food/food = W
		var/check_grown_tag = food.get_grown_tag()
		if(check_grown_tag)
			create_type = combined_food_products[check_grown_tag]

	if(islist(create_type))
		var/list/names = list()
		for(var/food_type in create_type)
			names[atom_info_repository.get_name_for(food_type)] = food_type
		create_type = input(user, "What do you want to make?", "Food Assembly") as null|anything in names
		if(!create_type || QDELETED(user) || user.incapacitated() || QDELETED(src) || QDELETED(W))
			return TRUE
		create_type = names[create_type]

	// TODO: move reagents/matter into produced food object.
	if(ispath(create_type) && user.canUnEquip(src))
		var/obj/item/chems/food/result = new create_type()
		//If the snack was in your hands, the result will be too
		if (src in user.get_held_item_slots())
			user.drop_from_inventory(src)
			user.put_in_hands(result)
		else
			result.dropInto(loc)
		qdel(W)
		qdel(src)
		to_chat(user, SPAN_NOTICE("You make \the [result]!"))
		return TRUE

	// Reverse the interaction to avoid the dumb thing where combinations aren't commutative.
	var/obj/item/chems/food/food = W
	if(istype(food))
		return food.try_create_combination(src, user)
	return FALSE

/obj/item/chems/food/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	var/list/combined_food_products = get_combined_food_products()
	if(!length(combined_food_products))
		return
	for(var/thing_type in combined_food_products)
		var/product = combined_food_products[thing_type]
		var/product_string
		if(islist(product))
			var/list/names = list()
			for(var/product_type in product)
				names += "\a [atom_info_repository.get_name_for(product_type)]"
			product_string = english_list(names, and_text = " or ")
		else
			product_string = "\a [atom_info_repository.get_name_for(product)]"
		to_chat(user, SPAN_NOTICE("With this and \a [atom_info_repository.get_name_for(thing_type)], you could make [product_string]."))

/obj/item/chems/food/bun/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball         = /obj/item/chems/food/burger,
		/obj/item/chems/food/butchery/cutlet           = /obj/item/chems/food/hamburger,
		/obj/item/chems/food/sausage          = /obj/item/chems/food/hotdog,
		/obj/item/robot_parts/head            = /obj/item/chems/food/roburger,
		/obj/item/holder/corgi                = /obj/item/chems/food/classichotdog,
		/obj/item/chems/food/butchery/cutlet           = /obj/item/chems/food/burger,
		/obj/item/organ/internal/brain        = /obj/item/chems/food/brainburger,
		/obj/item/chems/food/xenomeat         = /obj/item/chems/food/xenoburger,
		/obj/item/chems/food/butchery/meat/fish             = /obj/item/chems/food/fishburger,
		/obj/item/chems/food/tofu             = /obj/item/chems/food/tofuburger,
		/obj/item/ectoplasm                   = /obj/item/chems/food/ghostburger,
		/obj/item/clothing/mask/gas/clown_hat = /obj/item/chems/food/clownburger,
		/obj/item/clothing/head/beret         = /obj/item/chems/food/mimeburger,
		/obj/item/chems/food/bun              = /obj/item/chems/food/bunbun,
		/obj/item/chems/food/sausage          = /obj/item/chems/food/hotdog
	)
	return combined_food_products

/obj/item/chems/food/twobread/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/slice/bread = /obj/item/chems/food/threebread
	)
	return combined_food_products

/obj/item/chems/food/doughslice/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball    = /obj/item/chems/food/donkpocket,
		/obj/item/chems/food/meatball/raw = list(
			/obj/item/chems/food/pelmen,
			/obj/item/chems/food/donkpocket
		)
	)
	return combined_food_products

/obj/item/chems/food/burger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger,
		/obj/item/clothing/head/wizard   = /obj/item/chems/food/spellburger
	)
	return combined_food_products

/obj/item/chems/food/hamburger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger
	)
	return combined_food_products

/obj/item/chems/food/human/burger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger
	)
	return combined_food_products

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/boiledspagetti/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball = /obj/item/chems/food/meatballspagetti,
		/obj/item/stack/nanopaste     = /obj/item/chems/food/nanopasta
	)
	return combined_food_products

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/meatballspagetti/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball = /obj/item/chems/food/spesslaw
	)
	return combined_food_products

/obj/item/chems/food/butchery/cutlet/raw/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball/raw = /obj/item/chems/food/sausage
	)
	return combined_food_products

/obj/item/chems/food/meatball/raw/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/butchery/cutlet/raw = /obj/item/chems/food/sausage
	)
	return combined_food_products

/obj/item/chems/food/sausage/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/meatball/raw = /obj/item/chems/food/fatsausage,
		/obj/item/chems/food/butchery/cutlet/raw   = /obj/item/chems/food/fatsausage
	)
	return combined_food_products

/obj/item/chems/food/sliceable/flatdough/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/butchery/cutlet   = /obj/item/chems/food/meatpie/raw,
		/obj/item/chems/food/tofu     = /obj/item/chems/food/tofupie/raw,
		/obj/item/chems/food/xenomeat = /obj/item/chems/food/xemeatpie/raw,
		"apple"                       = /obj/item/chems/food/applepie/raw,
		"berries"                     = /obj/item/chems/food/berryclafoutis/raw,
		"plumphelmet"                 = /obj/item/chems/food/plump_pie/raw
	)
	return combined_food_products

// This one looks slightly weird but the attackby() proc should mirror it to the potato.
/obj/item/chems/food/cheesewedge/get_combined_food_products()
	var/static/list/combined_food_products = list(
		"potato" = /obj/item/chems/food/loadedbakedpotato/raw
	)
	return combined_food_products

/obj/item/chems/food/fries/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheesyfries/uncooked
	)
	return combined_food_products

/obj/item/chems/food/meatpie/raw/cooked_food           = FOOD_RAW
/obj/item/chems/food/tofupie/raw/cooked_food           = FOOD_RAW
/obj/item/chems/food/xemeatpie/raw/cooked_food         = FOOD_RAW
/obj/item/chems/food/applepie/raw/cooked_food          = FOOD_RAW
/obj/item/chems/food/berryclafoutis/raw/cooked_food    = FOOD_RAW
/obj/item/chems/food/plump_pie/raw/cooked_food         = FOOD_RAW
/obj/item/chems/food/loadedbakedpotato/raw/cooked_food = FOOD_RAW
/obj/item/chems/food/cheesyfries/uncooked/cooked_food  = FOOD_PREPARED // No penalty for eating it, but nicer cooked.
