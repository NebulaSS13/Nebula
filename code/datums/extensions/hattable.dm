// Note that humans handle hats on their own without this extension.
// This is primarily for diona nymphs and maintenance drones.
/datum/extension/hattable
	base_type = /datum/extension/hattable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/offsets
	var/obj/item/hat

/datum/extension/hattable/New(var/datum/holder, var/new_offsets)
	offsets = islist(new_offsets) ? new_offsets : list(0, 0)
	..()

/datum/extension/hattable/proc/wear_hat(var/mob/wearer, var/obj/item/clothing/head/new_hat)
	if(hat || !new_hat)
		return FALSE
	hat = new_hat
	hat.forceMove(wearer)
	hat.equipped(wearer)
	wearer.update_icon()
	return TRUE

/datum/extension/hattable/proc/get_hat_overlay(var/mob/wearer, var/apply_offsets = TRUE)
	var/image/I = hat?.get_mob_overlay(wearer, slot_head_str)
	if(I && apply_offsets)
		I.pixel_x += offsets[1]
		I.pixel_y += offsets[2]
	return I

/datum/extension/hattable/proc/drop_hat(var/mob/wearer)
	if((hat in wearer) && !QDELETED(hat))
		wearer.remove_from_mob(hat)
	hat = null
	wearer.update_icon()

var/global/list/mob_hat_cache = list()
/datum/extension/hattable/directional/proc/offset_image(var/image/I)

	if(!istype(I))
		return

	var/mob/owner = holder
	if(!istype(owner))
		return I

	var/cache_key = "[I.icon]-[I.icon_state]-[json_encode(offsets)]-[owner.icon]"
	if(!global.mob_hat_cache[cache_key])
		var/icon/final = icon(owner.icon, "template") // whoever makes a mob hattable should also check it has a template state in its image
		for(var/dir in offsets)
			var/list/facing_list = offsets[dir]
			var/icon/canvas = icon(owner.icon, "template")
			var/use_dir = text2num(dir)
			canvas.Blend(icon(I.icon, I.icon_state, dir = use_dir), ICON_OVERLAY, facing_list[1]+1, facing_list[2]+1)
			final.Insert(canvas, dir = use_dir)
		global.mob_hat_cache[cache_key] = final

	I.icon = global.mob_hat_cache[cache_key]
	I.icon_state = ""
	for(var/thing in I.overlays)
		I.overlays -= thing
		I.overlays += offset_image(thing)

	return I

/datum/extension/hattable/directional/get_hat_overlay(var/mob/wearer, var/apply_offsets = TRUE)
	return offset_image(..(wearer, FALSE))
