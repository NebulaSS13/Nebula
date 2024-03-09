/*
 * Vial Box
 */
/obj/item/storage/box/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	name = "vial storage box"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12
	material = /decl/material/solid/organic/plastic
	key_type = /obj/item/chems/glass/beaker/vial

/obj/item/storage/box/fancy/vials/WillContain()
	return list(/obj/item/chems/glass/beaker/vial = 12)

/obj/item/storage/box/fancy/vials/on_update_icon()
	. = ..()
	var/key_count = count_by_type(contents, key_type)
	icon_state = "[initial(icon_state)][FLOOR(key_count/2)]"

/*
 * Not actually a "fancy" storage...
 */
/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = null
	storage_slots = 12
	req_access = list(access_virology)
	material = /decl/material/solid/metal/stainlesssteel

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/lockbox/vials/on_update_icon()
	. = ..()
	var/total_contents = count_by_type(contents, /obj/item/chems/glass/beaker/vial)
	icon_state = "vialbox[FLOOR(total_contents/2)]"
	if (!broken)
		add_overlay("led[locked]")
		if(locked)
			add_overlay("cover")
	else
		add_overlay("ledb")

/obj/item/storage/lockbox/vials/attackby(obj/item/W, mob/user)
	. = ..()
	update_icon()