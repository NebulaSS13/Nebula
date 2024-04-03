/obj/item/storage/box/candles
	name = "candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/items/storage/candles.dmi'
	icon_state = ICON_STATE_WORLD
	can_hold = list(/obj/item/flame/candle)
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/cardboard

/obj/item/storage/box/candles/WillContain()
	return list(/obj/item/flame/candle = 7)

/obj/item/storage/box/candles/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon = 'icons/obj/items/storage/incense.dmi'

/obj/item/storage/box/candles/incense/WillContain()
	return list(/obj/item/flame/candle/scented/incense = 9)

/obj/item/storage/box/candles/scented
	name = "scented candle box"
	desc = "An unbranded pack of scented candles, in a variety of scents."

/obj/item/storage/box/candles/scented/WillContain()
	return list(/obj/item/flame/candle/scented = 5)
