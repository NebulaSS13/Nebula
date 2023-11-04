//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	material = /decl/material/solid/organic/leather/synth
	matter = list(/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/storage/briefcase/crimekit/WillContain()
	return list(
		/obj/item/storage/box/fingerprints,
		/obj/item/chems/spray/luminol,
		/obj/item/uv_light,
		/obj/item/forensics/sample_kit/swabs,
		/obj/item/forensics/sample_kit,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/storage/box/csi_markers
		)
