/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	key_type = /obj/item/pen/crayon

/obj/item/storage/fancy/crayons/WillContain()
	return list(
			/obj/item/pen/crayon/red,
			/obj/item/pen/crayon/orange,
			/obj/item/pen/crayon/yellow,
			/obj/item/pen/crayon/green,
			/obj/item/pen/crayon/blue,
			/obj/item/pen/crayon/purple,
		)


/obj/item/storage/fancy/crayons/on_update_icon()
	. = ..()
	//#FIXME: This can't handle all crayons types and colors.
	var/list/cur_overlays
	for(var/obj/item/pen/crayon/crayon in contents)
		LAZYADD(cur_overlays, overlay_image(icon, crayon.stroke_colour_name, flags = RESET_COLOR))
	if(LAZYLEN(cur_overlays))
		add_overlay(cur_overlays)
