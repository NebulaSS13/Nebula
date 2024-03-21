/obj/item/clothing/webbing/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife loops."
	icon = 'icons/clothing/accessories/clothing/harness_unathi.dmi'
	slots = 2
	max_w_class = ITEM_SIZE_NORMAL //for knives

/obj/item/clothing/webbing/knifeharness/Initialize()
	. = ..()
	hold.can_hold = list(
		/obj/item/hatchet,
		/obj/item/knife,
	)
	new /obj/item/knife/primitive(hold)
	new /obj/item/knife/primitive(hold)
	update_icon()

/obj/item/clothing/webbing/knifeharness/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/contents_count = min(length(contents), 2)
	if(contents_count > 0 && check_state_in_icon("[icon_state]-[contents_count]", icon))
		icon_state = "[icon_state]-[contents_count]"

/obj/item/clothing/webbing/knifeharness/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay)
		var/contents_count = min(length(contents), 2)
		if(contents_count > 0 && check_state_in_icon("[overlay.icon_state]-[contents_count]", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-[contents_count]"
	. = ..()
