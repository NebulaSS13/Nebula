/obj/item/clothing/head/bandana/familiarband
	name = "familiar's headband"
	desc = "It's a simple headband made of leather."
	icon = 'icons/clothing/head/familiar.dmi'

/obj/item/clothing/pants/familiar
	name = "familiar's garb"
	desc = "Some rough leather leggings, reinforced here and there. A hasty job."

/obj/item/clothing/pants/familiar/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_w_uniform_str, -3)
