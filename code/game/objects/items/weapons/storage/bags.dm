/*
	Represents flexible bags that expand based on the size of their contents.
*/
/obj/item/bag
	storage = /datum/storage/bag
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW

/obj/item/bag/proc/update_w_class()
	w_class = initial(w_class)
	for(var/obj/item/I in contents)
		w_class = max(w_class, I.w_class)
	if(storage)
		var/cur_storage_space = storage.storage_space_used()
		while(BASE_STORAGE_CAPACITY(w_class) < cur_storage_space)
			w_class++

/obj/item/bag/get_storage_cost()
	if(storage)
		var/used_ratio = storage.storage_space_used()/storage.max_storage_space
		return max(BASE_STORAGE_COST(w_class), round(used_ratio * BASE_STORAGE_COST(storage.max_w_class), 1))
	return BASE_STORAGE_COST(initial(w_class))

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/items/storage/trashbag.dmi'
	icon_state = "trashbag"
	item_state = "trashbag"
	storage = /datum/storage/bag/trash
	w_class = ITEM_SIZE_SMALL

/obj/item/bag/trash/update_w_class()
	..()
	update_icon()

/obj/item/bag/trash/on_update_icon()
	. = ..()
	switch(w_class)
		if(2) icon_state = "[initial(icon_state)]"
		if(3) icon_state = "[initial(icon_state)]1"
		if(4) icon_state = "[initial(icon_state)]2"
		if(5 to INFINITY) icon_state = "[initial(icon_state)]3"

/obj/item/bag/trash/advanced
	name = "trash bag of holding"
	desc = "The latest and greatest in custodial convenience, a trashbag that is capable of holding vast quantities of garbage."
	icon_state = "bluetrashbag"
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"exoticmatter":5,"materials":6}'
	storage = /datum/storage/bag/trash/advanced

/obj/item/bag/trash/advanced/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/backpack/holding) || istype(W, /obj/item/bag/trash/advanced))
		to_chat(user, "<span class='warning'>The spatial interfaces of the two devices conflict and malfunction.</span>")
		qdel(W)
		return 1
	return ..()

// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/bag/flimsy
	name = "bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/items/storage/plasticbag.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"
	storage = /datum/storage/bag/plastic
	w_class = ITEM_SIZE_TINY

	material = /decl/material/solid/organic/plastic
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/bag/cash
	name = "cash bag"
	icon = 'icons/obj/items/storage/cashbag.dmi'
	icon_state = "cashbag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	w_class = ITEM_SIZE_SMALL
	storage = /datum/storage/bag/cash
	material = /decl/material/solid/organic/leather/synth

/obj/item/bag/cash/filled/Initialize()
	. = ..()
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	new /obj/item/cash/c1000(src)
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/bag/sack
	name = "sack"
	desc = "A simple sack for carrying goods."
	icon = 'icons/obj/items/storage/sack.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK
	storage = /datum/storage/bag/sack
	material = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/bag/sack/update_w_class()
	..()
	update_icon()

/obj/item/bag/sack/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	switch(w_class)
		if(3)
			icon_state = "[icon_state]1"
		if(4)
			icon_state = "[icon_state]2"
		if(5 to INFINITY)
			icon_state = "[icon_state]3"
