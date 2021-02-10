#define FIREARM_CATEGORY_NONE      "default"
#define FIREARM_COMPONENT_BARREL   "barrel"
#define FIREARM_COMPONENT_GRIP     "grip"
#define FIREARM_COMPONENT_STOCK    "stock"
#define FIREARM_COMPONENT_RECEIVER "receiver"
#define FIREARM_COMPONENT_FRAME    "frame"

/obj/item/gun
	name = "gun"
	desc = "A gun that fires projectiles."
	icon_state = ICON_STATE_WORLD
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	material = /decl/material/solid/metal/steel
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	var/firearm_frame_subtype

	var/total_firearm_bulk =             0 // How unwieldy this weapon for its size, affects accuracy when fired without aiming.
	var/total_firearm_one_hand_penalty = 0
	var/total_firearm_screen_shake =     0 // shouldn't be greater than 2 unless zoomed
	var/total_firearm_space_recoil =     0 // knocks back in space
	var/total_firearm_combustion =       0

	var/obj/item/firearm_component/receiver/receiver
	var/obj/item/firearm_component/barrel/barrel
	var/obj/item/firearm_component/stock/stock
	var/obj/item/firearm_component/grip/grip

/obj/item/gun/Initialize()

	if(!ispath(firearm_frame_subtype, /obj/item/gun))
		crash_with("Firearm initialized with invalid frame subtype: [type] (name).")
		return INITIALIZE_HINT_QDEL

	if(type == firearm_frame_subtype)
		crash_with("Firearm initialized with same type as frame subtype: [type] (name).")
		return INITIALIZE_HINT_QDEL

	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/fcomppath = firearm_components[fcomp]
		if(fcomppath)
			new fcomppath(src)
	. = ..()
	update_from_components()

/obj/item/gun/proc/is_secure_gun()
	return length(req_access)

/obj/item/gun/proc/check_projectile_size_against_barrel(var/obj/item/projectile/projectile)
	return barrel.get_relative_projectile_size(projectile)

/obj/item/gun/proc/update_from_components()

	total_firearm_one_hand_penalty = initial(total_firearm_one_hand_penalty)
	total_firearm_bulk =             initial(total_firearm_bulk)

	edge =    initial(edge)
	sharp =   initial(sharp)
	force =   initial(force)
	w_class = initial(w_class)

	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp))
			total_firearm_one_hand_penalty = max(total_firearm_one_hand_penalty, comp.one_hand_penalty)
			total_firearm_bulk =             max(total_firearm_bulk, comp.bulk)
			force =            max(force,   comp.force)
			edge =             max(edge,    comp.edge)
			sharp =            max(sharp,   comp.sharp)
			w_class =          max(w_class, comp.w_class)

	total_firearm_screen_shake = max(max(initial(total_firearm_screen_shake), receiver?.screen_shake), barrel?.screen_shake)
	total_firearm_space_recoil = max(max(initial(total_firearm_space_recoil), receiver?.space_recoil), barrel?.space_recoil)
	total_firearm_combustion =   max(max(initial(total_firearm_combustion),   receiver?.combustion),   barrel?.combustion)

	update_icon()

/obj/item/gun/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(. == NO_EMAG_ACT)
		var/list/firearm_components = get_modular_component_list()
		for(var/fcomp in firearm_components)
			var/obj/item/firearm_component/comp = firearm_components[fcomp]
			if(istype(comp))
				. = comp.holder_emag_act(remaining_charges, user)
				if(. != NO_EMAG_ACT)
					break

/obj/item/gun/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/list/firearm_components = get_modular_component_list()
		for(var/fcomp in firearm_components)
			var/obj/item/firearm_component/comp = firearm_components[fcomp]
			if(istype(comp))
				comp.show_examine_info(user)

/obj/item/gun/attack_self(mob/user)
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp) && comp.holder_attack_self(user))
			return TRUE
	. = ..()

