/obj/item/coin
	name = "coin"
	icon = 'icons/obj/items/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	applies_material_name = TRUE
	randpixel = 8
	force = 1
	throwforce = 1
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

	var/currency_worth
	var/absolute_worth
	var/currency
	var/can_flip = TRUE

/obj/item/coin/Initialize()
	. = ..()

	// Grab a coin from our currency to use for our worth/coin flipping.
	if(!ispath(currency, /decl/currency))
		currency = GLOB.using_map.default_currency
	if(isnull(absolute_worth))
		var/decl/currency/cur = GET_DECL(currency)
		var/list/coins = list()
		for(var/datum/denomination/denomination in cur.denominations)
			if(denomination.faces)
				coins += denomination
		if(length(coins))
			var/datum/denomination/denomination = pick(coins)
			currency_worth = denomination.marked_value
			absolute_worth = Floor(denomination.marked_value / cur.absolute_value)
			currency_worth = "[currency_worth]"
		if(!absolute_worth || !currency_worth)
			return INITIALIZE_HINT_QDEL

	icon_state = "coin[rand(1,10)]"
	if(material)
		desc = "A rather thick coin stamped out of [material.solid_name]."
	else
		desc = "A rather thick coin."

/obj/item/coin/get_single_monetary_worth()
	. = max(..(), absolute_worth)

/obj/item/coin/examine(mob/user, distance)
	. = ..()
	if((distance <= 1 || loc == user) && user.skill_check(SKILL_FINANCE, SKILL_ADEPT))
		var/decl/currency/cur = GET_DECL(currency)
		var/datum/denomination/denomination = cur.denominations_by_value[currency_worth]
		to_chat(user, "It looks like an antiquated minting of \a [denomination.name].")

// "Coin Flipping, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org
/obj/item/coin/attack_self(var/mob/user)
	if(!can_flip)
		to_chat(user, SPAN_WARNING("\The [src] is already being flipped!"))
		return
	coin_flip(user, 0)

/obj/item/coin/throw_impact(atom/hit_atom, speed, user)
	..()
	coin_flip(user, 1)

/obj/item/coin/proc/coin_flip(var/mob/user, thrown, rigged = FALSE)
	if(!can_flip)
		return

	var/decl/currency/cur = GET_DECL(currency)
	var/datum/denomination/denomination = cur.denominations_by_value[currency_worth]

	if(!denomination || !length(denomination.faces))
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is not the right shape to be flipped."))
		return

	can_flip = FALSE

	var/matrix/flipit = matrix()
	flipit.Scale(0.2, 1)
	animate(src, transform = flipit, time = 2, easing = QUAD_EASING)
	flipit.Scale(5, 1)
	flipit.Invert()
	flipit.Turn(rand(1, 359))
	animate(src, transform = flipit, time = 2, easing = QUAD_EASING)
	flipit.Scale(0.2, 1)
	animate(src, transform = flipit, time = 2, easing = QUAD_EASING)

	flipit.Scale(5, 1)
	if(pick(0, 1))
		flipit.Invert()
	flipit.Turn(rand(1, 359))
	animate(src, transform = flipit, time = 2, easing = QUAD_EASING)

	if (prob(0.1) || rigged)
		if(!rigged) rigged = TRUE
		flipit.Scale(0.2, 1)
		animate(src, transform = flipit, time = 2, easing = QUAD_EASING)

	playsound(src, 'sound/effects/coin_flip.ogg', 75, 1)

	if(user && !thrown)
		user.visible_message(
			SPAN_NOTICE("[user] flips \the [src] into the air."),
			SPAN_NOTICE("You flip \the [src] into the air."),
			"You hear a coin ring.")

	sleep(1.5 SECOND)

	if(!QDELETED(src))
		if(!QDELETED(user) && loc == user && !thrown)
			user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [rigged ? "on the side" : pick(denomination.faces)]!"))
		else
			visible_message(SPAN_NOTICE("\The [src] landed on [rigged ? "on the side" : pick(denomination.faces)]!"))

	can_flip = TRUE

/obj/item/coin/equipped(mob/user)
	..()
	transform = null

// Subtypes.
/obj/item/coin/gold
	material = /decl/material/solid/metal/gold

/obj/item/coin/silver
	material = /decl/material/solid/metal/silver

/obj/item/coin/diamond
	material = /decl/material/solid/gemstone/diamond

/obj/item/coin/iron
	material = /decl/material/solid/metal/iron

/obj/item/coin/uranium
	material = /decl/material/solid/metal/uranium

/obj/item/coin/platinum
	material = /decl/material/solid/metal/platinum
