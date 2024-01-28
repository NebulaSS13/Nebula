/obj/item/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items/key.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/brass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/key_data = ""

/obj/item/key/Initialize(var/mapload, var/material_key, var/new_key_data)
	. = ..(mapload, material_key)
	if(new_key_data)
		key_data = new_key_data

/obj/item/key/proc/get_data(var/mob/user)
	return key_data

/obj/item/key/soap
	material = /decl/material/liquid/cleaner/soap
	var/uses = 0

/obj/item/key/soap/get_data(var/mob/user)
	uses--
	if(uses == 1)
		to_chat(user, "<span class='warning'>\The [src] is going to break soon!</span>")
	else if(uses <= 0)
		to_chat(user, "<span class='warning'>\The [src] crumbles in your hands.</span>")
		qdel(src)
	return ..()
