/**
 * Sorting tag for the sorting machinery.
 */
/datum/extension/sorting_tag
	base_type     = /datum/extension/sorting_tag
	expected_type = /atom/movable //Both mob and objects can have it
	var/destination
	var/tag_icon_state
	var/tag_x = 0
	var/tag_y = 0

/datum/extension/sorting_tag/New(datum/holder, var/_destination, var/_icon_state, var/_tag_x = 0, var/_tag_y = 0)
	..(holder)
	destination = _destination
	tag_icon_state = _icon_state
	tag_x = _tag_x
	tag_y = _tag_y

///Returns a human readable description of the destination tag.
/datum/extension/sorting_tag/proc/tag_description()
	return "Its destination tag is: [destination]."

///Applies the destination tag overlay on the holder.
/datum/extension/sorting_tag/proc/apply_tag_overlay()
	var/atom/movable/H = holder
	H.add_overlay(image('icons/obj/items/storage/deliverypackage.dmi', tag_icon_state, pixel_x = tag_x, pixel_y = tag_y))