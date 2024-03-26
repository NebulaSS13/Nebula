/obj/item/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	origin_tech = @'{"materials":1}'
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_SMALL

/obj/item/bag/fossils
	name = "fossil satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_LOWER_BODY | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	storage = /datum/storage/bag/fossils
	material = /decl/material/solid/organic/leather/synth
