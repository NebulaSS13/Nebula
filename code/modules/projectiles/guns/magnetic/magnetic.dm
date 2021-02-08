/obj/item/gun/magnetic
	name = "improvised coilgun"
	desc = "A coilgun hastily thrown together out of a basic frame and advanced power storage components. Is it safe for it to be duct-taped together like that?"
	icon = 'icons/obj/guns/coilgun.dmi'
	icon_state = ICON_STATE_WORLD
	one_hand_penalty = 5
	fire_delay = 20
	origin_tech = "{'combat':5,'materials':4,'esoteric':2,'magnets':4}"
	w_class = ITEM_SIZE_LARGE
	bulk = GUN_BULK_RIFLE
	combustion = 1

	var/obj/item/cell/cell                              // Currently installed powercell.
	var/obj/item/stock_parts/capacitor/capacitor        // Installed capacitor. Higher rating == faster charge between shots.
	var/removable_components = TRUE                            // Whether or not the gun can be dismantled.
	var/gun_unreliable = 15                                    // Percentage chance of detonating in your hands.

	var/obj/item/loaded                                        // Currently loaded object, for retrieval/unloading.
	var/load_type = /obj/item/stack/material/rods                       // Type of stack to load with.
	var/load_sheet_max = 1									   // Maximum number of "sheets" you can load from a stack.
	var/projectile_type = /obj/item/projectile/bullet/magnetic // Actual fire type, since this isn't throw_at rod launcher.

	var/power_cost = 950                                       // Cost per fire, should consume almost an entire basic cell.
	var/power_per_tick                                         // Capacitor charge per process(). Updated based on capacitor rating.

/obj/item/gun/magnetic/preloaded
	cell = /obj/item/cell/high
	capacitor = /obj/item/stock_parts/capacitor/adv

/obj/item/gun/magnetic/Initialize()
	START_PROCESSING(SSobj, src)

	if (ispath(cell))
		cell = new cell()
	if (ispath(capacitor))
		capacitor = new capacitor()
		capacitor.charge = capacitor.max_charge
	if (ispath(loaded))
		loaded = new loaded(src, load_sheet_max)

	if(capacitor)
		power_per_tick = (power_cost*0.15) * capacitor.rating
	update_icon()
	. = ..()

/obj/item/gun/magnetic/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	QDEL_NULL(loaded)
	QDEL_NULL(capacitor)
	. = ..()

/obj/item/gun/magnetic/get_cell()
	return cell

/obj/item/gun/magnetic/Process()
	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else
			if(capacitor)
				capacitor.use(capacitor.charge * 0.05)
	update_icon()

/obj/item/gun/magnetic/on_update_icon()
	. = ..()
	var/list/overlays_to_add = list()
	if(removable_components)
		if(cell)
			overlays_to_add += image(icon, "[icon_state]_cell")
		if(capacitor)
			overlays_to_add += image(icon, "[icon_state]_capacitor")
	if(!cell || !capacitor)
		overlays_to_add += image(icon, "[icon_state]_red")
	else if(capacitor.charge < power_cost)
		overlays_to_add += image(icon, "[icon_state]_amber")
	else
		overlays_to_add += image(icon, "[icon_state]_green")
	if(loaded)
		overlays_to_add += image(icon, "[icon_state]_loaded")
		var/obj/item/magnetic_ammo/mag = loaded
		if(istype(mag))
			if(mag.remaining)
				overlays_to_add += image(icon, "[icon_state]_ammo")

	overlays += overlays_to_add

/obj/item/gun/magnetic/proc/show_ammo(var/mob/user)
	if(loaded)
		to_chat(user, "<span class='notice'>It has \a [loaded] loaded.</span>")

/obj/item/gun/magnetic/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, "<span class='notice'>The installed [cell.name] has a charge level of [round((cell.charge/cell.maxcharge)*100)]%.</span>")
	if(capacitor)
		to_chat(user, "<span class='notice'>The installed [capacitor.name] has a charge level of [round((capacitor.charge/capacitor.max_charge)*100)]%.</span>")
	if(!cell || !capacitor)
		to_chat(user, "<span class='notice'>The capacitor charge indicator is blinking <font color ='[COLOR_RED]'>red</font>. Maybe you should check the cell or capacitor.</span>")
	else
		if(capacitor.charge < power_cost)
			to_chat(user, "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_ORANGE]'>amber</font>.</span>")
		else
			to_chat(user, "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_GREEN]'>green</font>.</span>")

/obj/item/gun/magnetic/proc/check_ammo()
	return loaded

/obj/item/gun/magnetic/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/gun/magnetic/consume_next_projectile()

	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	if(gun_unreliable && prob(gun_unreliable))
		spawn(3) // So that it will still fire - considered modifying Fire() to return a value but burst fire makes that annoying.
			visible_message("<span class='danger'>\The [src] explodes with the force of the shot!</span>")
			explosion(get_turf(src), -1, 0, 2)
			qdel(src)

	return new projectile_type(src)
