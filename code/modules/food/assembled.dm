/// Items you can craft together. Like bomb making, but with food and less screwdrivers.
/// Uses format list(ingredient = result_type).
/// The ingredient can be a typepath or a grown_tag string (used for mobs or plants)
/// The product can be a typepath or a list of typepaths, which will prompt the user.
/// TODO: validate that these products are properly ordered
/obj/item/food/proc/get_combined_food_products()
	return

/obj/item/food/attackby(obj/item/W, mob/living/user)

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

/obj/item/food/proc/get_grown_tag()
	return

/obj/item/food/proc/try_create_combination(obj/item/W, mob/user)
	if(!length(get_combined_food_products()) || !istype(W) || QDELETED(src) || QDELETED(W))
		return FALSE

	// See if we can make anything with this.
	var/list/combined_food_products = get_combined_food_products()
	if(!length(combined_food_products))
		return FALSE

	var/create_type = combined_food_products[W.type]
	if(!create_type && istype(W, /obj/item/food))
		var/obj/item/food/food = W
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
		var/obj/item/food/result = new create_type()
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
	var/obj/item/food/food = W
	if(istype(food))
		return food.try_create_combination(src, user)
	return FALSE

/obj/item/food/examine(mob/user, distance)
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

/obj/item/food/bun/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball         = /obj/item/food/burger,
		/obj/item/food/butchery/cutlet           = /obj/item/food/hamburger,
		/obj/item/food/sausage          = /obj/item/food/hotdog,
		/obj/item/robot_parts/head            = /obj/item/food/roburger,
		/obj/item/holder/corgi                = /obj/item/food/classichotdog,
		/obj/item/food/butchery/cutlet           = /obj/item/food/burger,
		/obj/item/organ/internal/brain        = /obj/item/food/brainburger,
		/obj/item/food/xenomeat         = /obj/item/food/xenoburger,
		/obj/item/food/butchery/meat/fish             = /obj/item/food/fishburger,
		/obj/item/food/tofu             = /obj/item/food/tofuburger,
		/obj/item/ectoplasm                   = /obj/item/food/ghostburger,
		/obj/item/clothing/mask/gas/clown_hat = /obj/item/food/clownburger,
		/obj/item/clothing/head/beret         = /obj/item/food/mimeburger,
		/obj/item/food/bun              = /obj/item/food/bunbun,
		/obj/item/food/sausage          = /obj/item/food/hotdog
	)
	return combined_food_products

/obj/item/food/twobread/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/slice/bread = /obj/item/food/threebread
	)
	return combined_food_products

/obj/item/food/doughslice/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball    = /obj/item/food/donkpocket,
		/obj/item/food/meatball/raw = list(
			/obj/item/food/pelmen,
			/obj/item/food/donkpocket
		)
	)
	return combined_food_products

/obj/item/food/burger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/cheesewedge = /obj/item/food/cheeseburger,
		/obj/item/clothing/head/wizard   = /obj/item/food/spellburger
	)
	return combined_food_products

/obj/item/food/hamburger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/cheesewedge = /obj/item/food/cheeseburger
	)
	return combined_food_products

/obj/item/food/human/burger/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/cheesewedge = /obj/item/food/cheeseburger
	)
	return combined_food_products

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/food/boiledspagetti/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball = /obj/item/food/meatballspagetti,
		/obj/item/stack/nanopaste     = /obj/item/food/nanopasta
	)
	return combined_food_products

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/food/meatballspagetti/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball = /obj/item/food/spesslaw
	)
	return combined_food_products

/obj/item/food/butchery/cutlet/raw/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball/raw = /obj/item/food/sausage
	)
	return combined_food_products

/obj/item/food/meatball/raw/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/butchery/cutlet/raw = /obj/item/food/sausage
	)
	return combined_food_products

/obj/item/food/sausage/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/meatball/raw = /obj/item/food/fatsausage,
		/obj/item/food/butchery/cutlet/raw   = /obj/item/food/fatsausage
	)
	return combined_food_products

/obj/item/food/sliceable/flatdough/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/butchery/cutlet   = /obj/item/food/meatpie/raw,
		/obj/item/food/tofu     = /obj/item/food/tofupie/raw,
		/obj/item/food/xenomeat = /obj/item/food/xemeatpie/raw,
		"apple"                       = /obj/item/food/applepie/raw,
		"berries"                     = /obj/item/food/berryclafoutis/raw,
		"plumphelmet"                 = /obj/item/food/plump_pie/raw
	)
	return combined_food_products

// This one looks slightly weird but the attackby() proc should mirror it to the potato.
/obj/item/food/cheesewedge/get_combined_food_products()
	var/static/list/combined_food_products = list(
		"potato" = /obj/item/food/loadedbakedpotato/raw
	)
	return combined_food_products

/obj/item/food/fries/get_combined_food_products()
	var/static/list/combined_food_products = list(
		/obj/item/food/cheesewedge = /obj/item/food/cheesyfries/uncooked
	)
	return combined_food_products

/obj/item/food/meatpie/raw/cooked_food           = FOOD_RAW
/obj/item/food/tofupie/raw/cooked_food           = FOOD_RAW
/obj/item/food/xemeatpie/raw/cooked_food         = FOOD_RAW
/obj/item/food/applepie/raw/cooked_food          = FOOD_RAW
/obj/item/food/berryclafoutis/raw/cooked_food    = FOOD_RAW
/obj/item/food/plump_pie/raw/cooked_food         = FOOD_RAW
/obj/item/food/loadedbakedpotato/raw/cooked_food = FOOD_RAW
/obj/item/food/cheesyfries/uncooked/cooked_food  = FOOD_PREPARED // No penalty for eating it, but nicer cooked.
