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
	icon_state = "gift"
	item_state = "gift"
	randpixel = 10
	material = /decl/material/solid/organic/cardboard

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

	if(!IS_WIRECUTTER(W))
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
		/obj/item/wallet,
		/obj/item/photo_album,
		/obj/item/box/snappops,
		/obj/item/box/fancy/crayons,
		/obj/item/backpack/holding,
		/obj/item/belt/champion,
		/obj/item/tool/pickaxe/titanium,
		/obj/item/pen/invisible,
		/obj/random/makeup,
		/obj/item/grenade/smokebomb,
		/obj/item/corncob,
		/obj/item/poster,
		/obj/item/book/manual/barman_recipes,
		/obj/item/book/manual/chef_recipes,
		/obj/item/bikehorn,
		/obj/item/ball,
		/obj/item/ball/basketball,
		/obj/item/ball/volleyball,
		/obj/item/chems/water_balloon,
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
		/obj/item/energy_blade/sword/toy,
		/obj/item/food/grown/ambrosiadeus,
		/obj/item/food/grown/ambrosiavulgaris,
		/obj/item/paicard,
		/obj/item/synthesized_instrument/violin,
		/obj/item/belt/utility/full,
		/obj/item/clothing/neck/tie/horrible,
		/obj/item/box/large/foam_gun,
		/obj/item/box/large/foam_gun/burst,
		/obj/item/box/large/foam_gun/revolver)

	if(!ispath(gift_type,/obj/item))	return

	var/obj/item/I = new gift_type(M)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)

