/obj/item/clothing/shirt/qipao
	name = "qipao"
	desc = "A tight-fitting blouse with intricate designs of flowers embroidered on it."
	icon = 'icons/clothing/shirts/qipao.dmi'

/obj/item/clothing/shirt/sweater
	name = "turtleneck sweater"
	desc = "A stylish sweater to keep you warm on those cold days."
	icon = 'icons/clothing/shirts/sweater.dmi'

/obj/item/clothing/shirt/harness
	name = "gear harness"
	desc = "How minimalist."
	icon = 'icons/clothing/shirts/harness.dmi'
	bodytype_equip_flags = null
	body_parts_covered = 0

/obj/item/clothing/shirt/button/security
	name = "armored shirt"
	desc = "A lightly armoured button-up shirt with red markings."
	icon = 'icons/clothing/shirts/security.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)
