/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	name = "egg box"
	icon = 'icons/obj/food/containers/eggbox.dmi'
	icon_state = ICON_STATE_WORLD
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	key_type = /obj/item/chems/food/egg
	can_hold = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/boiledegg
	)

/obj/item/storage/fancy/egg_box/WillContain()
	return list(/obj/item/chems/food/egg = 12)

/obj/item/storage/fancy/egg_box/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(opened)
		icon_state = "[icon_state]_open"
		var/i = 0
		for(var/obj/item/egg in contents)
			var/egg_state = "[egg.icon_state]_eggbox"
			if(!check_state_in_icon(egg_state, egg.icon))
				continue
			var/image/I = image(egg.icon, egg_state)
			I.pixel_x = (i % 6) * 3
			if(i > 6)
				I.pixel_y = 3
			add_overlay(I)
			i++

/obj/item/storage/fancy/egg_box/assorted/WillContain()
	return list(
		/obj/item/chems/food/egg         = 1,
		/obj/item/chems/food/egg/blue    = 1,
		/obj/item/chems/food/egg/green   = 1,
		/obj/item/chems/food/egg/mime    = 1,
		/obj/item/chems/food/egg/orange  = 1,
		/obj/item/chems/food/egg/purple  = 1,
		/obj/item/chems/food/egg/rainbow = 1,
		/obj/item/chems/food/egg/red     = 1,
		/obj/item/chems/food/egg/yellow  = 1,
		/obj/item/chems/food/boiledegg   = 1,
		/obj/item/chems/food/egg/lizard  = 1
	)

/obj/item/storage/fancy/egg_box/empty/WillContain()
	return
