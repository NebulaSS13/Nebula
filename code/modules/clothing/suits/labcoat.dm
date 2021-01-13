/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon = 'icons/clothing/suit/labcoat/default.dmi'
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/scanner/gas,/obj/item/stack/medical,/obj/item/chems/dropper,/obj/item/chems/syringe,/obj/item/chems/hypospray,/obj/item/scanner/health,/obj/item/flashlight/pen,/obj/item/chems/glass/bottle,/obj/item/chems/glass/beaker,/obj/item/chems/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	markings_icon = "_marking"
	matter = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE)
	origin_tech = "{'materials':1,'engineering':1,'biotech':1}"

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	color = COLOR_BABY_BLUE

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon = 'icons/clothing/suit/labcoat/cmo.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	color = COLOR_GREEN

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "pharmacist labcoat"
	markings_color  = COLOR_SEDONA

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "geneticist labcoat"
	markings_color  = COLOR_BLUE_LIGHT

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "virologist labcoat"
	markings_color  = COLOR_GREEN

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue-edged labcoat"
	icon = 'icons/clothing/suit/labcoat/blue_edge.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/coat
	name = "coat"
	desc = "A cozy overcoat."
	color = "#292929"

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "researcher labcoat"
	markings_color = COLOR_BOTTLE_GREEN

/obj/item/clothing/suit/storage/toggle/labcoat/rd
	name = "research director's labcoat"
	desc = "A full-body labcoat covered in designs, denoting it as management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon = 'icons/clothing/suit/labcoat/rd.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	markings_color = COLOR_BOTTLE_GREEN
	markings_icon = "_marking"
	