/*
 * The 'fancy' path is for objects like candle boxes that show how many items are in the storage item on the sprite itself
 */

/obj/item/box/fancy
	abstract_type = /obj/item/box/fancy
	/// A string modifier used to generate overlays for contents.
	var/use_single_icon_overlay_state
	/// The root type of the key item that this "fancy" container is meant to store.
	var/obj/item/key_type

/obj/item/box/fancy/proc/adjust_contents_overlay(var/overlay_index, var/image/overlay)
	return overlay

/obj/item/box/fancy/proc/update_icon_state()
	icon_state = initial(icon_state)
	if(key_type && storage?.opened)
		icon_state = "[icon_state][count_by_type(contents, key_type)]"

/obj/item/box/fancy/proc/add_contents_overlays()
	. = FALSE
	if(!use_single_icon_overlay_state)
		return
	var/offset_index = 0
	for(var/obj/item/thing in contents)
		var/thing_state = "[thing.icon_state]_[use_single_icon_overlay_state]"
		if(!check_state_in_icon(thing_state, thing.icon))
			continue
		. = TRUE
		var/image/thing_overlay = adjust_contents_overlay(offset_index, image(thing.icon, thing_state))
		if(thing.color)
			thing_overlay.color = thing.color
		thing_overlay.appearance_flags |= RESET_COLOR
		add_overlay(thing_overlay)
		offset_index++

/obj/item/box/fancy/on_update_icon()
	. = ..()
	update_icon_state()
	if(add_contents_overlays())
		compile_overlays()

/obj/item/box/fancy/examine(mob/user, distance)
	. = ..()
	if(distance > 1 || !key_type)
		return
	var/key_count = count_by_type(contents, key_type)
	to_chat(user, "There [key_count == 1? "is" : "are"] [key_count] [initial(key_type.name)]\s in the box.")
