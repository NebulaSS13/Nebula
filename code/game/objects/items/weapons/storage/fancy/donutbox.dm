/*
 * Donut box!
 */

/obj/item/storage/box/fancy/donut
	name = "donut box"
	icon = 'icons/obj/food/containers/donutbox.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = null
	max_storage_space = ITEM_SIZE_SMALL * 6
	can_hold = list(/obj/item/chems/food/donut)
	use_single_icon_overlay_state = "donutbox"

/obj/item/storage/box/fancy/donut/update_icon_state()
	icon_state = get_world_inventory_state()

/obj/item/storage/box/fancy/donut/adjust_contents_overlay(var/overlay_index, var/image/overlay)
	if(overlay)
		overlay.pixel_x = overlay_index * 3
	return overlay

/obj/item/storage/box/fancy/donut/WillContain()
	return list(/obj/item/chems/food/donut = 6)

// Subtypes below.
/obj/item/storage/box/fancy/donut/empty/WillContain()
	return null