/*
/obj/item/gun/cannon/sealant/attack_self(mob/user)
	if(loaded_tank)
		unload_tank(user)
		return TRUE
	. = ..()
	
/obj/item/gun/long/crossbow/attack_self(mob/living/user)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [holder || src]'s string and removes [bolt].","You relax the tension on [holder || src]'s string and remove [bolt].")
			bolt.dropInto(get_turf(holder))
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [holder || src]'s string.","You relax the tension on [holder || src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/alien/slugsling/attack_self(var/mob/living/user)
	mode = mode == "Impact" ? "Sentry" : "Impact"
	to_chat(user,"<span class='notice'>You switch \the [holder || src]'s mode to \"[mode]\"</span>")

/obj/item/gun/long/crossbow/rapidcrossbowdevice/attack_self(mob/living/user)
	if(tension)
		user.visible_message("[user] relaxes the tension on [holder || src]'s string.","You relax the tension on [holder || src]'s string.")
		tension = 0
		update_icon()
	else
		generate_bolt(user)
		draw(user)

/obj/item/gun/hand/capacitor_pistol/attack_self(var/mob/user)

	if(charging)
		for(var/obj/item/stock_parts/capacitor/capacitor in capacitors)
			capacitor.charge = 0
		update_icon()
		charging = FALSE
	else
		var/new_wavelength = input("Select the desired laser wavelength.", "Capacitor Laser Wavelength", selected_wavelength) as null|anything in global.laser_wavelengths
		if(!charging && new_wavelength != selected_wavelength && (holder?.loc == user || user.Adjacent(src)) && !user.incapacitated())
			selected_wavelength = new_wavelength
			to_chat(user, SPAN_NOTICE("You dial \the [holder || src]'s wavelength to [selected_wavelength.name]."))
			update_icon()
	return TRUE

/obj/item/gun/long/grenade/underslung/attack_self()
	return

/obj/item/gun/long/temperature/attack_self(mob/living/user)
	user.set_machine(src)
	var/temp_text = ""
	if(firing_temperature > (T0C - 50))
		temp_text = "<FONT color=black>[firing_temperature] ([round(firing_temperature-T0C)]&deg;C) ([round(firing_temperature*1.8-459.67)]&deg;F)</FONT>"
	else
		temp_text = "<FONT color=blue>[firing_temperature] ([round(firing_temperature-T0C)]&deg;C) ([round(firing_temperature*1.8-459.67)]&deg;F)</FONT>"

	var/dat = {"<B>Freeze Gun Configuration: </B><BR>
	Current output temperature: [temp_text]<BR>
	Target output temperature: <A href='?src=\ref[src];temp=-100'>-</A> <A href='?src=\ref[src];temp=-10'>-</A> <A href='?src=\ref[src];temp=-1'>-</A> [current_temperature] <A href='?src=\ref[src];temp=1'>+</A> <A href='?src=\ref[src];temp=10'>+</A> <A href='?src=\ref[src];temp=100'>+</A><BR>
	"}

	show_browser(user, dat, "window=freezegun;size=450x300;can_resize=1;can_close=1;can_minimize=1")
	onclose(user, "window=freezegun", src)


/obj/item/gun/long/syringe/attack_self(mob/living/user)
	if(next)
		user.visible_message("[user] unlatches and carefully relaxes the bolt on \the [holder || src].", "<span class='warning'>You unlatch and carefully relax the bolt on \the [holder || src], unloading the spring.</span>")
		next = null
	else if(darts.len)
		playsound(holder, 'sound/weapons/flipblade.ogg', 50, 1)
		user.visible_message("[user] draws back the bolt on \the [holder || src], clicking it into place.", "<span class='warning'>You draw back the bolt on the \the [holder || src], loading the spring!</span>")
		next = darts[1]
	add_fingerprint(user)


/obj/item/gun/long/pneumatic/attack_self(mob/user)
	eject_tank(user)


/obj/item/gun/hand/money/attack_self(mob/user)
	var/decl/currency/cur = decls_repository.get_decl(GLOB.using_map.default_currency)
	var/disp_amount = min(input(user, "How many [cur.name_singular] do you want to dispense at a time? (0 to [src.receptacle_value])", "Money Cannon Settings", 20) as num, receptacle_value)
	if (disp_amount < 1)
		to_chat(user, "<span class='warning'>You have to dispense at least one [cur.name_singular] at a time!</span>")
		return
	src.dispensing = disp_amount
	to_chat(user, "<span class='notice'>You set [holder || src] to dispense [dispensing] [cur.name_singular] at a time.</span>")


/obj/item/gun/long/grenade/attack_self(mob/user)
	pump(user)

*/

/obj/item/gun/attack_hand(mob/user)
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp) && comp.holder_attack_hand(user))
			return TRUE
	. = ..()
	
