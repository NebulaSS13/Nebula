/obj/item/coin
	name = "coin"
	desc = "A small coin."
	icon = 'icons/obj/items/coin.dmi'
	icon_state = "coin1"
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	randpixel = 8
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	material = /decl/material/solid/metal/steel
	_base_attack_force = 1
	var/can_flip = TRUE
	var/datum/denomination/denomination

/obj/item/coin/Initialize()
	. = ..()
	icon_state = "coin[rand(1,10)]"
	if(material)
		desc = "A old-style coin stamped out of [material.solid_name]."
	set_extension(src, /datum/extension/tool, list(TOOL_SCREWDRIVER = TOOL_QUALITY_BAD))

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

	var/list/faces = (denomination?.faces || list("heads", "tails"))
	if(length(faces) <= 1)
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
			user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [rigged ? "on the side" : pick(faces)]!"))
		else
			visible_message(SPAN_NOTICE("\The [src] landed on [rigged ? "on the side" : pick(faces)]!"))

	can_flip = TRUE

/obj/item/coin/equipped(mob/user)
	..()
	transform = null

/obj/item/coin/examine(mob/user, distance)
	. = ..()
	if(denomination && (distance <= 1 || loc == user) && user.skill_check(SKILL_FINANCE, SKILL_ADEPT))
		var/decl/currency/map_cur = GET_DECL(global.using_map.default_currency)
		to_chat(user, "It looks like an antiquated minting of \a [denomination.name]. These days it would be worth around [map_cur.format_value(get_combined_monetary_worth())].")

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
