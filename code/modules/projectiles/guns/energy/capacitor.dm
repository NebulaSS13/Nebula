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
	damage_multiplier = 1.3
	armour_multiplier = 0.1

/decl/laser_wavelength/yellow
	name = "589nm"
	color = COLOR_GOLD
	light_color = COLOR_GOLD
	damage_multiplier = 1.2
	armour_multiplier = 0.2

/decl/laser_wavelength/green
	name = "515nm"
	color = COLOR_LIME
	light_color = COLOR_LIME
	damage_multiplier = 1.1
	armour_multiplier = 0.3

/decl/laser_wavelength/blue
	name = "473nm"
	color = COLOR_CYAN
	light_color = COLOR_BLUE_LIGHT
	damage_multiplier = 1
	armour_multiplier = 0.4

/decl/laser_wavelength/violet
	name = "405nm"
	color = "#ff00dc"
	light_color = "#ff00dc"
	damage_multiplier = 0.9
	armour_multiplier = 0.5

//This is a cool gun we should use it more there was literally 0 chance to find it ingame

/obj/item/gun/energy/capacitor
	name = "capacitor pistol"
	desc = "An excitingly chunky directed energy weapon that uses a modular capacitor array to charge each shot."
	icon = 'icons/obj/guns/capacitor_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	z_flags = ZMM_MANGLE_PLANES
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY

	fire_delay = 10

	origin_tech = "{'combat':2,'magnets':2,'materials':1,'powerstorage':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass        = MATTER_AMOUNT_REINFORCEMENT
	)

	accepts_cell_type = /obj/item/cell
	power_supply = /obj/item/cell/high
	projectile_type = /obj/item/projectile/beam/variable

	var/wiring_color = COLOR_CYAN_BLUE
	var/max_capacitors = 2
	var/list/capacitors = /obj/item/stock_parts/capacitor
	var/const/charge_iteration_delay = 5 //delay between charge cycles
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
		var/list/all_wavelengths = decls_repository.get_decls_of_subtype(/decl/laser_wavelength)
		for(var/laser in all_wavelengths)
			laser_wavelengths += all_wavelengths[laser]
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

	if(IS_SCREWDRIVER(W))
		if(length(capacitors))
			var/obj/item/stock_parts/capacitor/capacitor = capacitors[1]
			capacitor.charge = 0
			user.put_in_hands(capacitor)
			LAZYREMOVE(capacitors, capacitor)
		else
			to_chat(user, SPAN_WARNING("\The [src] does not have any capacitors installed."))
			return TRUE
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25)
		update_icon()
		return TRUE

	if(istype(W, /obj/item/stock_parts/capacitor))
		if(length(capacitors) >= max_capacitors)
			to_chat(user, SPAN_WARNING("\The [src] cannot fit any additional capacitors."))
		else if(user.try_unequip(W, src))
			LAZYADD(capacitors, W)
			to_chat(user, SPAN_NOTICE("You fit \the [W] into \the [src]."))
			update_icon()
		return TRUE

	. = ..()

//Wavelength setting moved to altclick

/obj/item/gun/energy/capacitor/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/capacitor_change_wavelength)

/decl/interaction_handler/capacitor_change_wavelength
	name = "Change Wavelength"
	expected_target_type = /obj/item/gun/energy/capacitor

/decl/interaction_handler/capacitor_change_wavelength/invoked(var/atom/target, var/mob/user)
	var/obj/item/gun/energy/capacitor/R = target
	if(R.charging)
		R.update_icon()
		R.charging = FALSE
	else
		var/new_wavelength = input("Select the desired laser wavelength.", "Capacitor Laser Wavelength", R.selected_wavelength) as null|anything in global.laser_wavelengths
		if(!R.charging && new_wavelength != R.selected_wavelength && (R.loc == user || user.Adjacent(R)) && !user.incapacitated())
			if(!new_wavelength)
				return TRUE
			R.selected_wavelength = new_wavelength
			to_chat(user, SPAN_NOTICE("You dial \the [R] wavelength to [R.selected_wavelength.name]."))
			R.update_icon()
	return TRUE

