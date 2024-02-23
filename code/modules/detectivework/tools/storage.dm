/obj/item/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	
/obj/item/box/swabs/WillContain()
	return list(/obj/item/forensics/sample/swab = DEFAULT_BOX_STORAGE)

/obj/item/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."

/obj/item/box/swabs/WillContain()
	return list(/obj/item/evidencebag = 7)

/obj/item/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"

/obj/item/box/swabs/WillContain()
	return list(/obj/item/forensics/sample/print = DEFAULT_BOX_STORAGE)
