/obj/item/keyring
	name = "keyring"
	desc = "A simple loop for threading keys onto."
	icon = 'icons/obj/items/keyring.dmi'
	icon_state = ICON_STATE_WORLD
	storage = /datum/storage/keyring
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY | SLOT_POCKET
	material = /decl/material/solid/metal/brass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/keyring/examine(mob/user, distance)
	. = ..()

	if(length(contents) && distance <= 1)
		var/key_strings = list()
		for(var/obj/item/key/key in contents)
			if(key.key_data)
				key_strings += SPAN_NOTICE("\The [key] unlocks '[key.key_data]'.")
			else
				key_strings += SPAN_NOTICE("\The [key] is blank.")

		if(length(key_strings))
			to_chat(user, "\The [src] holds [length(key_strings)] key\s:")
			for(var/key_string in key_strings)
				to_chat(user, key_string)

/obj/item/keyring/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/key_count = 0
	for(var/obj/item/key/key in contents)
		key_count++
		var/image/I = image(icon, "[icon_state]-[key_count]")
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA
		I.color = key.material?.color
		I.alpha = key.alpha
		add_overlay(I)
		if(key_count >= 3)
			break

/datum/storage/keyring
	can_hold = list(
		/obj/item/key,
		/obj/item/screwdriver,
		/obj/item/stack/material/bow_ammo
	)
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 8
