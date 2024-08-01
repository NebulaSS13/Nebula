/*
 * Donut box!
 */

/obj/item/box/fancy/donut
	name = "donut box"
	icon = 'icons/obj/food/containers/donutbox.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = null
	use_single_icon_overlay_state = "donutbox"
	storage = /datum/storage/box/donut

/obj/item/box/fancy/donut/update_icon_state()
	icon_state = get_world_inventory_state()

/obj/item/box/fancy/donut/adjust_contents_overlay(var/overlay_index, var/image/overlay)
	if(overlay)
		overlay.pixel_x = overlay_index * 3
	return overlay

/obj/item/box/fancy/donut/WillContain()
	return list(/obj/item/food/donut = 6)

// Subtypes below.
/obj/item/box/fancy/donut/empty/WillContain()
	return null
