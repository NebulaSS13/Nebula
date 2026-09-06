/obj/item/stock_parts/ammo_box
	name = "ammunition supply"
	desc = "A high capacity ammunition supply designed to mechanically reload magazines with bullets."
	icon = 'icons/obj/items/storage/ammobox.dmi'
	icon_state = "ammo"
	origin_tech = @'{"engineering":3,"combat":4}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/brass = MATTER_AMOUNT_REINFORCEMENT,
	)
	var/list/stored_ammo = list()
	var/stored_caliber = null

	var/max_ammo = 50

/obj/item/stock_parts/ammo_box/Destroy()
	QDEL_NULL_LIST(stored_ammo)
	. = ..()

/obj/item/stock_parts/ammo_box/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(IS_SCREWDRIVER(used_item))
		to_chat(user, SPAN_NOTICE("You dump the ammo stored in \the [src] on the ground."))
		for(var/obj/item/ammo_casing/casing as anything in stored_ammo)
			casing.forceMove(get_turf(src))
			stored_ammo -= casing

		stored_caliber = null
		return TRUE

	if(istype(used_item, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = used_item
		if(stored_caliber && casing.caliber != stored_caliber)
			to_chat(user, SPAN_WARNING("The caliber of \the [casing] does not match the caliber stored in \the [src]!"))
			return TRUE
		if(length(stored_ammo) >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return TRUE

		casing.forceMove(src)
		stored_ammo += casing
		stored_caliber = casing.caliber

		to_chat(user, SPAN_NOTICE("You insert \the [casing] into \the [src]."))
		playsound(user, 'sound/weapons/guns/interaction/bullet_insert.ogg', 50, 1)
		return TRUE

	if(istype(used_item, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/magazine = used_item
		if(stored_caliber && magazine.caliber != stored_caliber)
			to_chat(user, SPAN_WARNING("The caliber of \the [magazine] does not match the caliber stored in \the [src]!"))
			return TRUE
		if(!magazine.get_stored_ammo_count())
			to_chat(user, SPAN_WARNING("\The [magazine] is empty!"))
			return TRUE
		if(length(stored_ammo) >= max_ammo)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return TRUE

		stored_caliber = magazine.caliber
		magazine.create_initial_contents()
		for(var/obj/item/ammo_casing/casing in magazine.stored_ammo)
			// Just in case.
			if(casing.caliber != stored_caliber)
				continue
			casing.forceMove(src)
			magazine.stored_ammo -= casing
			stored_ammo += casing
			if(length(stored_ammo) >= max_ammo)
				break

		to_chat(user, SPAN_NOTICE("You fill \the [src] [length(stored_ammo) == max_ammo ? "to capacity with" : "with the ammo stored in"] \the [magazine]"))
		playsound(user, 'sound/weapons/guns/interaction/bullet_insert.ogg', 50, 1)
		magazine.on_update_icon()
		return TRUE

/obj/item/stock_parts/ammo_box/proc/remove_ammo(var/atom/destination)
	if(length(stored_ammo))
		var/obj/item/ammo_casing/casing = stored_ammo[1]
		stored_ammo -= casing
		casing.forceMove(destination)
		if(!length(stored_ammo))
			stored_caliber = null

		return casing