/obj/item/gun/energy/capacitor/Process()
	. = ..()

/obj/item/gun/energy/capacitor/attack_self(var/mob/user)
	if(!power_supply)
		to_chat(user,SPAN_WARNING("\The [src] has no power cell installed, you can't charge it!"))
		return
	if(charging)
		to_chat(user,SPAN_WARNING("\The [src] is already charging!"))
		return
	charge(user)

/obj/item/gun/energy/capacitor/proc/charge(var/mob/user)
	. = FALSE
	if(!charging && istype(user))
		charging = TRUE
		playsound(loc, 'sound/effects/capacitor_whine.ogg', 100, 0)
		while(!QDELETED(user) && length(capacitors) && charging && user.get_active_hand() == src)
			var/charged = TRUE
			for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
				if(capacitor.charge < capacitor.max_charge)
					charged = FALSE
					var/use_charge_cost = round((capacitor.max_charge - capacitor.charge) / capacitor_charge_constant)
					var/charge = power_supply?.use(use_charge_cost)
					if(charge)
						capacitor.charge(charge * capacitor_charge_constant)
						update_icon()
					else
						charging = FALSE
					break
			if(charged)
				. = TRUE
				break
			sleep(charge_iteration_delay)
		charging = FALSE

/obj/item/gun/energy/capacitor/get_shots_remaining()
	var/total_charge_cost = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
		total_charge_cost += capacitor.max_charge
	. = round(power_supply?.charge / (total_charge_cost / capacitor_charge_constant))

/obj/item/gun/energy/capacitor/on_update_icon()
	. = ..()
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
			I.alpha = clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
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

/obj/item/gun/energy/capacitor/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && (slot == BP_L_HAND || slot == BP_R_HAND || slot == slot_back_str))
		var/image/I = image(overlay.icon, "[overlay.icon_state]-wiring")
		I.color = wiring_color
		I.appearance_flags |= RESET_COLOR
		overlay.add_overlay(I)
		if(power_supply)
			I = image(overlay.icon, "[overlay.icon_state]-cell")
			overlay.add_overlay(I)
		if(slot != slot_back_str)
			for(var/i = 1 to length(capacitors))
				var/obj/item/stock_parts/capacitor/capacitor = capacitors[i]
				if(capacitor.charge > 0)
					I = emissive_overlay(overlay.icon, "[overlay.icon_state]-charging-[i]")
					I.alpha = clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
					I.color = selected_wavelength.color
					I.appearance_flags |= RESET_COLOR
					overlay.add_overlay(I)
	. = ..()

/obj/item/gun/energy/capacitor/consume_next_projectile()

	var/total_charge = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
		total_charge += capacitor.charge
		capacitor.charge = 0
	update_icon()

	if(!total_charge)
		return null

	var/obj/item/projectile/P = new projectile_type(src)
	P.color = selected_wavelength.color
	P.set_light(l_color = selected_wavelength.light_color)
	P.damage = round(FLOOR(sqrt(total_charge) * selected_wavelength.damage_multiplier),5)
	P.armor_penetration = round(FLOOR(sqrt(total_charge) * selected_wavelength.armour_multiplier),5)
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
	power_supply = /obj/item/cell/super
	projectile_type = /obj/item/projectile/beam/variable/heavy

/obj/item/gun/energy/capacitor/rifle/linear_fusion
	name = "linear fusion rifle"
	desc = "A chunky, angular, carbon-fiber-finish capacitor rifle, shipped complete with a self-charging power cell. The operating instructions seem to be written in backwards Cyrillic."
	color = COLOR_GRAY40
	accepts_cell_type = null
	power_supply = /obj/item/cell/infinite
	capacitors = /obj/item/stock_parts/capacitor/super
	projectile_type = /obj/item/projectile/beam/variable/split
	wiring_color = COLOR_GOLD