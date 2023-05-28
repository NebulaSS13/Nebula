/obj/item/radio/headset/headset_exp
	name = "explorer's headset"
	desc = "A small headset used by exploration, with access to the explorer and science channels."
	icon = 'mods/content/polaris/icons/headsets/headset_explorer.dmi'
	can_use_analog = TRUE
	encryption_keys = list(/obj/item/encryptionkey/explorer)

/obj/item/radio/headset/headset_exp/bowman
	name = "explorer's bowman headset"
	desc = "A large headset used by exploration, with access to the explorer and science channels."
	icon = 'mods/content/polaris/icons/headsets/headset_explorer_alt.dmi'

/obj/item/encryptionkey/explorer
	name = "explorer radio encryption key"
	inlay_color = COLOR_SCIENCE_PURPLE
	can_decrypt = list(
		access_explorer,
		access_research
	)

/obj/item/radio/headset/headset_sar
	name = "\improper SAR radio headset"
	desc = "A small headset for search and rescue, with access to the explorer and medical channels."
	icon = 'mods/content/polaris/icons/headsets/headset_sar.dmi'
	can_use_analog = TRUE
	encryption_keys = list(/obj/item/encryptionkey/sar)

/obj/item/radio/headset/headset_sar/bowman
	name = "\improper SAR radio bowman headset"
	desc = "A large headset for search and rescue, with access to the explorer and medical channels."
	icon = 'mods/content/polaris/icons/headsets/headset_sar_alt.dmi'

/obj/item/encryptionkey/sar
	name = "\improper SAR encryption key"
	inlay_color = COLOR_ASSEMBLY_WHITE
	can_decrypt = list(
		access_medical,
		access_explorer
	)
