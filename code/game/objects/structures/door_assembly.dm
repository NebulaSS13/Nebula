/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NAME
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_WIRING

	var/can_install_glass = TRUE
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
	if(electronics)
		name_prefix = "near-finished"
	else if(wired)
		name_prefix = "wired"
	else if(anchored)
		name_prefix = "secured"
	else
		name_prefix = null
	if(reinf_material)
		..("[reinf_material.solid_name] window [base_name]")
	else
		..("[base_name]")

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
	if(electronics)
		LAZYADD(., "Use a crowbar to remove the electronics.")
		if(anchored)
			LAZYADD(., "Use a screwdriver to complete assembly.")
		else
			LAZYADD(., "Use a wrench to anchor it.")
	else if(!wired && !electronics)
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
	else if(wired)
		LAZYADD(., "Use a wirecutter to remove the wiring and expose the frame.")
		LAZYADD(., "Insert electronics to proceed with construction.")

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
	var/const/window_sheets_used = 2

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
		if(reinf_material)
			var/mat_name = reinf_material.solid_name
			if(used_item.do_tool_interaction(TOOL_WELDER, user, src, 4 SECONDS, "welding the [mat_name] plating off", "welding the [mat_name] plating off"))
				reinf_material.create_object(get_turf(src), window_sheets_used)
				reinf_material = null
				update_icon()
				update_material_name()
			return TRUE
		if(!anchored && used_item.do_tool_interaction(TOOL_WELDER, user, src, 4 SECONDS, "disassembling", "disassembling"))
			dismantle_structure(user)
			return TRUE

	else if(istype(used_item, /obj/item/stock_parts/circuitboard/airlock_electronics) && wired && !electronics && anchored)
		var/obj/item/stock_parts/circuitboard/airlock_electronics/E = used_item
		if(!ispath(airlock_type, E.build_path))
			return FALSE
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_message("[user] installs \the [E] into \the [src].", "You start to install \the [E] into \the [src].")

		if(do_after(user, 4 SECONDS, src))
			if(QDELETED(src)) return TRUE
			if(!user.try_unequip(used_item, src))
				return TRUE
			to_chat(user, "<span class='notice'>You installed the airlock electronics!</span>")
			electronics = used_item
			update_icon()
			update_material_name()
		return TRUE

	else if(IS_CROWBAR(used_item) && electronics && anchored)
		if(used_item.do_tool_interaction(TOOL_CROWBAR, user, src, 4 SECONDS, "removing \the [electronics] from", "removing \the [electronics] from", check_skill = SKILL_ELECTRICAL))
			if(QDELETED(src))
				return TRUE
			electronics.dropInto(loc)
			electronics = null
			update_icon()
			update_material_name()
		return TRUE

	else if(istype(used_item, /obj/item/stack/material) && can_install_glass && !reinf_material)
		var/obj/item/stack/material/stack_item = used_item
		if (stack_item.can_use(window_sheets_used))
			playsound(loc, 'sound/items/Crowbar.ogg', 100, 1)
			var/stack_name = stack_item.get_string_for_amount(window_sheets_used)
			user.visible_message("[user] adds [stack_name] to \the [src].", "You start to install [stack_name] into \the [src].")
			if(do_after(user, 4 SECONDS, src) && can_install_glass && !reinf_material)
				if (stack_item.use(window_sheets_used))
					reinf_material = stack_item.get_material()
					to_chat(user, "<span class='notice'>You finish installing [reinf_material.solid_name] windows into \the [src].</span>")
					update_icon()
					update_material_name()
			return TRUE
		return FALSE

	else if(IS_SCREWDRIVER(used_item) && wired && electronics && anchored)
		to_chat(user, "<span class='notice'>Now finishing the airlock.</span>")
		if(used_item.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 4 SECONDS))
			if(QDELETED(src))
				return TRUE
			to_chat(user, SPAN_NOTICE("You finish the airlock!"))
			var/obj/machinery/door/door = new airlock_type(get_turf(src), dir, FALSE, src)
			door.construct_state.post_construct(door) // it eats the circuit inside Initialize
			qdel(src)
		return TRUE
	else
		return ..()

/obj/structure/door_assembly/handle_default_wrench_attackby(mob/user, obj/item/wrench)
	return !wired && !electronics && ..()

/obj/structure/door_assembly/handle_default_cable_attackby(mob/user, obj/item/stack/cable_coil/coil)
	return !wired && !electronics && ..()

/obj/structure/door_assembly/handle_default_wirecutter_attackby(mob/user, obj/item/wirecutters)
	return wired && !electronics && ..()

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
	if(electronics)
		panel_overlay = image(panel_icon, "construction1")
	else if(wired)
		panel_overlay = image(panel_icon, "construction0")
	if(panel_overlay)
		add_overlay(panel_overlay)
