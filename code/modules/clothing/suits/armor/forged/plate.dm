/obj/item/clothing/suit/armor/forged/breastplate
	name = "breastplate"
	desc = "A heavy, solid form of armor that covers the chest, usually worn in conjunction with other armor."
	icon = 'icons/clothing/plate_armour/platemail.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	strap_material = null
	detail_material = null

/obj/item/clothing/gloves/vambrace
	name = "gauntlets and vambraces"
	desc = "A form of segmented armor that covers the hands and arms, typically worn as part of plate mail."
	icon = 'icons/clothing/plate_armour/vambrace.dmi'
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	body_parts_covered = SLOT_HANDS|SLOT_ARMS
	accessory_slot = ACCESSORY_SLOT_GREAVES

/obj/item/clothing/shoes/sabatons
	name = "sabatons and greaves"
	desc = "Segmented armour that protects the feet and legs, typically worn as part of plate mail."
	icon = 'icons/clothing/plate_armour/sabatons.dmi'
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	body_parts_covered = SLOT_FEET|SLOT_LOWER_BODY|SLOT_LEGS
	accessory_slot = ACCESSORY_SLOT_GAUNTLETS

/obj/item/clothing/head/helmet/plumed
	name = "plumed helmet"
	desc = "A visored helmet that covers the entire face and skull."
	icon = 'icons/clothing/plate_armour/helm.dmi'
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	markings_color = COLOR_PURPLE
	markings_state_modifier = "-plume"
