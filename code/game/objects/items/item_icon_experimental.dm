// This file is an experiment in changing the way item icons are handled.
// Not really expecting it to work out of the box, so we'll see how it goes
// with a handful of specific items.
var/list/if_has_inventory_icon_cache = list()  // for checking if we have special in-inventory HUD state. Cached cause asking icons is expensive

/obj/item
	var/on_mob_icon
	var/tmp/has_inventory_icon	// do not set manually

/obj/item/Initialize(ml, material_key)
	. = ..()
	if(on_mob_icon)
		icon = on_mob_icon
		icon_state = "world"
		update_icon()

/obj/item/hud_layerise()
	..()
	update_world_inventory_state()

/obj/item/reset_plane_and_layer()
	..()
	update_world_inventory_state()

/obj/item/proc/update_world_inventory_state()
	if(on_mob_icon && has_inventory_state())
		var/last_state = icon_state
		if(plane == HUD_PLANE)
			icon_state = "inventory"
		else
			icon_state = "world"
		if(last_state != icon_state)
			update_icon()

/obj/item/proc/has_inventory_state()
	if(isnull(if_has_inventory_icon_cache[type]))
		if_has_inventory_icon_cache[type] = !!("inventory" in icon_states(icon))
	return if_has_inventory_icon_cache[type]

/mob/proc/get_bodytype()
	return

/obj/item/proc/experimental_mob_overlay(var/mob/user_mob, var/slot)
	var/bodytype = lowertext(user_mob?.get_bodytype() || BODYTYPE_HUMANOID)
	var/image/I = image(get_icon_for_bodytype(bodytype), "[bodytype]-[slot]")
	I.color = color
	I.appearance_flags = RESET_COLOR
	. = apply_offsets(user_mob, I, slot)
	. = apply_overlays(user_mob, bodytype, I, slot)

/mob/living/carbon/get_bodytype()
	. = species && species.get_bodytype(src)

/obj/item/proc/get_icon_for_bodytype(var/bodytype)
	. = icon

/obj/item/proc/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	. = overlay

/obj/item/proc/apply_offsets(var/mob/user_mob, var/image/overlay, var/slot)
	. = overlay