/*


/obj/item/gun/long/grenade/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload(user)
	else
		..()

/obj/item/gun/hand/money/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload_receptacle(user)
	else
		return ..()

/obj/item/gun/long/pneumatic/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload_hopper(user)
	else
		return ..()

/obj/item/gun/long/syringe/attack_hand(mob/living/user)
	if(user.is_holding_offhand(src))
		if(!darts.len)
			to_chat(user, "<span class='warning'>[holder || src] is empty.</span>")
			return
		if(next)
			to_chat(user, "<span class='warning'>[holder || src]'s cover is locked shut.</span>")
			return
		var/obj/item/syringe_cartridge/C = darts[1]
		darts -= C
		user.put_in_hands(C)
		user.visible_message("[user] removes \a [C] from [holder || src].", "<span class='notice'>You remove \a [C] from [holder || src].</span>")
	else
		..()

/obj/item/gun/attack_hand(var/mob/user)
	if(user.is_holding_offhand(src))
		var/obj/item/removing

		if(loaded)
			removing = loaded
			loaded = null
		else if(cell && removable_components)
			removing = cell
			cell = null

		if(removing)
			user.put_in_hands(removing)
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [holder || src].</span>")
			playsound(holder, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/long/assault_rifle/attack_hand(mob/user)
	if(user.is_holding_offhand(src) && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/cannon/sealant/attack_hand(mob/user)
	if((src in user.get_held_items()) && loaded_tank)
		unload_tank(user)
		return TRUE
	. = ..()
*/

/obj/item/gun/attackby(obj/item/W, mob/user)
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp) && comp.holder_attackby(W, user))
			return TRUE
	. = ..()

