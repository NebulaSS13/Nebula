/obj/item/coin
	name = "coin"
	icon = 'icons/obj/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	randpixel = 8
	force = 1
	throwforce = 1
	max_force = 5
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
		var/decl/currency/cur = decls_repository.get_decl(currency)
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
		desc = "A rather thick coin stamped out of [material.display_name]."
	else
		desc = "A rather thick coin."

/obj/item/coin/get_single_monetary_worth()
	. = max(..(), absolute_worth)
	
/obj/item/coin/examine(mob/user, distance)
	. = ..()
	if((distance <= 1 || loc == user) && user.skill_check(SKILL_FINANCE, SKILL_ADEPT))
		var/decl/currency/cur = decls_repository.get_decl(currency)
		var/datum/denomination/denomination = cur.denominations_by_value[currency_worth]
		to_chat(user, "It looks like an antiquated minting of \a [denomination.name].")

// "Coin Flipping, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org
/obj/item/coin/attack_self(var/mob/user)
	if(!can_flip)
		to_chat(user, SPAN_WARNING("\The [src] is already being flipped!"))
		return
	coin_flip(user)

/obj/item/coin/proc/coin_flip(var/mob/user)

	if(!can_flip)
		return


	var/decl/currency/cur = decls_repository.get_decl(currency)
	var/datum/denomination/denomination = cur.denominations_by_value[currency_worth]

	if(!denomination || !length(denomination.faces))
		to_chat(user, SPAN_WARNING("\The [src] is not the right shape to be flipped."))
		return

	can_flip = FALSE
	playsound(usr.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air."))
	sleep(1.5 SECOND)
	if(!QDELETED(user) && !QDELETED(src) && loc == user)
		user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [pick(denomination.faces)]!"))
	can_flip = TRUE

// Subtypes.
/obj/item/coin/gold
	material = MAT_GOLD

/obj/item/coin/silver
	material = MAT_SILVER

/obj/item/coin/diamond
	material = MAT_DIAMOND

/obj/item/coin/iron
	material = MAT_IRON

/obj/item/coin/uranium
	material = MAT_URANIUM

/obj/item/coin/platinum
	material = MAT_PLATINUM

/obj/item/coin/phoron
	material = MAT_PHORON
