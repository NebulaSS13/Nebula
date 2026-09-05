/obj/item/radio/headset/headset_exp/bowman
	name = "explorer's bowman headset"
	desc = "A large headset used by exploration, with access to the explorer and science channels."
	icon = 'mods/content/polaris/icons/headsets/headset_explorer_alt.dmi'

/obj/item/encryptionkey/sar/Initialize()
	LAZYDISTINCTADD(can_decrypt, access_explorer)
	. = ..()
