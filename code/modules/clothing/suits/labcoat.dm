/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	icon_open = "labcoat_open"
	icon_closed = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/scanner/gas,/obj/item/stack/medical,/obj/item/chems/dropper,/obj/item/chems/syringe,/obj/item/chems/hypospray,/obj/item/scanner/health,/obj/item/flashlight/pen,/obj/item/chems/glass/bottle,/obj/item/chems/glass/beaker,/obj/item/chems/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	icon_open = "labcoat_cmo_open"
	icon_closed = "labcoat_cmo"

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt_open"
	icon_open = "labcoat_cmoalt_open"
	icon_closed = "labcoat_cmoalt"

/obj/item/clothing/suit/storage/toggle/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	icon_open = "labgreen_open"
	icon_closed = "labgreen"

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"
	icon_open = "labcoat_gen_open"
	icon_closed = "labcoat_gen"

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "Pharmacist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"
	icon_open = "labcoat_chem_open"
	icon_closed = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	icon_open = "labcoat_vir_open"
	icon_closed = "labcoat_vir"

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue-edged labcoat"
	desc = "A suit that protects against minor chemical spills. This one has blue trim."
	icon_state = "blue_edge_labcoat_open"
	icon_open = "blue_edge_labcoat_open"
	icon_closed = "blue_edge_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/coat
	name = "coat"
	desc = "A cozy overcoat."
	color = "#292929"

/obj/item/clothing/suit/storage/toggle/labcoat/foundation
	name = "\improper Foundation labcoat"
	desc = "A medical labcoat with a Cuchulain Foundation crest stencilled on the back."
	icon_state = "labcoat_foundation"
	icon_open = "labcoat_foundation_open"
	icon_closed = "labcoat_foundation"

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "researcher labcoat"
	desc = "A coat that protects against minor chemical spills."
	icon_state = "labcoat_TL_open"
	icon_open = "labcoat_TL_open"
	icon_closed = "labcoat_TL"

/obj/item/clothing/suit/storage/toggle/labcoat/rd
	name = "research director's labcoat"
	desc = "A full-body labcoat covered in green and black designs. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_open"
	icon_open = "labcoat_rd_open"
	icon_closed = "labcoat_rd"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
