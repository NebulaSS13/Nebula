/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	gender = NEUTER
	icon = 'icons/clothing/eyes/scanner_meson.dmi'
	action_button_name = "Toggle Goggles"
	origin_tech = "{'magnets':2,'engineering':2}"
	toggleable = TRUE
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	electric = TRUE

/obj/item/clothing/glasses/meson/Initialize()
	. = ..()
	overlay = GLOB.global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical meson scanner with prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "Goggles fitted with a portable analyzer capable of determining the fabricator training potential of an item or components of a machine. Sensitive to EMP."
	icon = 'icons/clothing/eyes/goggles_science.dmi'
	hud_type = HUD_SCIENCE
	toggleable = TRUE
	electric = TRUE
	anomaly_shielding = 0.1

/obj/item/clothing/glasses/science/prescription
	name = "prescription science goggles"
	desc = "Science goggles with prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science/Initialize()
	. = ..()
	overlay = GLOB.global_hud.science

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon = 'icons/clothing/eyes/night_vision.dmi'
	origin_tech = "{'magnets':2}"
	darkness_view = 7
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	electric = TRUE

/obj/item/clothing/glasses/night/Initialize()
	. = ..()
	overlay = GLOB.global_hud.nvg

/obj/item/clothing/glasses/tacgoggles
	name = "tactical goggles"
	desc = "Self-polarizing goggles with light amplification for dark environments. Made from durable synthetic."
	icon = 'icons/clothing/eyes/tactical.dmi'
	origin_tech = "{'magnets':2,'combat':4}"
	darkness_view = 5
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	siemens_coefficient = 0.6
	electric = TRUE
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	gender = NEUTER
	icon = 'icons/clothing/eyes/scanner_material.dmi'
	origin_tech = "{'magnets':3,'engineering':3}"
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	vision_flags = SEE_OBJS
	electric = TRUE

/obj/item/clothing/glasses/threedglasses
	name = "3D glasses"
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	icon = 'icons/clothing/eyes/glasses_3d.dmi'
	body_parts_covered = 0

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon = 'icons/clothing/eyes/goggles_welding.dmi'
	action_button_name = "Flip Welding Goggles"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	use_alt_layer = TRUE
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	active = FALSE
	toggle_on_message = "You flip $ITEM$ down to protect your eyes."
	toggle_off_message = "You push $ITEM$ up out of your face."
	activation_sound = null
	toggleable = TRUE

/obj/item/clothing/glasses/welding/set_active_values()
	..()
	flags_inv |= HIDEEYES
	body_parts_covered |= SLOT_EYES

/obj/item/clothing/glasses/welding/set_inactive_values()
	..()
	flags_inv &= ~HIDEEYES
	body_parts_covered &= ~SLOT_EYES

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon = 'icons/clothing/eyes/goggles_welding_superior.dmi'
	tint = TINT_MODERATE
