/obj/item/grooming/brush
	name       = "hairbrush"
	desc       = "A surprisingly decent hairbrush with a sturdy handle and semi-soft bristles."
	icon       = 'icons/obj/items/grooming/hairbrush.dmi'
	w_class    = ITEM_SIZE_SMALL
	slot_flags = null
	material   = /decl/material/solid/organic/plastic

	message_target_other_generic = "$USER$ meticulously brushes $TARGET$ with $TOOL$."
	message_target_self_generic  = "$USER$ meticulously brushes $USER_SELF$ with $TOOL$."
	message_target_other         = "$USER$ meticulously brushes $TARGET$'s $DESCRIPTOR$ with $TOOL$."
	message_target_self          = "$USER$ meticulously brushes $USER_HIS$ $DESCRIPTOR$ with $TOOL$."
	grooming_flags               = GROOMABLE_BRUSH

/obj/item/grooming/brush/on_update_icon()
	..()
	var/image/I = image(icon, "[icon_state]-bristles")
	I.color = COLOR_GRAY40
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

/obj/item/grooming/brush/colorable
	material_alteration = MAT_FLAG_ALTERATION_NAME

/obj/item/grooming/brush/colorable/random/Initialize()
	set_color(get_random_colour(lower = 150))
	. = ..()
