// the desk lamps are a bit special
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon = 'icons/obj/lighting/lamp.dmi'
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	flashlight_range = 5
	light_wedge = LIGHT_OMNI
	on = TRUE

/obj/item/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)
	if(!usr.stat)
		attack_self(usr)

// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon = 'icons/obj/lighting/greenlamp.dmi'
	light_color = "#ffc58f"
	flashlight_range = 4
