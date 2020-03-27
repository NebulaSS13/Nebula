/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	can_hold = list(
		/obj/item/soulstone
		)

/obj/item/storage/belt/soulstone/full/Initialize()
	. = ..()
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
