var/global/list/laser_wavelengths

/decl/laser_wavelength
	var/name
	var/color
	var/light_color
	var/damage_multiplier
	var/armour_multiplier

/decl/laser_wavelength/red
	name = "638nm"
	color = COLOR_RED
	light_color = COLOR_RED_LIGHT
	damage_multiplier = 1
	armour_multiplier = 0.1

/decl/laser_wavelength/yellow
	name = "589nm"
	color = COLOR_GOLD
	light_color = COLOR_GOLD
	damage_multiplier = 0.9
	armour_multiplier = 0.2

/decl/laser_wavelength/green
	name = "515nm"
	color = COLOR_LIME
	light_color = COLOR_LIME
	damage_multiplier = 0.8
	armour_multiplier = 0.3

/decl/laser_wavelength/blue
	name = "473nm"
	color = COLOR_CYAN
	light_color = COLOR_BLUE_LIGHT
	damage_multiplier = 0.7
	armour_multiplier = 0.4

/decl/laser_wavelength/violet
	name = "405nm"
	color = "#ff00dc"
	light_color = "#ff00dc"
	damage_multiplier = 0.6
	armour_multiplier = 0.5

/obj/item/gun/energy/capacitor
	name = "capacitor pistol"
	desc = "An excitingly chunky directed energy weapon that uses a modular capacitor array to charge each shot."
	icon = 'icons/obj/guns/capacitor_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':4,'powerstorage':4}"
	w_class = ITEM_SIZE_NORMAL
	charge_cost = 100
	accuracy = 2
	fire_delay = 10
	slot_flags = SLOT_LOWER_BODY
	cell_type = /obj/item/cell/high
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/variable
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

	var/wiring_color = COLOR_CYAN_BLUE
	var/max_capacitors = 2
	var/list/capacitors = /obj/item/stock_parts/capacitor
	var/const/charge_iteration_delay = 3
	var/const/capacitor_charge_constant = 10
	var/decl/laser_wavelength/charging
	var/decl/laser_wavelength/selected_wavelength

/obj/item/gun/energy/capacitor/examine(mob/user, distance)
	. = ..()
	if(loc == user || distance <= 1)
		to_chat(user, "The wavelength selector is dialled to [selected_wavelength.name].")

/obj/item/gun/energy/capacitor/Destroy()
	if(capacitors)
		QDEL_NULL_LIST(capacitors)
	. = ..()

/obj/item/gun/energy/capacitor/Initialize()
	if(!laser_wavelengths)
		laser_wavelengths = list()
		for(var/laser in subtypesof(/decl/laser_wavelength))
			laser_wavelengths += GET_DECL(laser)
	selected_wavelength = pick(laser_wavelengths)
	if(ispath(capacitors))
		var/capacitor_type = capacitors
		capacitors = list()
		for(var/i = 1 to max_capacitors)
			capacitors += new capacitor_type(src)
	. = ..()

/obj/item/gun/energy/capacitor/afterattack(atom/A, mob/living/user, adjacent, params)
	. = !charging && ..()

/obj/item/gun/energy/capacitor/attackby(obj/item/W, mob/user)

	if(charging)
		return ..()

	if(isScrewdriver(W))
		if(length(capacitors))
			var/obj/item/stock_parts/capacitor/capacitor = capacitors[1]
			capacitor.charge = 0
			user.put_in_hands(capacitor)
			LAZYREMOVE(capacitors, capacitor)
		else if(power_supply)
			user.put_in_hands(power_supply)
			power_supply = null
		else
			to_chat(user, SPAN_WARNING("\The [src] does not have a cell or capacitor installed."))
			return TRUE
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25)
		update_icon()
		return TRUE

	if(istype(W, /obj/item/cell))
		if(power_supply)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
		else if(user.unEquip(W, src))
			power_supply = W
			to_chat(user, SPAN_NOTICE("You fit \the [W] into \the [src]."))
			update_icon()
		return TRUE

	if(istype(W, /obj/item/stock_parts/capacitor))
		if(length(capacitors) >= max_capacitors)
			to_chat(user, SPAN_WARNING("\The [src] cannot fit any additional capacitors."))
		else if(user.unEquip(W, src))
			LAZYADD(capacitors, W)
			to_chat(user, SPAN_NOTICE("You fit \the [W] into \the [src]."))
			update_icon()
		return TRUE

	. = ..()

/obj/item/gun/energy/capacitor/attack_self(var/mob/user)

	if(charging)
		for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
			capacitor.charge = 0
		update_icon()
		charging = FALSE
	else
		var/new_wavelength = input("Select the desired laser wavelength.", "Capacitor Laser Wavelength", selected_wavelength) as null|anything in global.laser_wavelengths
		if(!charging && new_wavelength != selected_wavelength && (loc == user || user.Adjacent(src)) && !user.incapacitated())
			selected_wavelength = new_wavelength
			to_chat(user, SPAN_NOTICE("You dial \the [src] wavelength to [selected_wavelength.name]."))
			update_icon()
	return TRUE

/obj/item/gun/energy/capacitor/Process()
	. = ..()

