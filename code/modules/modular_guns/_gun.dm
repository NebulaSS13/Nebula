#define FIREARM_CATEGORY_NONE      "default"
#define FIREARM_COMPONENT_BARREL   "barrel"
#define FIREARM_COMPONENT_GRIP     "grip"
#define FIREARM_COMPONENT_STOCK    "stock"
#define FIREARM_COMPONENT_RECEIVER "receiver"
#define FIREARM_COMPONENT_FRAME    "frame"

/obj/item/gun

	var/bulk = 0 // How unwieldy this weapon for its size, affects accuracy when fired without aiming.
	var/one_hand_penalty = 0

	var/obj/item/firearm_component/receiver/receiver
	var/obj/item/firearm_component/barrel/barrel
	var/obj/item/firearm_component/stock/stock
	var/obj/item/firearm_component/grip/grip

/obj/item/gun/proc/check_projectile_size_against_barrel(var/obj/item/projectile/projectile)
	return barrel.get_relative_projectile_size(projectile)

/obj/item/gun/proc/update_from_components()

	one_hand_penalty = initial(one_hand_penalty)
	edge =             initial(edge)
	sharp =            initial(sharp)
	force =            initial(force)
	w_class =          initial(w_class)
	bulk =             initial(bulk)

	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp))
			one_hand_penalty = max(one_hand_penalty, comp.one_hand_penalty)
			force =            max(force,   comp.force)
			edge =             max(edge,    comp.edge)
			sharp =            max(sharp,   comp.sharp)
			w_class =          max(w_class, comp.w_class)
			bulk =             max(bulk,    comp.bulk)

	update_icon()

/obj/item/gun/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/list/firearm_components = get_modular_component_list()
		for(var/fcomp in firearm_components)
			var/obj/item/firearm_component/comp = firearm_components[fcomp]
			if(istype(comp))
				comp.show_examine_info(user)

/obj/item/gun/Initialize()
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/fcomppath = firearm_components[fcomp]
		if(fcomppath)
			new fcomppath(src)
	. = ..()
	update_from_components()

/obj/item/gun/attack_self(mob/user)
	var/list/firearm_components = get_modular_component_list()
	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp) && comp.holder_attack_self(user))
			return TRUE
	. = ..()

