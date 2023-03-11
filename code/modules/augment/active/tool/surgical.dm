/obj/item/organ/internal/augment/active/polytool/surgical
	name = "surgical toolset"
	action_button_name = "Deploy Surgical Tool"
	desc = "Part of a line of biomedical augmentations, this device contains the full set of tools any surgeon would ever need."
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)
	paths = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill
	)
	origin_tech = @'{"materials":4,"magnets":3,"engineering":3}'
