/obj/item/clothing/accessory/storage
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon = 'icons/clothing/accessories/storage/webbing.dmi'
	w_class = ITEM_SIZE_NORMAL
	accessory_slot = ACCESSORY_SLOT_UTILITY
	accessory_high_visibility = TRUE
	storage_type = /datum/extension/storage/pockets

/obj/item/clothing/accessory/storage/webbing_large
	name = "large webbing"
	desc = "A large collection of synthcotton pockets and pouches."
	icon = 'icons/clothing/accessories/storage/webbing_large.dmi'
	storage_type = /datum/extension/storage/pockets/webbing

/obj/item/clothing/accessory/storage/vest
	name = "webbing vest"
	desc = "Durable synthcotton vest with lots of pockets to carry essentials."
	icon = 'icons/clothing/accessories/storage/vest.dmi'
	storage_type = /datum/extension/storage/pockets/vest

/obj/item/clothing/accessory/storage/vest/black
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/storage/vest_black.dmi'

/obj/item/clothing/accessory/storage/vest/brown
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon = 'icons/clothing/accessories/storage/vest_brown.dmi'

/obj/item/clothing/accessory/storage/drop_pouches
	storage_type = /datum/extension/storage/pockets/pouches
	
/obj/item/clothing/accessory/storage/drop_pouches/black
	name = "black drop pouches"
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_black.dmi'

/obj/item/clothing/accessory/storage/drop_pouches/brown
	name = "brown drop pouches"
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_brown.dmi'

/obj/item/clothing/accessory/storage/drop_pouches/white
	name = "white drop pouches"
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_white.dmi'

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife loops."
	icon = 'icons/clothing/accessories/clothing/harness_unathi.dmi'
	storage_type = /datum/extension/storage/pockets/knifeharness

/obj/item/clothing/accessory/storage/knifeharness/Initialize()
	. = ..()
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	if(storage)
		for(var/i = 1 to 2)
			var/obj/item/knife = new /obj/item/knife/table/primitive(src)
			if(storage.can_be_inserted(knife, null, TRUE))
				storage.handle_item_insertion(knife)
	update_icon()

/obj/item/clothing/accessory/storage/knifeharness/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/contents_count = min(length(contents), 2)
	if(contents_count > 0 && check_state_in_icon("[icon_state]-[contents_count]", icon))
		icon_state = "[icon_state]-[contents_count]"

/obj/item/clothing/accessory/storage/knifeharness/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		var/contents_count = min(length(contents), 2)
		if(contents_count > 0 && check_state_in_icon("[overlay.icon_state]-[contents_count]", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-[contents_count]"
	. = ..()

/obj/item/clothing/accessory/storage/bandolier
	name = "bandolier"
	desc = "A lightweight synthethic bandolier with straps for holding ammunition or other small objects."
	icon = 'icons/obj/items/bandolier.dmi'
	storage_type = /datum/extension/storage/pockets/bandolier
