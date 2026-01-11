/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NAME

	var/can_install_glass = TRUE
	var/state = 0
	var/base_name = "airlock assembly"
	var/obj/item/stock_parts/circuitboard/airlock_electronics/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/created_name = null
	var/panel_icon = 'icons/obj/doors/station/panel.dmi'
	var/fill_icon = 'icons/obj/doors/station/fill_steel.dmi'
	var/glass_icon = 'icons/obj/doors/station/fill_glass.dmi'
	var/paintable = PAINT_PAINTABLE|PAINT_STRIPABLE
	var/door_color
	var/stripe_color
	var/symbol_color
	var/width = 1 // For multi-tile doors

/obj/structure/door_assembly/update_material_name(override_name)
	var/modifier
	switch (state)
		if(0)
			if(anchored)
				modifier = "secured "
		if(1)
			modifier = "wired "
		if(2)
			modifier = "near-finished "
	if(reinf_material)
		SetName("[modifier][reinf_material.solid_name] window [base_name]")
	else
		SetName("[modifier][base_name]")

/obj/structure/door_assembly/window
	reinf_material = /decl/material/solid/glass

/obj/structure/door_assembly/Initialize(mapload, _mat, _reinf_mat, _dir)
	. = ..(mapload, _mat, _reinf_mat)
	set_dir(_dir)
	update_icon()

/obj/structure/door_assembly/set_dir(new_dir)
	if(width == 1) // This logic doesn't support multitle doors.
		if(new_dir & (EAST|WEST))
			new_dir = WEST
		else
			new_dir = SOUTH

	. = ..(new_dir)

	if(.)
		set_bounds()

/obj/structure/door_assembly/proc/set_bounds()
	if (dir == NORTH || dir == SOUTH)
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/structure/door_assembly/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..() || list()
	switch(state)
		if(0)
			LAZYADD(., "Use a wrench to [anchored ? "un" : ""]anchor it.")
			if(!anchored)
				if(can_install_glass)
					if(reinf_material)
						var/mat_name = reinf_material.solid_name || reinf_material.name
						LAZYADD(., "Use a welder to remove the [mat_name] plating currently attached.")
				else
					LAZYADD(., "Use a welder to disassemble completely.")
			else
				LAZYADD(., "Use a cable coil to wire in preparation for electronics.")
		if(1)
			LAZYADD(., "Use a wirecutter to remove the wiring and expose the frame.")
			LAZYADD(., "Insert electronics to proceed with construction.")
		if(2)
			LAZYADD(., "Use a crowbar to remove the electronics.")
			LAZYADD(., "Use a screwdriver to complete assembly.")

/obj/structure/door_assembly/door_assembly_hatch
	icon = 'icons/obj/doors/hatch/door.dmi'
	panel_icon = 'icons/obj/doors/hatch/panel.dmi'
	fill_icon = 'icons/obj/doors/hatch/fill_steel.dmi'
	base_name = "airtight hatch"
	airlock_type = /obj/machinery/door/airlock/hatch
	can_install_glass = FALSE

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_icon = 'icons/obj/doors/secure/fill_steel.dmi'
	base_name = "high security airlock"
	airlock_type = /obj/machinery/door/airlock/highsecurity
	can_install_glass = FALSE
	paintable = 0

/obj/structure/door_assembly/door_assembly_ext
	icon = 'icons/obj/doors/external/door.dmi'
	fill_icon = 'icons/obj/doors/external/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/external/fill_glass.dmi'
	base_name = "external airlock"
	airlock_type = /obj/machinery/door/airlock/external
	paintable = 0

/obj/structure/door_assembly/double
	icon = 'icons/obj/doors/double/door.dmi'
	fill_icon = 'icons/obj/doors/double/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/double/fill_glass.dmi'
	panel_icon = 'icons/obj/doors/double/panel.dmi'
	airlock_type = /obj/machinery/door/airlock/double
	width = 2

/obj/structure/door_assembly/blast
	name = "blast door assembly"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	airlock_type = /obj/machinery/door/blast/regular
	can_install_glass = FALSE
	paintable = 0

/obj/structure/door_assembly/blast/on_update_icon()
	return

/obj/structure/door_assembly/blast/morgue
	name = "morgue door assembly"
	icon = 'icons/obj/doors/doormorgue.dmi'
	icon_state = "door1"
	airlock_type =  /obj/machinery/door/morgue

/obj/structure/door_assembly/blast/shutter
	name = "shutter assembly"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "shutter1"
	airlock_type = /obj/machinery/door/blast/shutters

