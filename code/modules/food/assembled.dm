/obj/item/chems/food
	/// Items you can craft together. Like bomb making, but with food and less screwdrivers.
	/// Uses format list(ingredient = result_type). The ingredient can be a typepath or a kitchen_tag string (used for mobs or plants)
	var/list/attack_products 

/obj/item/chems/food/attackby(obj/item/W, mob/living/user)

	// See if we can make a food object.
	if(istype(W, /obj/item/chems/food))

		// See if we can make anything with this.
		if(length(attack_products))
			var/create_type
			for(var/key in attack_products)
				if(ispath(key) && !istype(W, key))
					continue
				if(istext(key))
					if(!istype(W, /obj/item/chems/food/grown))
						continue
					var/obj/item/chems/food/grown/G = W
					if(G.seed.kitchen_tag && G.seed.kitchen_tag != key)
						continue
				create_type = attack_products[key]
			if (!ispath(create_type))
				break
			if(!user.canUnEquip(src))
				break
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
		if(length(food.attack_products))
			return food.attackby(src, user)

	. = ..()

/obj/item/chems/food/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && length(attack_products))
		for(var/thing_type in attack_products)
			var/obj/item/thing   = thing_type
			var/obj/item/product = attack_products[thing_type]
			to_chat(user, SPAN_NOTICE("With this and \a [initial(thing.name)], you could make \a [initial(product.name)]."))

/obj/item/chems/food/bun
	attack_products = list(
		/obj/item/chems/food/meatball         = /obj/item/chems/food/burger,
		/obj/item/chems/food/cutlet           = /obj/item/chems/food/hamburger,
		/obj/item/chems/food/sausage          = /obj/item/chems/food/hotdog,
		/obj/item/robot_parts/head            = /obj/item/chems/food/roburger,
		/obj/item/holder/corgi                = /obj/item/chems/food/classichotdog,
		/obj/item/chems/food/cutlet           = /obj/item/chems/food/burger,
		/obj/item/organ/internal/brain        = /obj/item/chems/food/brainburger,
		/obj/item/chems/food/xenomeat         = /obj/item/chems/food/xenoburger,
		/obj/item/chems/food/fish             = /obj/item/chems/food/fishburger,
		/obj/item/chems/food/tofu             = /obj/item/chems/food/tofuburger,
		/obj/item/ectoplasm                   = /obj/item/chems/food/ghostburger,
		/obj/item/clothing/mask/gas/clown_hat = /obj/item/chems/food/clownburger,
		/obj/item/clothing/head/beret         = /obj/item/chems/food/mimeburger,
		/obj/item/chems/food/bun              = /obj/item/chems/food/bunbun,
		/obj/item/chems/food/sausage          = /obj/item/chems/food/hotdog
	)

/obj/item/chems/food/twobread
	attack_products = list(
		/obj/item/chems/food/slice/bread = /obj/item/chems/food/threebread
	)

/obj/item/chems/food/doughslice
	attack_products = list(
		/obj/item/chems/food/meatball    = /obj/item/chems/food/donkpocket
		/obj/item/chems/food/rawmeatball = list(
			/obj/item/chems/food/pelmen,
			/obj/item/chems/food/donkpocket
		)
	)

/obj/item/chems/food/burger
	attack_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger,
		/obj/item/clothing/head/wizard   = /obj/item/chems/food/spellburger
	)

/obj/item/chems/food/hamburger
	attack_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger
	)

/obj/item/chems/food/human/burger
	attack_products = list(
		/obj/item/chems/food/cheesewedge = /obj/item/chems/food/cheeseburger
	)

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/boiledspagetti
	attack_products = list(
		/obj/item/chems/food/meatball = /obj/item/chems/food/meatballspagetti,
		/obj/item/stack/nanopaste     = /obj/item/chems/food/nanopasta
	)

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/meatballspagetti
	attack_products = list(
		/obj/item/chems/food/meatball = /obj/item/chems/food/spesslaw
	)

/obj/item/chems/food/rawcutlet
	attack_products = list(
		/obj/item/chems/food/rawmeatball = /obj/item/chems/food/sausage
	)

/obj/item/chems/food/rawmeatball
	attack_products = list(
		/obj/item/chems/food/rawcutlet = /obj/item/chems/food/sausage
	)

/obj/item/chems/food/sausage
	attack_products = list(
		/obj/item/chems/food/rawmeatball = /obj/item/chems/food/fatsausage,
		/obj/item/chems/food/rawcutlet   = /obj/item/chems/food/fatsausage
	)

// TODO: Pie assembly should make a raw pie that has to be baked to finish it off.
/obj/item/chems/food/sliceable/flatdough
	attack_products = list(
		/obj/item/chems/food/cutlet   = /obj/item/chems/food/meatpie,
		/obj/item/chems/food/tofu     = /obj/item/chems/food/tofupie,
		/obj/item/chems/food/xenomeat = /obj/item/chems/food/xemeatpie
	)
