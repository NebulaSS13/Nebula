/obj/item/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	zoomdevicename = "eyepieces"
	icon = 'icons/obj/items/binoculars.dmi'
	icon_state = "binoculars"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	throw_range = 15
	throw_speed = 3
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY)

/obj/item/binoculars/attack_self(mob/user)
	if(zoom)
		unzoom(user)
	else
		zoom(user)