/*
	else
		..()


/obj/item/gun/hand/capacitor_pistol/attackby(obj/item/W, mob/user)

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
			to_chat(user, SPAN_WARNING("\The [holder || src] does not have a cell or capacitor installed."))
			return TRUE
		playsound(holder, 'sound/items/Screwdriver2.ogg', 25)
		update_icon()
		return TRUE

	if(istype(W, /obj/item/cell))
		if(power_supply)
			to_chat(user, SPAN_WARNING("\The [holder || src] already has a cell installed."))
		else if(user.unEquip(W, src))
			power_supply = W
			to_chat(user, SPAN_NOTICE("You fit \the [W] into \the [holder || src]."))
			update_icon()
		return TRUE

	if(istype(W, /obj/item/stock_parts/capacitor))
		if(length(capacitors) >= max_capacitors)
			to_chat(user, SPAN_WARNING("\The [holder || src] cannot fit any additional capacitors."))
		else if(user.unEquip(W, src))
			LAZYADD(capacitors, W)
			to_chat(user, SPAN_NOTICE("You fit \the [W] into \the [holder || src]."))
			update_icon()
		return TRUE

	. = ..()


/obj/item/gun/long/linear_fusion/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		to_chat(user, SPAN_WARNING("\The [holder || src] is hermetically sealed; you can't get the components out."))
		return TRUE
	. = ..()

	

/obj/item/gun/long/crossbow/rapidcrossbowdevice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		if((stored_matter + cartridge.remaining) > max_stored_matter)
			to_chat(user, "<span class='notice'>The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += cartridge.remaining
		qdel(W)
		playsound(holder, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()

	if(istype(W, /obj/item/arrow/rapidcrossbowdevice))
		var/obj/item/arrow/rapidcrossbowdevice/A = W
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, "<span class='notice'>Unable to reclaim flashforged bolt. The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += 10
		qdel(A)
		playsound(holder, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>Flashforged bolt reclaimed. The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()


/obj/item/gun/hand/floragun/resolve_attackby(atom/A)
	if(istype(A,/obj/machinery/portable_atmospherics/hydroponics))
		return FALSE // do afterattack, i.e. fire, at pointblank at trays.
	return ..()

/obj/item/gun/long/crossbow/attackby(obj/item/W, mob/user)
	
	if(istype(W, /obj/item/rcd))
		var/obj/item/rcd/rcd = W
		if(rcd.crafting && user.unEquip(rcd) && user.unEquip(src))
			new /obj/item/gun/long/crossbow/rapidcrossbowdevice(get_turf(src))
			qdel(rcd)
			qdel_self()
		else
			to_chat(user, SPAN_WARNING("\The [rcd] is not prepared for installation in \the [holder || src]."))
		return

	if(!bolt)
		if (istype(W,/obj/item/arrow) && user.unEquip(W, src))
			bolt = W
			user.visible_message("[user] slides [bolt] into [holder || src].","You slide [bolt] into [holder || src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.dropInto(get_turf(holder))
				update_icon()
				user.visible_message("[user] jams [bolt] into [holder || src].","You jam [bolt] into [holder || src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			if(!user.unEquip(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>You jam [cell] into [holder || src] and wire it to the firing coil.</span>")
			superheat_rod(user)
		else
			to_chat(user, "<span class='notice'>[holder || src] already has a cell installed.</span>")

	else if(isScrewdriver(W))
		if(cell)
			var/obj/item/C = cell
			C.dropInto(get_turf(user))
			to_chat(user, "<span class='notice'>You jimmy [cell] out of [holder || src] with [W].</span>")
			cell = null
		else
			to_chat(user, "<span class='notice'>[holder || src] doesn't have a cell installed.</span>")

	else
		..()


/obj/item/gun/hand/foam/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/foam_dart))
		if(darts.len < max_darts)
			if(!user.unEquip(I, src))
				return
			darts += I
			to_chat(user, SPAN_NOTICE("You slot \the [I] into \the [holder || src]."))
		else
			to_chat(user, SPAN_WARNING("\The [holder || src] can hold no more darts."))


/obj/item/gun/long/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()


/obj/item/gun/hand/money/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cash/))
		var/obj/item/cash/bling = W
		if(bling.absolute_worth < 1)
			to_chat(user, "<span class='warning'>You can't seem to get \the [bling] to slide into the receptacle.</span>")
			return

		var/decl/currency/cur = decls_repository.get_decl(bling.currency)
		if(bling.currency != GLOB.using_map.default_currency)
			to_chat(user, SPAN_WARNING("Due to local legislation and budget cuts, \the [holder || src] will only accept [cur.name]."))
			return

		receptacle_value += bling.absolute_worth
		to_chat(user, "<span class='notice'>You slide [bling.get_worth()] [cur.name_singular] into [holder || src]'s receptacle.</span>")
		qdel(bling)

	else
		to_chat(user, "<span class='warning'>That's not going to fit in there.</span>")


/obj/item/gun/long/pneumatic/attackby(obj/item/W, mob/user)
	if(!tank && istype(W,/obj/item/tank) && user.unEquip(W, src))
		tank = W
		user.visible_message("[user] jams [W] into [holder || src]'s valve and twists it closed.","You jam [W] into [holder || src]'s valve and twist it closed.")
		update_icon()
	else if(istype(W) && item_storage.can_be_inserted(W, user))
		item_storage.handle_item_insertion(W)


/obj/item/gun/cannon/rocket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			if(!user.unEquip(I, src))
				return
			rockets += I
			to_chat(user, "<span class='notice'>You put the rocket in [holder || src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")
		else
			to_chat(usr, "<span class='warning'>\The [holder || src] cannot hold more rockets.</span>")


/obj/item/gun/long/syringe/attackby(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/syringe_cartridge))
		var/obj/item/syringe_cartridge/C = A
		if(darts.len >= max_darts)
			to_chat(user, "<span class='warning'>[holder || src] is full!</span>")
			return
		if(!user.unEquip(C, src))
			return
		darts += C //add to the end
		user.visible_message("[user] inserts \a [C] into [holder || src].", "<span class='notice'>You insert \a [C] into [holder || src].</span>")
	else
		..()


/obj/item/gun/attackby(var/obj/item/thing, var/mob/user)

	if(removable_components)
		if(istype(thing, /obj/item/cell))
			if(cell)
				to_chat(user, "<span class='warning'>\The [holder || src] already has \a [cell] installed.</span>")
				return
			if(!user.unEquip(thing, src))
				return
			cell = thing
			playsound(holder, 'sound/machines/click.ogg', 10, 1)
			user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [holder || src].</span>")
			update_icon()
			return

		if(isScrewdriver(thing))
			if(!capacitor)
				to_chat(user, "<span class='warning'>\The [holder || src] has no capacitor installed.</span>")
				return
			user.put_in_hands(capacitor)
			user.visible_message("<span class='notice'>\The [user] unscrews \the [capacitor] from \the [holder || src].</span>")
			playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)
			capacitor = null
			update_icon()
			return

		if(istype(thing, /obj/item/stock_parts/capacitor))
			if(capacitor)
				to_chat(user, "<span class='warning'>\The [holder || src] already has \a [capacitor] installed.</span>")
				return
			if(!user.unEquip(thing, src))
				return
			capacitor = thing
			playsound(holder, 'sound/machines/click.ogg', 10, 1)
			power_per_tick = (power_cost*0.15) * capacitor.rating
			user.visible_message("<span class='notice'>\The [user] slots \the [capacitor] into \the [holder || src].</span>")
			update_icon()
			return

	if(istype(thing, load_type))

		// This is not strictly necessary for the magnetic gun but something using
		// specific ammo types may exist down the track.
		var/obj/item/stack/ammo = thing
		if(!istype(ammo))
			if(loaded)
				to_chat(user, "<span class='warning'>\The [holder || src] already has \a [loaded] loaded.</span>")
				return
			var/obj/item/magnetic_ammo/mag = thing
			if(istype(mag))
				if(!(load_type == mag.basetype))
					to_chat(user, "<span class='warning'>\The [holder || src] doesn't seem to accept \a [mag].</span>")
					return
				projectile_type = mag.projectile_type
			if(!user.unEquip(thing, src))
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
				to_chat(user, "<span class='warning'>\The [holder || src] is already fully loaded.</span>")
				return
			ammo.use(ammo_count)
		else
			if(loaded)
				to_chat(user, "<span class='warning'>\The [holder || src] already has \a [loaded] loaded.</span>")
				return
			loaded = new load_type(src, 1)
			ammo.use(1)

		user.visible_message("<span class='notice'>\The [user] loads \the [holder || src] with \the [loaded].</span>")
		playsound(holder, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()

/obj/item/gun/cannon/sealant/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/sealant_tank) && user.unEquip(W, src))
		loaded_tank = W
		to_chat(user, SPAN_NOTICE("You slot \the [loaded_tank] into \the [holder || src]."))
		update_icon()
		return TRUE
	. = ..()
*/