/obj/item/gun/energy/capacitor/proc/charge(var/mob/user)
	. = FALSE
	if(!charging && istype(user))
		charging = selected_wavelength
		playsound(loc, 'sound/effects/capacitor_whine.ogg', 100, 0)
		while(!QDELETED(user) && length(capacitors) && charging && user.get_active_hand() == src)
			var/charged = TRUE
			for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
				if(capacitor.charge < capacitor.max_charge)
					charged = FALSE
					var/use_charge_cost = min(charge_cost * capacitor.rating, round((capacitor.max_charge - capacitor.charge) / capacitor_charge_constant))
					if(power_supply.use(use_charge_cost))
						capacitor.charge(use_charge_cost * capacitor_charge_constant)
						update_icon()
					else
						charging = FALSE
					break
			if(charged)
				. = TRUE
				break
			sleep(5)
		charging = FALSE

/obj/item/gun/energy/capacitor/get_shots_remaining()
	var/total_charge_cost = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
		total_charge_cost += capacitor.max_charge
	. = round(power_supply?.charge / (total_charge_cost / capacitor_charge_constant))

/obj/item/gun/energy/capacitor/on_update_icon()
	cut_overlays()
	var/image/I = image(icon, "[icon_state]-wiring")
	I.color = wiring_color
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)
	if(power_supply)
		I = image(icon, "[icon_state]-cell")
		add_overlay(I)

	for(var/i = 1 to length(capacitors))
		var/obj/item/stock_parts/capacitor/capacitor = capacitors[i]
		I = image(icon, "[icon_state]-capacitor-[i]")
		add_overlay(I)
		if(capacitor.charge > 0)
			if(icon_state == "world")
				I = emissive_overlay(icon, "[icon_state]-charging-[i]")
			else
				I = image(icon, "[icon_state]-charging-[i]")
			I.alpha = Clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
			I.color = selected_wavelength.color
			I.appearance_flags |= RESET_COLOR
			add_overlay(I)
			if(icon_state == "world")
				I = emissive_overlay(icon, "[icon_state]-charging-glow-[i]")
			else
				I = image(icon, "[icon_state]-charging-glow-[i]")
			I.appearance_flags |= RESET_COLOR
			add_overlay(I)

	// So much of this item is overlay based that it looks weird when
	// being picked up and having all the detail snap in a tick later.
	compile_overlays()

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/gun/energy/capacitor/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(ret && (slot == BP_L_HAND || slot == BP_R_HAND || slot == slot_back_str))
		var/image/I = image(icon, "[ret.icon_state]-wiring")
		I.color = wiring_color
		I.appearance_flags |= RESET_COLOR
		ret.add_overlay(I)
		if(power_supply)
			I = image(icon, "[ret.icon_state]-cell")
			ret.add_overlay(I)
		if(slot != slot_back_str)
			for(var/i = 1 to length(capacitors))
				var/obj/item/stock_parts/capacitor/capacitor = capacitors[i]
				if(capacitor.charge > 0)
					I = emissive_overlay(icon, "[ret.icon_state]-charging-[i]")
					I.alpha = Clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
					I.color = selected_wavelength.color
					I.appearance_flags |= RESET_COLOR
					ret.add_overlay(I)
	return ret

/obj/item/gun/energy/capacitor/consume_next_projectile()

	var/charged = charge(loc)
	var/total_charge = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
		total_charge += capacitor.charge
		capacitor.charge = 0
	update_icon()

	if(charged)
		var/obj/item/projectile/P = new projectile_type(src)
		P.color = selected_wavelength.color
		P.set_light(l_color = selected_wavelength.light_color)
		P.damage = FLOOR(sqrt(total_charge) * selected_wavelength.damage_multiplier)
		P.armor_penetration = FLOOR(sqrt(total_charge) * selected_wavelength.armour_multiplier)
		. = P

// Subtypes.
/obj/item/gun/energy/capacitor/rifle
	name = "capacitor rifle"
	desc = "A heavy, unwieldly directed energy weapon that uses a linear capacitor array to charge a powerful beam."
	max_capacitors = 4
	icon = 'icons/obj/guns/capacitor_rifle.dmi'
	slot_flags = SLOT_BACK
	one_hand_penalty = 6
	fire_delay = 20
	w_class = ITEM_SIZE_HUGE
	cell_type = /obj/item/cell/super

/obj/item/gun/energy/capacitor/rifle/linear_fusion
	name = "linear fusion rifle"
	desc = "A chunky, angular, carbon-fiber-finish capacitor rifle, shipped complete with a self-charging power cell. The operating instructions seem to be written in backwards Cyrillic."
	color = COLOR_GRAY40
	cell_type = /obj/item/cell/infinite
	capacitors = /obj/item/stock_parts/capacitor/super
	projectile_type = /obj/item/projectile/beam/variable/split
	wiring_color = COLOR_GOLD

/obj/item/gun/energy/capacitor/rifle/linear_fusion/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		to_chat(user, SPAN_WARNING("\The [src] is hermetically sealed; you can't get the components out."))
		return TRUE
	. = ..()
