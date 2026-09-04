// Stub for forging. TODO implement shoes on honse.
/obj/item/horseshoe
	name                = "horseshoe"
	desc                = "A curved length of metal, usually nailed to a horse's hoof. May bring luck."
	icon_state          = ICON_STATE_WORLD
	icon                = 'icons/obj/items/horseshoe.dmi'
	material            = /decl/material/solid/metal/iron
	color               = /decl/material/solid/metal/iron::color
	material_alteration = MAT_FLAG_ALTERATION_ALL

/// A horseshoe hung above a door.
/obj/item/horseshoe/hung
	anchored = TRUE
	randpixel = 0
	layer = ABOVE_HUMAN_LAYER