/obj/structure/door_assembly/attackby(obj/item/used_item, mob/user)

	if(IS_PEN(used_item))
		var/t = sanitize_safe(input(user, "Enter the name for the door.", src.name, src.created_name), MAX_NAME_LEN)
		if(!length(t))
			return TRUE
		if(!CanPhysicallyInteractWith(user, src))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return TRUE
		created_name = t
		return TRUE

	if(IS_WELDER(used_item) && (can_install_glass || !anchored))
		var/obj/item/weldingtool/welder = used_item
		if (welder.weld(0, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			if(reinf_material)
				var/mat_name = reinf_material.solid_name
				user.visible_action_message("start", "slicing the [mat_name] plating off \the [src]...")
				if(do_after(user, 4 SECONDS, src))
					if(!welder.isOn())
						return TRUE
					user.visible_action_message("slice", "the [mat_name] plating off \the [src]!")
					reinf_material.create_object(get_turf(src), 2)
					reinf_material = null
					update_icon()
				return TRUE
			if(!anchored)
				user.visible_action_message("start", "disassembling \the [src].")
				if(do_after(user, 4 SECONDS, src))
					if(!welder.isOn())
						return TRUE
					user.visible_action_message("disassemble", "\the [src]!")
					dismantle_structure(user)
				return TRUE
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel."))
			return TRUE

	if(IS_WRENCH(used_item) && state == 0)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		user.visible_action_message("start", "[anchored ? "unsecuring" : "securing"] the airlock assembly [anchored ? "from" : "to"] the floor...")
		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			user.visible_action_message(anchored ? "unsecure" : "secure", "\the [src]!")
			anchored = !anchored
			update_icon()
		return TRUE


	else if(IS_COIL(used_item) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = used_item
		if (C.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need one length of coil to wire the airlock assembly."))
			return TRUE
		user.visible_action_message("start", "wiring \the [src]...")
		if(do_after(user, 4 SECONDS, src) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				user.visible_action_message("wire", "\the [src]!")
				update_icon()
		return TRUE

	else if(IS_WIRECUTTER(used_item) && state == 1 )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_action_message("start", "cutting the wires from \the [src]...")

		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			user.visible_action_message("cut", "the wires from \the [src].")
			new/obj/item/stack/cable_coil(src.loc, 1)
			src.state = 0
			update_icon()
		return TRUE

	else if(istype(used_item, /obj/item/stock_parts/circuitboard/airlock_electronics) && state == 1)
		var/obj/item/stock_parts/circuitboard/airlock_electronics/E = used_item
		if(!ispath(airlock_type, E.build_path))
			return FALSE
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_action_message("start", "installing \the [used_item] into \the [src]...")

		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			if(!user.try_unequip(used_item, src))
				return TRUE
			user.visible_action_message("install", "\the [used_item] into \the [src]!")
			src.state = 2
			update_material_name()
			src.electronics = used_item
			update_icon()
		return TRUE

	else if(IS_CROWBAR(used_item) && state == 2 )
		//This should never happen, but just in case I guess
		if (!electronics)
			to_chat(user, SPAN_NOTICE("There was nothing to remove."))
			src.state = 1
			update_icon()
			return TRUE

		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_action_message("start", "removing the electronics from the airlock assembly...")

		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			user.visible_action_message("remove", "\the [electronics]!")
			src.state = 1
			update_material_name()
			electronics.dropInto(loc)
			electronics = null
			update_icon()
		return TRUE

	else if(istype(used_item, /obj/item/stack/material) && can_install_glass && !reinf_material)
		var/obj/item/stack/material/S = used_item
		var/decl/material/sheet_material = S.get_material()
		if (S.get_amount() >= 2)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_action_message("start", "adding [S.get_string_for_amount(2)] to \the [src]...")
			if(do_after(user, 4 SECONDS, src) && can_install_glass && !reinf_material)
				if (S.use(2))
					reinf_material = sheet_material
					update_material_name()
					user.visible_action_message("install", "[reinf_material.solid_name] windows into \the [src]!")
					update_icon()
			return TRUE
		return FALSE

	else if(IS_SCREWDRIVER(used_item) && state == 2 )
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now finishing the airlock."))

		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			to_chat(user, SPAN_NOTICE("You finish the airlock!"))
			var/obj/machinery/door/door = new airlock_type(get_turf(src), dir, FALSE, src)
			door.construct_state.post_construct(door) // it eats the circuit inside Initialize
			qdel(src)
		return TRUE
	else
		return ..()

/obj/structure/door_assembly/on_update_icon()
	..()

	var/image/filling_overlay
	if(reinf_material)
		filling_overlay = image(glass_icon, "construction")
		filling_overlay.color = reinf_material.color
		filling_overlay.appearance_flags |= RESET_COLOR
	else
		filling_overlay = image(fill_icon, "construction")
	if(filling_overlay)
		add_overlay(filling_overlay)

	var/image/panel_overlay
	switch(state)
		if(1)
			panel_overlay = image(panel_icon, "construction0")
		if(2)
			panel_overlay = image(panel_icon, "construction1")
	if(panel_overlay)
		add_overlay(panel_overlay)
