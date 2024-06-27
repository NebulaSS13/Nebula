//crime scene kit
/obj/item/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/items/storage/crime_kit.dmi'
	material = /decl/material/solid/organic/leather/synth
	matter = list(/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/briefcase/crimekit/WillContain()
	return list(
		/obj/item/box/fingerprints,
		/obj/item/chems/spray/luminol,
		/obj/item/uv_light,
		/obj/item/forensics/sample_kit/swabs,
		/obj/item/forensics/sample_kit,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/box/csi_markers
		)
