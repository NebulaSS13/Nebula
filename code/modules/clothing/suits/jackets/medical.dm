/obj/item/clothing/suit/jacket/first_responder
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon = 'icons/clothing/suits/jackets/responder.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/inhaler,
		/obj/item/chems/syringe,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/tank/emergency,
		/obj/item/chems/ivbag
	)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/jacket/first_responder/ems
	name = "\improper EMS jacket"
	desc = "A dark blue, martian-pattern, EMS jacket. It sports high-visibility reflective stripes and a star of life on the back."
	icon = 'icons/clothing/suits/emt_jacket.dmi'
