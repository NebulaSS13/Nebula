//ERT backpacks.
/obj/item/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon = 'mods/content/response_team/icons/backpack_ert.dmi'
	var/marking_state
	var/marking_colour

/obj/item/backpack/ert/on_update_icon()
	. = ..()
	if(marking_state)
		var/image/I = image(icon, marking_state)
		I.color = marking_colour
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/backpack/ert/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && slot == slot_back_str && marking_state)
		var/image/I = image(overlay.icon, "[overlay.icon_state]-[marking_state]")
		I.color = marking_colour
		I.appearance_flags |= RESET_COLOR
		overlay.add_overlay(I)
	. = ..()

/obj/item/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."
	marking_colour = COLOR_BLUE_GRAY
	marking_state = "com"

/obj/item/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	marking_colour = COLOR_NT_RED
	marking_state = "sec"

/obj/item/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	marking_colour = COLOR_GOLD
	marking_state = "eng"

/obj/item/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	marking_colour = COLOR_OFF_WHITE
	marking_state = "med"

//ERT PDA preset
/obj/item/modular_computer/pda/ert
	color = COLOR_OFF_WHITE
	decals = list(
		"stripe" = COLOR_DARK_BLUE_GRAY,
		"stripe2" = COLOR_GOLD
	)

//ERT headsets
/obj/item/encryptionkey/specops/ert
	name = "\improper ERT radio encryption key"
	can_decrypt = list(access_cent_specops)

/obj/item/radio/headset/specops/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon = 'icons/obj/items/device/radio/headsets/headset_admin.dmi'
	encryption_keys = list(/obj/item/encryptionkey/specops/ert)

/obj/item/radio/borg/ert
	encryption_keys = list(/obj/item/encryptionkey/specops/ert)