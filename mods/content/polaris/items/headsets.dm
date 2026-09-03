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
		access_medical
	)

/obj/item/radio/headset/heads/captain/sfr
	name = "\improper SFR headset"
	desc = "A headset belonging to a Sif Free Radio DJ. SFR, best tunes in the wilderness."

/obj/random_multi/single_item/sfr_headset
	name = "Multi Point - headset"
	id = "SFR headset"
	item_path = /obj/random/sfr

// This is in here because it's spawned by the SFR Headset randomizer
/obj/random/sfr
	name = "random SFR headset"
	desc = "This is a headset spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/sfr/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/radio/headset/heads/captain/sfr,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/heads,
		/obj/item/radio/headset
	)
	return spawnable_choices
