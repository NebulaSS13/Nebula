/obj/item/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items/key.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	material = DEFAULT_FURNITURE_MATERIAL
	var/key_data = ""

/obj/item/key/Initialize(mapload,var/data)
	. = ..(mapload)
	if(data)
		key_data = data

/obj/item/key/proc/get_data(var/mob/user)
	return key_data

/obj/item/key/soap
	name = "soap key"
	desc = "a fragile key made using a bar of soap."
	material = /decl/material/liquid/cleaner
	var/uses = 0

/obj/item/key/soap/get_data(var/mob/user)
	uses--
	if(uses == 1)
		to_chat(user, "<span class='warning'>\The [src] is going to break soon!</span>")
	else if(uses <= 0)
		to_chat(user, "<span class='warning'>\The [src] crumbles in your hands.</span>")
		qdel(src)
	return ..()
