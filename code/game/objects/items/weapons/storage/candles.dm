/obj/item/box/candles
	name = "party candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/items/storage/candles.dmi'
	icon_state = ICON_STATE_WORLD
	storage = /datum/storage/box/candles
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/cardboard

/obj/item/box/candles/WillContain()
	return list(/obj/item/flame/candle/random = 7)

/obj/item/box/candles/red
	name = "red candle pack"
	desc = "A pack of unscented candles in blood-red."

/obj/item/box/candles/red/WillContain()
	return list(/obj/item/flame/candle/red = 7)

/obj/item/box/candles/white
	name = "white candle pack"
	desc = "A pack of unscented candles in stark white."

/obj/item/box/candles/white/WillContain()
	return list(/obj/item/flame/candle/white = 7)

/obj/item/box/candles/black
	name = "black candle pack"
	desc = "A pack of unscented candles in black."

/obj/item/box/candles/black/WillContain()
	return list(/obj/item/flame/candle/black = 7)

/obj/item/box/candles/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon = 'icons/obj/items/storage/incense.dmi'
	storage = /datum/storage/box/candles/incense

/obj/item/box/candles/incense/WillContain()
	return list(/obj/item/flame/candle/scented/incense = 9)

/obj/item/box/candles/scented
	name = "scented candle box"
	desc = "An unbranded pack of scented candles, in a variety of scents."
	storage = /datum/storage/box/candles/scented

/obj/item/box/candles/scented/WillContain()
	return list(/obj/item/flame/candle/scented = 5)