/*
/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/attack_self(mob/user)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(prob(20) && !user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		new_mode = switch_firemodes(user)
	if(new_mode)
		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")

/obj/item/gun/projectile/attack_self(mob/user)
	if(firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/gun/launcher/sealant/attack_self(mob/user)
	if(loaded_tank)
		unload_tank(user)
		return TRUE
	. = ..()
	
/obj/item/gun/launcher/crossbow/attack_self(mob/living/user)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.dropInto(loc)
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/alien/slugsling/attack_self(var/mob/living/user)
	mode = mode == "Impact" ? "Sentry" : "Impact"
	to_chat(user,"<span class='notice'>You switch \the [src]'s mode to \"[mode]\"</span>")

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attack_self(mob/living/user)
	if(tension)
		user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		generate_bolt(user)
		draw(user)

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


/obj/item/gun/projectile/dartgun/attack_self(mob/user)
	Interact(user)

/obj/item/gun/projectile/bolt_action/attack_self(mob/user)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			unload_shell()
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		bolt_open = FALSE
	add_fingerprint(user)
	update_icon()

/obj/item/gun/launcher/grenade/underslung/attack_self()
	return

/obj/item/gun/energy/temperature/attack_self(mob/living/user)
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


/obj/item/gun/launcher/syringe/attack_self(mob/living/user)
	if(next)
		user.visible_message("[user] unlatches and carefully relaxes the bolt on [src].", "<span class='warning'>You unlatch and carefully relax the bolt on [src], unloading the spring.</span>")
		next = null
	else if(darts.len)
		playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		user.visible_message("[user] draws back the bolt on [src], clicking it into place.", "<span class='warning'>You draw back the bolt on the [src], loading the spring!</span>")
		next = darts[1]
	add_fingerprint(user)


/obj/item/gun/launcher/pneumatic/attack_self(mob/user)
	eject_tank(user)


/obj/item/gun/launcher/money/attack_self(mob/user)
	var/decl/currency/cur = decls_repository.get_decl(GLOB.using_map.default_currency)
	var/disp_amount = min(input(user, "How many [cur.name_singular] do you want to dispense at a time? (0 to [src.receptacle_value])", "Money Cannon Settings", 20) as num, receptacle_value)
	if (disp_amount < 1)
		to_chat(user, "<span class='warning'>You have to dispense at least one [cur.name_singular] at a time!</span>")
		return
	src.dispensing = disp_amount
	to_chat(user, "<span class='notice'>You set [src] to dispense [dispensing] [cur.name_singular] at a time.</span>")


/obj/item/gun/launcher/grenade/attack_self(mob/user)
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
/obj/item/gun/projectile/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload(user)
	else
		..()

/obj/item/gun/launcher/money/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload_receptacle(user)
	else
		return ..()

/obj/item/gun/launcher/pneumatic/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		unload_hopper(user)
	else
		return ..()

/obj/item/gun/launcher/syringe/attack_hand(mob/living/user)
	if(user.is_holding_offhand(src))
		if(!darts.len)
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
			return
		if(next)
			to_chat(user, "<span class='warning'>[src]'s cover is locked shut.</span>")
			return
		var/obj/item/syringe_cartridge/C = darts[1]
		darts -= C
		user.put_in_hands(C)
		user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
	else
		..()

/obj/item/gun/magnetic/attack_hand(var/mob/user)
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
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [src].</span>")
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/projectile/automatic/assault_rifle/attack_hand(mob/user)
	if(user.is_holding_offhand(src) && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(silenced && user.is_holding_offhand(src))
		to_chat(user, SPAN_NOTICE("You unscrew \the [silenced] from \the [src]."))
		user.put_in_hands(silenced)
		silenced = initial(silenced)
		w_class = initial(w_class)
		update_icon()
		return
	..()

/obj/item/gun/launcher/sealant/attack_hand(mob/user)
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
/obj/item/gun/projectile/attackby(var/obj/item/A, mob/user)
	if(!load_ammo(A, user))
		return ..()

/obj/item/gun/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) && is_secure_gun())
		user.visible_message("[user] swipes an ID through \the [src].", range = 3)
		if(!registered_owner)
			var/obj/item/card/id/id = W
			GLOB.registered_weapons += src
			verbs += /obj/item/gun/proc/reset_registration
			registered_owner = id.registered_name
			to_chat(user, SPAN_NOTICE("\The [src] chimes quietly as it registers to \"[registered_owner]\"."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] buzzes quietly, refusing to register without first being reset."))
	else
		..()


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


/obj/item/gun/energy/capacitor/rifle/linear_fusion/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		to_chat(user, SPAN_WARNING("\The [src] is hermetically sealed; you can't get the components out."))
		return TRUE
	. = ..()

	

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		if((stored_matter + cartridge.remaining) > max_stored_matter)
			to_chat(user, "<span class='notice'>The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += cartridge.remaining
		qdel(W)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()

	if(istype(W, /obj/item/arrow/rapidcrossbowdevice))
		var/obj/item/arrow/rapidcrossbowdevice/A = W
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, "<span class='notice'>Unable to reclaim flashforged bolt. The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += 10
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>Flashforged bolt reclaimed. The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()


/obj/item/gun/energy/floragun/resolve_attackby(atom/A)
	if(istype(A,/obj/machinery/portable_atmospherics/hydroponics))
		return FALSE // do afterattack, i.e. fire, at pointblank at trays.
	return ..()

/obj/item/gun/launcher/crossbow/attackby(obj/item/W, mob/user)
	
	if(istype(W, /obj/item/rcd))
		var/obj/item/rcd/rcd = W
		if(rcd.crafting && user.unEquip(rcd) && user.unEquip(src))
			new /obj/item/gun/launcher/crossbow/rapidcrossbowdevice(get_turf(src))
			qdel(rcd)
			qdel_self()
		else
			to_chat(user, SPAN_WARNING("\The [rcd] is not prepared for installation in \the [src]."))
		return

	if(!bolt)
		if (istype(W,/obj/item/arrow) && user.unEquip(W, src))
			bolt = W
			user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.dropInto(loc)
				update_icon()
				user.visible_message("[user] jams [bolt] into [src].","You jam [bolt] into [src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			if(!user.unEquip(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>You jam [cell] into [src] and wire it to the firing coil.</span>")
			superheat_rod(user)
		else
			to_chat(user, "<span class='notice'>[src] already has a cell installed.</span>")

	else if(isScrewdriver(W))
		if(cell)
			var/obj/item/C = cell
			C.dropInto(user.loc)
			to_chat(user, "<span class='notice'>You jimmy [cell] out of [src] with [W].</span>")
			cell = null
		else
			to_chat(user, "<span class='notice'>[src] doesn't have a cell installed.</span>")

	else
		..()


/obj/item/gun/launcher/foam/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/foam_dart))
		if(darts.len < max_darts)
			if(!user.unEquip(I, src))
				return
			darts += I
			to_chat(user, SPAN_NOTICE("You slot \the [I] into \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] can hold no more darts."))


/obj/item/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()


/obj/item/gun/launcher/money/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cash/))
		var/obj/item/cash/bling = W
		if(bling.absolute_worth < 1)
			to_chat(user, "<span class='warning'>You can't seem to get \the [bling] to slide into the receptacle.</span>")
			return

		var/decl/currency/cur = decls_repository.get_decl(bling.currency)
		if(bling.currency != GLOB.using_map.default_currency)
			to_chat(user, SPAN_WARNING("Due to local legislation and budget cuts, \the [src] will only accept [cur.name]."))
			return

		receptacle_value += bling.absolute_worth
		to_chat(user, "<span class='notice'>You slide [bling.get_worth()] [cur.name_singular] into [src]'s receptacle.</span>")
		qdel(bling)

	else
		to_chat(user, "<span class='warning'>That's not going to fit in there.</span>")


/obj/item/gun/launcher/pneumatic/attackby(obj/item/W, mob/user)
	if(!tank && istype(W,/obj/item/tank) && user.unEquip(W, src))
		tank = W
		user.visible_message("[user] jams [W] into [src]'s valve and twists it closed.","You jam [W] into [src]'s valve and twist it closed.")
		update_icon()
	else if(istype(W) && item_storage.can_be_inserted(W, user))
		item_storage.handle_item_insertion(W)


/obj/item/gun/launcher/rocket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/ammo_casing/rocket))
		if(rockets.len < max_rockets)
			if(!user.unEquip(I, src))
				return
			rockets += I
			to_chat(user, "<span class='notice'>You put the rocket in [src].</span>")
			to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")
		else
			to_chat(usr, "<span class='warning'>\The [src] cannot hold more rockets.</span>")


/obj/item/gun/launcher/syringe/attackby(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/syringe_cartridge))
		var/obj/item/syringe_cartridge/C = A
		if(darts.len >= max_darts)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		if(!user.unEquip(C, src))
			return
		darts += C //add to the end
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
	else
		..()


/obj/item/gun/magnetic/attackby(var/obj/item/thing, var/mob/user)

	if(removable_components)
		if(istype(thing, /obj/item/cell))
			if(cell)
				to_chat(user, "<span class='warning'>\The [src] already has \a [cell] installed.</span>")
				return
			if(!user.unEquip(thing, src))
				return
			cell = thing
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [src].</span>")
			update_icon()
			return

		if(isScrewdriver(thing))
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
			if(!user.unEquip(thing, src))
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
			var/obj/item/magnetic_ammo/mag = thing
			if(istype(mag))
				if(!(load_type == mag.basetype))
					to_chat(user, "<span class='warning'>\The [src] doesn't seem to accept \a [mag].</span>")
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

/obj/item/gun/projectile/automatic/assault_rifle/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/gun/projectile/dartgun/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/glass))
		add_beaker(I, user)
		return 1
	..()

/obj/item/gun/projectile/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(src in user.get_held_items())	//if we're not in his hands
			to_chat(user, SPAN_WARNING("You'll need [src] in your hands to do that."))
			return TRUE
		if(user.unEquip(I, src))
			to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
			silenced = I	//dodgy?
			w_class = ITEM_SIZE_NORMAL
			update_icon()
		return TRUE
	. = ..()

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/wirecutters/W, mob/user)
	if(!istype(W) || !cap)
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	name = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	cap = FALSE
	update_icon()
	return 1




/obj/item/gun/launcher/sealant/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/sealant_tank) && user.unEquip(W, src))
		loaded_tank = W
		to_chat(user, SPAN_NOTICE("You slot \the [loaded_tank] into \the [src]."))
		update_icon()
		return TRUE
	. = ..()
*/


/obj/item/gun/on_update_icon()
	force_icon_debug()

/obj/item/gun/proc/force_icon_debug()
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
