/obj/item/gun/magnetic
	name = "improvised coilgun"
	desc = "A coilgun hastily thrown together out of a basic frame and advanced power storage components. Is it safe for it to be duct-taped together like that?"
	icon = 'icons/obj/guns/coilgun.dmi'
	icon_state = ICON_STATE_WORLD
	one_hand_penalty = 5
	fire_delay = 20
	w_class = ITEM_SIZE_LARGE
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
//		var/obj/item/magnetic_ammo/mag = loaded
//		if(istype(mag))
//			if(mag.remaining)
//				overlays_to_add += image(icon, "[icon_state]_ammo")

	add_overlay(overlays_to_add)

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
		to_chat(user, "<span class='notice'>The capacitor charge indicator is blinking [SPAN_RED("red")]. Maybe you should check the cell or capacitor.</span>")
	else
		if(capacitor.charge < power_cost)
			to_chat(user, "<span class='notice'>The capacitor charge indicator is [SPAN_ORANGE("amber")].</span>")
		else
			to_chat(user, "<span class='notice'>The capacitor charge indicator is [SPAN_GREEN("green")].</span>")

/obj/item/gun/magnetic/attackby(var/obj/item/thing, var/mob/user)

	if(removable_components)
		if(istype(thing, /obj/item/cell))
			if(cell)
				to_chat(user, "<span class='warning'>\The [src] already has \a [cell] installed.</span>")
				return
			if(!user.try_unequip(thing, src))
				return
			cell = thing
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [src].</span>")
			update_icon()
			return

		if(IS_SCREWDRIVER(thing))
			if(!capacitor)
				to_chat(user, "<span class='warning'>\The [src] has no capacitor installed.</span>")
				return
			user.put_in_hands(capacitor)
			user.visible_message("<span class='notice'>\The [user] unscrews \the [capacitor] from \the [src].</span>")
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			capacitor = null
			update_icon()
			return

		if(istype(thing, /obj/item/stock_parts/capacitor))
			if(capacitor)
				to_chat(user, "<span class='warning'>\The [src] already has \a [capacitor] installed.</span>")
				return
			if(!user.try_unequip(thing, src))
				return
			capacitor = thing
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			power_per_tick = (power_cost*0.15) * capacitor.rating
			user.visible_message("<span class='notice'>\The [user] slots \the [capacitor] into \the [src].</span>")
			update_icon()
			return

	if(istype(thing, load_type))

		// This is not strictly necessary for the magnetic gun but something using
		// specific ammo types may exist down the track.
		var/obj/item/stack/ammo = thing
		if(!istype(ammo))
			if(loaded)
				to_chat(user, "<span class='warning'>\The [src] already has \a [loaded] loaded.</span>")
				return
//			var/obj/item/magnetic_ammo/mag = thing
//			if(istype(mag))
//				if(!(load_type == mag.basetype))
//					to_chat(user, "<span class='warning'>\The [src] doesn't seem to accept \a [mag].</span>")
//					return
//				projectile_type = mag.projectile_type
			if(!user.try_unequip(thing, src))
				return

			loaded = thing
		else if(load_sheet_max > 1)
			var ammo_count = 0
			var/obj/item/stack/loaded_ammo = loaded
			if(!istype(loaded_ammo))
				ammo_count = min(load_sheet_max,ammo.amount)
				loaded = new load_type(src, ammo_count)
			else
				ammo_count = min(load_sheet_max-loaded_ammo.amount,ammo.amount)
				loaded_ammo.amount += ammo_count
			if(ammo_count <= 0)
				// This will also display when someone tries to insert a stack of 0, but that shouldn't ever happen anyway.
				to_chat(user, "<span class='warning'>\The [src] is already fully loaded.</span>")
				return
			ammo.use(ammo_count)
		else
			if(loaded)
				to_chat(user, "<span class='warning'>\The [src] already has \a [loaded] loaded.</span>")
				return
			loaded = new load_type(src, 1)
			ammo.use(1)

		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [loaded].</span>")
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()

/obj/item/gun/magnetic/attack_hand(var/mob/user)
	if(!user.is_holding_offhand(src) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/obj/item/removing
	if(loaded)
		removing = loaded
		loaded = null
	else if(cell && removable_components)
		removing = cell
		cell = null
	if(removing)
		user.put_in_hands(removing)
		user.visible_message(SPAN_NOTICE("\The [user] removes \the [removing] from \the [src]."))
		playsound(loc, 'sound/machines/click.ogg', 10, 1)
		update_icon()
	return TRUE

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

/obj/item/gun/magnetic/railgun
	name = "railgun"
	desc = "The HelTek Arms LM-76 Thunderclap. A portable linear motor cannon produced during the Gaia Conflict for anti-armour and anti-fortification operations. Today, it sees wide use among private militaries, and is a staple on the black market."
	icon = 'icons/obj/guns/railgun.dmi'
	removable_components = TRUE // Can swap out the capacitor for more shots, or cell for longer usage before recharge
	load_type = /obj/item/rcd_ammo
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	one_hand_penalty = 6
	power_cost = 300
	fire_delay = 35
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	loaded = /obj/item/rcd_ammo/large // ~30 shots
	combustion = 1
	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv // 6-8 shots
	gun_unreliable = 0
	var/slowdown_held = 3
	var/slowdown_worn = 2

/obj/item/gun/magnetic/railgun/Initialize()
	LAZYSET(slowdown_per_slot, BP_L_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, BP_R_HAND,        slowdown_held)
	LAZYSET(slowdown_per_slot, slot_back_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_belt_str,    slowdown_worn)
	LAZYSET(slowdown_per_slot, slot_s_store_str, slowdown_worn)

	. = ..()

// Not going to check type repeatedly, if you code or varedit
// load_type and get runtime errors, don't come crying to me.
/obj/item/gun/magnetic/railgun/show_ammo(var/mob/user)
	var/obj/item/rcd_ammo/ammo = loaded
	if (ammo)
		to_chat(user, "<span class='notice'>There are [ammo.remaining] shot\s remaining in \the [loaded].</span>")
	else
		to_chat(user, "<span class='notice'>There is nothing loaded.</span>")

/obj/item/gun/magnetic/railgun/check_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	return ammo && ammo.remaining

/obj/item/gun/magnetic/railgun/use_ammo()
	var/obj/item/rcd_ammo/ammo = loaded
	ammo.remaining--
	if(ammo.remaining <= 0)
		spawn(3)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		out_of_ammo()

/obj/item/gun/magnetic/railgun/proc/out_of_ammo()
	qdel(loaded)
	loaded = null
	visible_message("<span class='warning'>\The [src] beeps and ejects its empty cartridge.</span>")

/obj/item/gun/magnetic/railgun/flechette
	name = "flechette gun"
	desc = "The MI-12 Skadi is a burst fire capable railgun that fires flechette rounds at high velocity. Deadly against armour, but much less effective against soft targets."
	icon = 'icons/obj/guns/flechette.dmi'
	one_hand_penalty = 2
	fire_delay = 8
	removable_components = FALSE
	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv
	slot_flags = SLOT_BACK
	power_cost = 100
	projectile_type = /obj/item/projectile/bullet/magnetic/flechette
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY
	)
	firemodes = list(
		list(mode_name="semiauto",    burst=1, fire_delay=0,     one_hand_penalty=1, burst_accuracy=null, dispersion=null),
		list(mode_name="short bursts", burst=3, fire_delay=null, one_hand_penalty=2, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/gun/magnetic/railgun/flechette/out_of_ammo()
	visible_message("<span class='warning'>\The [src] beeps to indicate the magazine is empty.</span>")
