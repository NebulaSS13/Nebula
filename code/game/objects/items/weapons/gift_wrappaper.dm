/* Gifts and wrapping paper
 * Contains:
 *		Gifts
 *		Wrapping Paper
 */

/*
 * Gifts
 */
/obj/item/a_gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift1"
	item_state = "gift1"
	randpixel = 10

/obj/item/a_gift/Initialize()
	. = ..()
	if(w_class >= ITEM_SIZE_MIN && w_class < ITEM_SIZE_HUGE)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"

/obj/item/a_gift/explosion_act()
	..()
	if(!QDELETED(src))
		qdel(src)

/obj/effect/spresent/relaymove(mob/user)
	if (user.stat)
		return
	to_chat(user, "<span class='warning'>You can't move.</span>")

/obj/effect/spresent/attackby(obj/item/W, mob/user)
	..()

	if(!isWirecutter(W))
		to_chat(user, "<span class='warning'>I need wirecutters for that.</span>")
		return

	to_chat(user, "<span class='notice'>You cut open the present.</span>")

	for(var/mob/M in src) //Should only be one but whatever.
		M.dropInto(loc)
		if (M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

	qdel(src)

/obj/item/a_gift/attack_self(mob/M)
	var/gift_type = pick(
		/obj/item/storage/wallet,
		/obj/item/storage/photo_album,
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/belt/champion,
		/obj/item/pickaxe/silver,
		/obj/item/pen/invisible,
		/obj/random/lipstick,
		/obj/item/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/contraband/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/beach_ball,
		/obj/item/beach_ball/holoball,
		/obj/item/toy/water_balloon,
		/obj/item/toy/blink,
		/obj/item/gun/launcher/foam/crossbow,
		/obj/item/gun/projectile/revolver/capgun,
		/obj/item/sword/katana/toy,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/powerloader,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/toy/sword,
		/obj/item/chems/food/grown/ambrosiadeus,
		/obj/item/chems/food/grown/ambrosiavulgaris,
		/obj/item/paicard,
		/obj/item/synthesized_instrument/violin,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/accessory/horrible,
		/obj/item/storage/box/large/foam_gun,
		/obj/item/storage/box/large/foam_gun/burst,
		/obj/item/storage/box/large/foam_gun/revolver)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

/*
 * Wrapping Paper and Gifts
 */

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = ITEM_SIZE_HUGE

/obj/item/gift/Initialize(mapload, obj/item/wrapped = null)
	. = ..(mapload)

	if(istype(wrapped))
		gift = wrapped
		w_class = gift.w_class
		gift.forceMove(src)

		switch(gift.w_class)
			if(ITEM_SIZE_TINY, ITEM_SIZE_SMALL)
				icon_state = "gift1"
			if(ITEM_SIZE_NORMAL, ITEM_SIZE_LARGE)
				icon_state = "gift2"
			else
				icon_state = "gift3"

/obj/item/gift/attack_self(mob/user)
	user.drop_item()
	if(src.gift)
		user.put_in_active_hand(gift)
		src.gift.add_fingerprint(user)
	else
		to_chat(user, "<span class='warning'>The gift was empty!</span>")
	qdel(src)
	return

/obj/item/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/items/gift_wrapper.dmi'
	icon_state = "wrap_paper"
	var/amount = 2.5*BASE_STORAGE_COST(ITEM_SIZE_HUGE)

/obj/item/wrapping_paper/attackby(obj/item/W, mob/user)
	. = ..()
	if (!(locate(/obj/structure/table) in src.loc))
		to_chat(user, SPAN_WARNING("You must put the paper on a table."))
		return TRUE

	if (W.w_class >= ITEM_SIZE_HUGE)
		to_chat(user, SPAN_WARNING("The object is FAR too large!"))
		return TRUE

	var/found_scissors = FALSE
	for(var/obj/item/thing in user.get_held_items())
		if(isWirecutter(thing))
			found_scissors = TRUE
			break

	if(!found_scissors)
		to_chat(user, SPAN_WARNING("You need cutters!"))
		return TRUE

	var/a_used = W.get_storage_cost()
	if (a_used >= ITEM_SIZE_NO_CONTAINER)
		to_chat(user, SPAN_WARNING("You can't wrap that!"))
		return TRUE

	if (src.amount < a_used)
		to_chat(user, SPAN_WARNING("You need more paper!"))
		return TRUE

	if(!istype(W, /obj/item/smallDelivery) && !istype(W, /obj/item/gift) && user.unEquip(W))
		var/obj/item/gift/G = new /obj/item/gift( src.loc, W )
		G.add_fingerprint(user)
		W.add_fingerprint(user)
		src.amount -= a_used
		if(src.amount <= 0)
			new /obj/item/c_tube( src.loc )
			qdel(src)
		return TRUE

/obj/item/wrapping_paper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, text("There is about [] square units of paper left!", src.amount))

/obj/item/wrapping_paper/attack(mob/target, mob/user)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.forceMove(present)
			admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")

		else
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")
