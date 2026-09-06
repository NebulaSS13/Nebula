/obj/item/encryptionkey/heads/hop/Initialize()
	. = ..()
	LAZYDISTINCTADD(can_decrypt, access_explorer)

/obj/item/encryptionkey/heads/captain/Initialize()
	. = ..()
	LAZYDISTINCTADD(can_decrypt, access_explorer)

/obj/item/encryptionkey/heads/ai_integrated/Initialize()
	. = ..()
	LAZYDISTINCTADD(can_decrypt, access_explorer)

/obj/item/radio/headset/headset_exp
	name = "explorer's headset"
	desc = "A small headset used by exploration, with access to the explorer and science channels."
	icon = 'icons/obj/items/device/radio/headsets/headset_science.dmi'
	encryption_keys = list(/obj/item/encryptionkey/exp)

/obj/item/encryptionkey/exp
	name = "exploration radio encryption key"
	inlay_color = COLOR_SCIENCE_PURPLE
	can_decrypt = list(access_research, access_explorer)
