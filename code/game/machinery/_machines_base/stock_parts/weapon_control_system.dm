/obj/item/stock_parts/weapon_control_system
	name = "weapon control system"
	desc = "An integrated weapon control system module, designed to allow various machinery to manipulate firearms."
	icon_state = "hyperwave_filter"
	part_flags = PART_FLAG_HAND_REMOVE
	base_type = /obj/item/stock_parts/weapon_control_system

	var/power_use = 500 // Base power use per shot TODO Calculate power use based on gun installed
	var/obj/item/gun/installed_gun


/obj/item/stock_parts/weapon_control_system/Initialize()
	. = ..()

	if (installed_gun)
		installed_gun = new installed_gun

	update_data()


/obj/item/stock_parts/weapon_control_system/examine(mob/user)
	. = ..()

	if (!installed_gun)
		to_chat(user, SPAN_INFO("It does not currently have a gun installed."))
	else
		to_chat(user, SPAN_INFO("It has \a [installed_gun] installed."))


/obj/item/stock_parts/weapon_control_system/attackby(obj/item/W, mob/user)
	if (istype(loc, /obj/machinery))
		return

	var/obj/item/gun/G = W
	if (istype(G))
		if (installed_gun)
			to_chat(user, SPAN_NOTICE("\The [initial(name)] already has \a [installed_gun] installed."))
			return TRUE

		if (!G.can_use_wcs)
			to_chat(user, SPAN_NOTICE("\The [initial(name)] is not compatible with \the [G]."))
			return TRUE

		if (!user.unEquip(G, src)) return TRUE
		to_chat(user, SPAN_NOTICE("You insert \the [G] into \the [initial(name)]."))
		installed_gun = G
		update_data()
		return TRUE

	. = ..()


/obj/item/stock_parts/weapon_control_system/attack_self(mob/user)
	if (installed_gun)
		user.put_in_hands(installed_gun)
		to_chat(user, SPAN_NOTICE("You remove \the [installed_gun] from \the [initial(name)]."))
		installed_gun = null
		update_data()
		return TRUE

	. = ..()


/obj/item/stock_parts/weapon_control_system/proc/update_data()
	if (!installed_gun)
		SetName("[initial(name)] (empty)")
		w_class = initial(w_class)
	else
		SetName("[initial(name)] ([installed_gun.name])")
		w_class = installed_gun.w_class
	update_icon()


/obj/item/stock_parts/weapon_control_system/on_update_icon()
	. = ..()

	if (installed_gun)
		var/mutable_appearance/MA = new(installed_gun)
		MA.layer = FLOAT_LAYER
		MA.plane = FLOAT_PLANE
		underlays = list(MA)
	else
		underlays = list()


/** Variants that initialize with a gun installed. Primarily intended to be used in mapped turrets **/
/obj/item/stock_parts/weapon_control_system/egun
	installed_gun = /obj/item/gun/energy/gun
