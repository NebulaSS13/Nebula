/datum/storage/candelabra
	can_hold = list(/obj/item/flame/candle)
	storage_slots = 3
	var/static/list/candle_offsets = list(
		list("x" = -4, "y" = 17),
		list("x" =  1, "y" = 19),
		list("x" =  6, "y" = 17)
	)

/datum/storage/candelabra/can_be_inserted(obj/item/used_item, mob/user, stop_messages, click_params)
	. = ..() && holder && length(holder.get_stored_inventory()) < length(candle_offsets)

/obj/item/candelabra
	name                = "candelabra"
	desc                = "A three-tined candle stand."
	icon                = 'icons/obj/items/candelabra.dmi'
	icon_state          = ICON_STATE_WORLD
	storage             = /datum/storage/candelabra
	material            = /decl/material/solid/metal/brass
	color               = /decl/material/solid/metal/brass::color
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/candelabra/attackby(obj/item/used_item, mob/user)
	if(!user.check_intent(I_FLAG_HARM) && (used_item.isflamesource() || used_item.get_heat() > T100C))
		for(var/obj/item/flame/candle/candle in contents)
			if(!candle.lit && candle.attackby(used_item, user))
				return TRUE
	. = ..()

/obj/item/candelabra/filled/WillContain()
	return list(/obj/item/flame/candle/handmade = 3)

// Workaround for vis_contents propagating color.
/obj/item/candelabra/on_update_icon()
	..()
	var/datum/storage/candelabra/candles_storage = storage
	if(istype(candles_storage))
		var/i = 1
		for(var/obj/item/flame/candle/candle in get_stored_inventory())
			var/offsets = candles_storage.candle_offsets[i]
			candle.set_dir(SOUTH)
			for(var/image/candle_overlay in candle.get_sconce_overlay())
				candle_overlay.pixel_x = offsets["x"]
				candle_overlay.pixel_y = offsets["y"]
				candle_overlay.dir = SOUTH
				candle_overlay.appearance_flags |= RESET_COLOR|RESET_ALPHA
				add_overlay(candle_overlay)
			i++
			if(i > length(candles_storage.candle_offsets))
				break
	compile_overlays()
