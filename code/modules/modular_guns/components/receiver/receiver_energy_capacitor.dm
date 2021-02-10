/obj/item/firearm_component/receiver/energy/capacitor
	cell_type = /obj/item/cell/high
	var/max_capacitors = 2
	var/wiring_color = COLOR_CYAN_BLUE
	var/list/capacitors = /obj/item/stock_parts/capacitor
	var/const/charge_iteration_delay = 3
	var/const/capacitor_charge_constant = 10
	var/decl/laser_wavelength/charging
	var/decl/laser_wavelength/selected_wavelength

/obj/item/firearm_component/receiver/energy/capacitor/rifle
	cell_type = /obj/item/cell/super
	max_capacitors = 4

/obj/item/firearm_component/receiver/energy/capacitor/rifle/lfr
	cell_type = /obj/item/cell/infinite
	capacitors = /obj/item/stock_parts/capacitor/super
	wiring_color = COLOR_GOLD

/*

/obj/item/gun/hand/capacitor_pistol/examine(mob/user, distance)
	. = ..()
	if(loc == user || distance <= 1)
		to_chat(user, "The wavelength selector is dialled to [selected_wavelength.name].")
	
/obj/item/gun/hand/capacitor_pistol/Destroy()
	if(capacitors)
		QDEL_NULL_LIST(capacitors)
	. = ..()

/obj/item/gun/hand/capacitor_pistol/Initialize()
	if(!laser_wavelengths)
		laser_wavelengths = list()
		for(var/laser in subtypesof(/decl/laser_wavelength))
			laser_wavelengths += decls_repository.get_decl(laser)
	selected_wavelength = pick(laser_wavelengths)
	if(ispath(capacitors))
		var/capacitor_type = capacitors
		capacitors = list()
		for(var/i = 1 to max_capacitors)
			capacitors += new capacitor_type(src)
	. = ..()

/obj/item/gun/hand/capacitor_pistol/afterattack(atom/A, mob/living/user, adjacent, params)
	. = !charging && ..()

/obj/item/gun/hand/capacitor_pistol/Process()
	. = ..()

/obj/item/gun/hand/capacitor_pistol/proc/charge(var/mob/user)
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

/obj/item/gun/hand/capacitor_pistol/get_shots_remaining()
	var/total_charge_cost = 0
	for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
		total_charge_cost += capacitor.max_charge
	. = round(power_supply?.charge / (total_charge_cost / capacitor_charge_constant))

/obj/item/gun/hand/capacitor_pistol/on_update_icon()
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
			I = image(icon, "[icon_state]-charging-[i]")
			I.alpha = Clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
			I.color = selected_wavelength.color
			if(icon_state == "world")
				I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
				I.layer = ABOVE_LIGHTING_LAYER
			I.appearance_flags |= RESET_COLOR
			add_overlay(I)
			I = image(icon, "[icon_state]-charging-glow-[i]")
			if(icon_state == "world")
				I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
				I.layer = ABOVE_LIGHTING_LAYER
			I.appearance_flags |= RESET_COLOR
			add_overlay(I)

	// So much of this item is overlay based that it looks weird when 
	// being picked up and having all the detail snap in a tick later.
	compile_overlays() 

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/gun/hand/capacitor_pistol/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(slot == BP_L_HAND || slot == BP_R_HAND || slot == slot_back_str)
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
					I = image(icon, "[ret.icon_state]-charging-[i]")
					I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
					I.layer = ABOVE_LIGHTING_LAYER
					I.alpha = Clamp(255 * (capacitor.charge/capacitor.max_charge), 0, 255)
					I.color = selected_wavelength.color
					I.appearance_flags |= RESET_COLOR
					ret.add_overlay(I)
	. = ret

/obj/item/gun/hand/capacitor_pistol/consume_next_projectile()

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
		P.damage = Floor(sqrt(total_charge) * selected_wavelength.damage_multiplier)
		P.armor_penetration = Floor(sqrt(total_charge) * selected_wavelength.armour_multiplier)
		. = P
*/