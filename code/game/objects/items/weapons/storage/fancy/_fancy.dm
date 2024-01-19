/*
 * The 'fancy' path is for objects like candle boxes that show how many items are in the storage item on the sprite itself
 */

/obj/item/storage/box/fancy
	abstract_type = /obj/item/storage/box/fancy
	var/obj/item/key_type //path of the key item that this "fancy" container is meant to store

/obj/item/storage/box/fancy/on_update_icon()
	. = ..()
	if(key_type)
		if(!opened)
			icon_state = initial(icon_state)
		else
			var/key_count = count_by_type(contents, key_type)
			icon_state = "[initial(icon_state)][key_count]"

/obj/item/storage/box/fancy/examine(mob/user, distance)
	. = ..()
	if(distance > 1 || !key_type)
		return
	var/key_name = initial(key_type.name)
	var/key_count = count_by_type(contents, key_type)
	to_chat(user, "There [key_count == 1? "is" : "are"] [key_count] [key_name]\s in the box.")
