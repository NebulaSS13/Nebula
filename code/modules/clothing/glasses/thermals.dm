/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	gender = NEUTER
	icon = 'icons/clothing/eyes/scanner_thermal.dmi'
	action_button_name = "Toggle Goggles"
	origin_tech = "{'magnets':3}"
	toggleable = TRUE
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	electric = TRUE

/obj/item/clothing/glasses/thermal/Initialize()
	. = ..()
	overlay = GLOB.global_hud.thermal

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon = 'icons/clothing/eyes/scanner_meson.dmi'
	origin_tech = "{'magnets':3,'esoteric':4}"

/obj/item/clothing/glasses/thermal/plain
	toggleable = FALSE
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon = 'icons/clothing/eyes/thermoncle.dmi'
	body_parts_covered = 0 //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics."
	icon = 'icons/clothing/eyes/eyepatch.dmi'
	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	gender = PLURAL
	desc = "A set of implantable lenses designed to augment your vision."
	icon = 'icons/clothing/eyes/thermal_implants.dmi'
