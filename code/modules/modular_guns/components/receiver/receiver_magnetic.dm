/obj/item/firearm_component/receiver/magnetic
	fire_delay = 20
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
/*
/obj/item/gun/Initialize()
	START_PROCESSING(SSobj, src)
	if(capacitor)
		power_per_tick = (power_cost*0.15) * capacitor.rating
	update_icon()
	. = ..()

/obj/item/gun/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	QDEL_NULL(loaded)
	QDEL_NULL(capacitor)
	. = ..()

/obj/item/gun/get_cell()
	return cell

/obj/item/gun/Process()
	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else
			if(capacitor)
				capacitor.use(capacitor.charge * 0.05)
	update_icon()

/obj/item/gun/on_update_icon()
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

/obj/item/gun/proc/show_ammo(var/mob/user)
	if(loaded)
		to_chat(user, "<span class='notice'>It has \a [loaded] loaded.</span>")

/obj/item/gun/examine(mob/user)
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

/obj/item/gun/proc/check_ammo()
	return loaded

/obj/item/gun/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/gun/consume_next_projectile()

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
*/

/obj/item/firearm_component/receiver/magnetic/railgun
	fire_delay = 35
	power_cost = 300
	loaded = /obj/item/rcd_ammo/large // ~30 shots
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	gun_unreliable = 0
	removable_components = TRUE // Can swap out the capacitor for more shots, or cell for longer usage before recharge
	load_type = /obj/item/rcd_ammo
	var/initial_cell_type = /obj/item/cell/hyper
	var/initial_capacitor_type = /obj/item/stock_parts/capacitor/adv // 6-8 shots
	var/slowdown_held = 3
	var/slowdown_worn = 2
/*
/obj/item/gun/cannon/railgun/Initialize()

	capacitor = new initial_capacitor_type(src)
	capacitor.charge = capacitor.max_charge

	cell = new initial_cell_type(src)
	if (ispath(loaded))
		loaded = new loaded (src, load_sheet_max)
	LAZYSET(slowdown_per_slot, BP_L_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, BP_R_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, slot_back_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_belt_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_s_store_str, slowdown_worn)

	. = ..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/gun/cannon/railgun/show_ammo(var/mob/user)
	var/obj/item/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")
	else
		to_chat(user, "<span class='notice'>There is nothing loaded.</span>")

/obj/item/gun/cannon/railgun/check_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/gun/cannon/railgun/use_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		out_of_ammo()

/obj/item/gun/cannon/railgun/proc/out_of_ammo()
	qdel(loaded)
	loaded = null
	visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>")
*/

/obj/item/firearm_component/receiver/magnetic/railgun/flechette
	fire_delay = 8
	removable_components = FALSE
	initial_cell_type = /obj/item/cell/hyper
	initial_capacitor_type = /obj/item/stock_parts/capacitor/adv
	load_type = /obj/item/magnetic_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	loaded = /obj/item/magnetic_ammo
	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,     one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
	)
/*
/obj/item/gun/cannon/flechette/out_of_ammo()
	visible_message("<span class='warning'>\The [src] beeps to indicate the magazine is empty.</span>")
*/
