/*
 * Donut box!
 */

/obj/item/storage/box/fancy/donut
	name = "donut box"
	icon = 'icons/obj/food/containers/donutbox.dmi'
	icon_state = ICON_STATE_WORLD
	can_hold = list(/obj/item/chems/food/donut)

/obj/item/storage/box/fancy/donut/WillContain()
	return list(/obj/item/chems/food/donut = 6)

/obj/item/storage/box/fancy/donut/on_update_icon()
	. = ..()
	var/i = 0
	for(var/obj/item/donut in contents)
		var/donut_state = "[donut.icon_state]_donutbox"
		if(!check_state_in_icon(donut_state, donut.icon))
			continue
		var/image/I = image(donut.icon, donut_state)
		I.pixel_x = i * 3
		if(donut.color)
			I.color = donut.color
			I.appearance_flags |= RESET_COLOR
		add_overlay(I)
		i++
		if(i >= 6)
			break // too many donuts, somehow

/obj/item/storage/box/fancy/donut/empty/WillContain()
	return null
