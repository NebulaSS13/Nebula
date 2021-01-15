/obj/item/clothing/glasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	action_button_name = "Adjust Blindfold"
	icon = 'icons/clothing/eyes/blindfold.dmi'
	tint = TINT_BLIND
	flash_protection = FLASH_PROTECTION_MAJOR
	darkness_view = -1
	toggleable = TRUE
	activation_sound = null
	toggle_off_message = "You flip $ITEM$ up."
	toggle_on_message = "You slide $ITEM$ down, blinding yourself."

/obj/item/clothing/glasses/blindfold/set_active_values()
	..()
	flags_inv &= ~HIDEEYES
	body_parts_covered &= ~SLOT_EYES

/obj/item/clothing/glasses/blindfold/set_inactive_values()
	..()
	flags_inv |= HIDEEYES
	body_parts_covered |= SLOT_EYES

/obj/item/clothing/glasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/clothing/eyes/blindfold_tape.dmi'
	action_button_name = null
	w_class = ITEM_SIZE_TINY
	toggleable = FALSE