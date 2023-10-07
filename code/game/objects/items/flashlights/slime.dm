/obj/item/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting/slime.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = ITEM_SIZE_TINY
	on = TRUE //Bio-luminesence has one setting, on.
	flashlight_flags = FLASHLIGHT_ALWAYS_ON
	flashlight_range = 5
	light_wedge = LIGHT_OMNI

/obj/item/flashlight/slime/Initialize()
	. = ..()
	update_icon()
