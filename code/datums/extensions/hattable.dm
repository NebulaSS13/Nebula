var/list/mob_hat_cache = list()
	
// Note that humans handle hats on their own without this extension.
// This is primarily for diona nymphs and maintenance drones.
/datum/extension/hattable
	base_type = /datum/extension/hattable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/offset_x = 0
	var/offset_y = 0
	var/obj/item/hat

/datum/extension/hattable/New(var/datum/holder, var/new_offset_x, var/new_offset_y)
	if(!isnull(new_offset_x))
		offset_x = new_offset_x
	if(!isnull(new_offset_y))
		offset_y = new_offset_y
	..()

/datum/extension/hattable/proc/wear_hat(var/mob/wearer, var/obj/item/clothing/head/new_hat)
	if(hat || !new_hat)
		return FALSE
	hat = new_hat
	hat.forceMove(wearer)
	hat.equipped(wearer)
	wearer.update_icons()
	return TRUE

/datum/extension/hattable/proc/get_hat_overlay(var/mob/wearer)
	var/image/I = hat?.get_mob_overlay(wearer, slot_head_str)
	if(I)
		I.pixel_x += offset_x
		I.pixel_y += offset_y
		return I

/datum/extension/hattable/proc/drop_hat(var/mob/wearer)
	wearer.remove_from_mob(hat)
	hat = null
	wearer.update_icons()