/obj/item/gun/on_update_icon()
	cut_overlays()
	var/base_icon_state = get_world_inventory_state()
	icon_state = "[base_icon_state]-[FIREARM_COMPONENT_FRAME]"
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp))
			var/image/I = comp.get_holder_overlay(base_icon_state)
			if(I)
				add_overlay(I)
	var/mob/user = loc
	if(src in user.get_held_items())
		user.update_inv_hands()

/*
/obj/item/gun/on_update_icon()
	var/mob/living/M = loc
	overlays.Cut()
	update_base_icon()
	if(istype(M))
		if(M.skill_check(SKILL_WEAPONS,SKILL_BASIC))
			overlays += image('icons/obj/guns/gui.dmi',"safety[safety()]")
		if(src in M.get_held_items())
			M.update_inv_hands()
	if(receiver?.safety_icon)
		overlays +=	receiver.get_safety_indicator()
*/

/obj/item/gun/proc/get_modular_component_list()
	. = list(
		"[FIREARM_COMPONENT_BARREL]" =   barrel,
		"[FIREARM_COMPONENT_GRIP]" =     grip,
		"[FIREARM_COMPONENT_RECEIVER]" = receiver,
		"[FIREARM_COMPONENT_STOCK]" =    stock
	)

/obj/item/gun/proc/get_load_caliber()
	return receiver?.get_caliber()

/obj/item/gun/proc/get_fire_caliber()
	return barrel?.get_caliber()

/obj/item/gun/proc/set_caliber(var/caliber)
	. = (barrel?.set_caliber(caliber) && receiver?.set_caliber(caliber))

/obj/item/gun/proc/reset_registration()
	set name = "Reset Registration"
	set category = "Object"
	set src in usr

	var/obj/item/firearm_component/grip/secure/G = grip
	if(istype(G))
		to_chat(usr, SPAN_WARNING("\The [src] cannot be reset."))
		return
	if(issilicon(usr))
		to_chat(usr, SPAN_WARNING("You are not permitted to modify weapon registrations."))
		return
	usr.visible_message("\The [usr] presses the reset button on \the [src].", range = 3)
	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("\The [src] buzzes quietly, refusing your access."))
		return
	to_chat(usr, SPAN_NOTICE("\The [src] chimes quietly as its registration resets."))
	G.registered_owner = null
	GLOB.registered_weapons -= G
	verbs -= /obj/item/gun/proc/reset_registration

/obj/item/gun/verb/toggle_safety_verb()
	set src in usr
	set category = "Object"
	set name = "Toggle Gun Safety"
	if(usr == loc && receiver)
		receiver.toggle_safety(usr)

/obj/item/gun/proc/get_projectile_type()
	return barrel?.get_projectile_type() || receiver?.get_projectile_type()
