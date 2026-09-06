/datum/storage/box/nuggets
	can_hold                  = list(/obj/item/food/nugget)
	var/expected_nugget_count = 10

/datum/storage/box/nuggets/New()
	max_storage_space = /obj/item/food/nugget::w_class * expected_nugget_count
	..()

/datum/storage/box/nuggets/twenty
	expected_nugget_count = 20

/datum/storage/box/nuggets/forty
	expected_nugget_count = 40

/obj/item/box/nuggets
	name = "10-piece nuggets box"
	icon = 'icons/obj/items/storage/nugget_box.dmi'
	icon_state = "nuggetbox_ten"
	desc = "A share pack of golden chicken nuggets in various fun shapes. Rumours of the rare and deadly 'fifth nugget shape' remain unsubstantiated."
	storage = /datum/storage/box/nuggets
	center_of_mass = @'{"x":16,"y":9}'

/obj/item/box/nuggets/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/box/nuggets/WillContain()
	. = list()
	if(istype(storage, /datum/storage/box/nuggets))
		var/datum/storage/box/nuggets/nugget_box = storage
		for(var/i = 1 to nugget_box.expected_nugget_count)
			. += /obj/item/food/nugget

/obj/item/box/nuggets/on_update_icon()
	. = ..()
	var/datum/storage/box/nuggets/nugget_box = storage
	if(length(contents) == 0 || !istype(nugget_box))
		icon_state = "[initial(icon_state)]_empty"
	else if(length(contents) >= nugget_box.expected_nugget_count)
		icon_state = "[initial(icon_state)]_full"
	else
		icon_state = initial(icon_state)

// Subtypes below.
/obj/item/box/nuggets/twenty
	name = "20-piece nuggets box"
	icon_state = "nuggetbox_twenty"
	storage = /datum/storage/box/nuggets/twenty

/obj/item/box/nuggets/twenty/WillContain()
	. = list()
	for(var/i = 1 to 20)
		. += /obj/item/food/nugget

/obj/item/box/nuggets/twenty/empty/WillContain()
	return

/obj/item/box/nuggets/forty
	name = "40-piece nuggets box"
	icon_state = "nuggetbox_forty"
	storage = /datum/storage/box/nuggets/forty

/obj/item/box/nuggets/forty/empty/WillContain()
	return
