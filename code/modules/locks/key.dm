/obj/item/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items/key.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/brass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/key_data

/obj/item/key/proc/get_data(var/mob/user)
	return key_data

/obj/item/key/Initialize(mapload, material_key, _data)
	. = ..(mapload, material_key)
	key_data = _data

/obj/item/key/temporary
	name = "key"
	desc = "A fragile key with limited uses."
	material = /decl/material/liquid/cleaner/soap
	var/uses = 0

/obj/item/key/temporary/Initialize(mapload, material_key, _data, _uses)
	. = ..(mapload, material_key, _data)
	uses = _uses

/obj/item/key/temporary/get_data(var/mob/user)
	uses--
	if(uses == 1)
		to_chat(user, SPAN_DANGER("\The [src] is going to break soon!"))
	else if(uses <= 0)
		to_chat(user, SPAN_DANGER("\The [src] crumbles in your hands."))
		qdel(src)
	return ..()
