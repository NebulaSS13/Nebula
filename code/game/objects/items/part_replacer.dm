/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon = 'icons/obj/items/device/parts_replacer.dmi'
	icon_state = "RPED"
	item_state = "RPED"
	w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 50
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

	var/replace_sound = 'sound/items/rped.ogg'
	var/remote_interaction = FALSE

/obj/item/storage/part_replacer/proc/part_replacement_sound()
	playsound(src, replace_sound, 40, 1)

/obj/item/storage/part_replacer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag || !remote_interaction)
		return

	if(istype(target, /obj/machinery))
		var/obj/machinery/machine = target
		if(machine.component_attackby(src, user))
			user.Beam(machine, icon_state = "rped_upgrade", icon = 'icons/effects/effects.dmi', time = 5)

/obj/item/storage/part_replacer/advanced
	name = "advanced rapid part exchange device"
	desc = "A version of the RPED that allows for replacement of parts and scanning from a distance, along with higher capacity for parts."
	icon_state = "RPED_BS"
	w_class = ITEM_SIZE_NORMAL
	storage_slots = 400
	max_storage_space = 200
	replace_sound = 'sound/items/PSHOOM.ogg'
	remote_interaction = TRUE
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
