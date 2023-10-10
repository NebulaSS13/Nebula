/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "construction"
	anchored = 0
	density = 1
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/state = 0
	var/base_name = "Airlock"
	var/obj/item/stock_parts/circuitboard/airlock_electronics/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed.
	var/glass_material = /decl/material/solid/glass // if this door was to built right now and be made of glass, what material should the glass be?
	var/created_name = null
	var/panel_icon = 'icons/obj/doors/station/panel.dmi'
	var/fill_icon = 'icons/obj/doors/station/fill_steel.dmi'
	var/glass_icon = 'icons/obj/doors/station/fill_glass.dmi'
	var/paintable = PAINT_PAINTABLE|PAINT_STRIPABLE
	var/door_color = "none"
	var/stripe_color = "none"
	var/symbol_color = "none"
	var/width = 1 // For multi-tile doors

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

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	switch(state)
		if(0)
			to_chat(user, "Use a wrench to [anchored ? "un" : ""]anchor it.")
			if(!anchored)
				if(glass == 1)
					var/decl/material/glass_material_datum = GET_DECL(glass_material)
					if(glass_material_datum)
						var/mat_name = glass_material_datum.solid_name || glass_material_datum.name
						to_chat(user, "Use a welder to remove the [mat_name] plating currently attached.")
				else
					to_chat(user, "Use a welder to disassemble completely.")
			else
				to_chat(user, "Use a cable coil to wire in preparation for electronics.")
		if(1)
			to_chat(user, "Use a wirecutter to remove the wiring and expose the frame.")
			to_chat(user, "Insert electronics to proceed with construction.")
		if(2)
			to_chat(user, "Use a crowbar to remove the electronics.")
			to_chat(user, "Use a screwdriver to complete assembly.")

/obj/structure/door_assembly/door_assembly_hatch
	icon = 'icons/obj/doors/hatch/door.dmi'
	panel_icon = 'icons/obj/doors/hatch/panel.dmi'
	fill_icon = 'icons/obj/doors/hatch/fill_steel.dmi'
	base_name = "Airtight Hatch"
	airlock_type = /obj/machinery/door/airlock/hatch
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_icon = 'icons/obj/doors/secure/fill_steel.dmi'
	base_name = "High Security Airlock"
	airlock_type = /obj/machinery/door/airlock/highsecurity
	glass = -1
	paintable = 0

/obj/structure/door_assembly/door_assembly_ext
	icon = 'icons/obj/doors/external/door.dmi'
	fill_icon = 'icons/obj/doors/external/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/external/fill_glass.dmi'
	base_name = "External Airlock"
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
	glass = -1
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

/obj/structure/door_assembly/attackby(obj/item/W, mob/user)

	if(IS_PEN(W))
		var/t = sanitize_safe(input(user, "Enter the name for the door.", src.name, src.created_name), MAX_NAME_LEN)
		if(!length(t))
			return
		if(!CanPhysicallyInteractWith(user, src))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return
		created_name = t
		return TRUE

	if(IS_WELDER(W) && (glass == 1 || !anchored))
		var/obj/item/weldingtool/WT = W
		if (WT.weld(0, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			if(glass == 1)
				var/decl/material/glass_material_datum = GET_DECL(glass_material)
				if(glass_material_datum)
					var/mat_name = glass_material_datum.solid_name || glass_material_datum.name
					user.visible_message("[user] welds the [mat_name] plating off the airlock assembly.", "You start to weld the [mat_name] plating off the airlock assembly.")
					if(do_after(user, 40,src))
						if(!WT.isOn())
							return TRUE
						to_chat(user, "<span class='notice'>You welded the [mat_name] plating off!</span>")
						glass_material_datum.create_object(get_turf(src), 2)
						glass = 0
						update_icon()
					return TRUE
			if(!anchored)
				user.visible_message("[user] dissassembles the airlock assembly.", "You start to dissassemble the airlock assembly.")
				if(do_after(user, 40,src))
					if(!WT.isOn())
						return
					to_chat(user, "<span class='notice'>You dissasembled the airlock assembly!</span>")
					dismantle()
					return TRUE
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
			return TRUE

	if(IS_WRENCH(W) && state == 0)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring the airlock assembly from the floor.", "You begin unsecuring the airlock assembly from the floor.")
		else
			user.visible_message("[user] begins securing the airlock assembly to the floor.", "You begin securing the airlock assembly to the floor.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured the airlock assembly!</span>")
			anchored = !anchored
			update_icon()


	else if(IS_COIL(W) && state == 0 && anchored)
		var/obj/item/stack/cable_coil/C = W
		if (C.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire the airlock assembly.</span>")
			return
		user.visible_message("[user] wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 40,src) && state == 0 && anchored)
			if (C.use(1))
				src.state = 1
				to_chat(user, "<span class='notice'>You wire the airlock.</span>")
				update_icon()

	else if(IS_WIRECUTTER(W) && state == 1 )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from the airlock assembly.", "You start to cut the wires from airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the airlock wires.!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			src.state = 0
			update_icon()

	else if(istype(W, /obj/item/stock_parts/circuitboard/airlock_electronics) && state == 1)
		var/obj/item/stock_parts/circuitboard/airlock_electronics/E = W
		if(!ispath(airlock_type, E.build_path))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			if(!user.try_unequip(W, src))
				return
			to_chat(user, "<span class='notice'>You installed the airlock electronics!</span>")
			src.state = 2
			src.SetName("Near finished Airlock Assembly")
			src.electronics = W
			update_icon()

	else if(IS_CROWBAR(W) && state == 2 )
		//This should never happen, but just in case I guess
		if (!electronics)
			to_chat(user, "<span class='notice'>There was nothing to remove.</span>")
			src.state = 1
			update_icon()
			return

		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("\The [user] starts removing the electronics from the airlock assembly.", "You start removing the electronics from the airlock assembly.")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")
			src.state = 1
			src.SetName("Wired Airlock Assembly")
			electronics.dropInto(loc)
			electronics = null
			update_icon()

	else if(istype(W, /obj/item/stack/material) && !glass)
		var/obj/item/stack/material/S = W
		var/material_name = S.get_material_type()
		if (S.get_amount() >= 2)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
			if(do_after(user, 40,src) && !glass)
				if (S.use(2))
					to_chat(user, "<span class='notice'>You installed reinforced glass windows into the airlock assembly.</span>")
					glass = 1
					glass_material = material_name
					update_icon()
			return TRUE

	else if(IS_SCREWDRIVER(W) && state == 2 )
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now finishing the airlock.</span>")

		if(do_after(user, 40,src))
			if(!src) return
			to_chat(user, "<span class='notice'>You finish the airlock!</span>")
			var/obj/machinery/door/door = new airlock_type(get_turf(src), dir, FALSE, src)
			door.construct_state.post_construct(door) // it eats the circuit inside Initialize
			qdel(src)
	else
		..()

/obj/structure/door_assembly/on_update_icon()
	..()
	var/image/filling_overlay
	var/image/panel_overlay
	var/final_name = ""
	if(glass == 1)
		filling_overlay = image(glass_icon, "construction")
	else
		filling_overlay = image(fill_icon, "construction")
	switch (state)
		if(0)
			if (anchored)
				final_name = "Secured "
		if(1)
			final_name = "Wired "
			panel_overlay = image(panel_icon, "construction0")
		if(2)
			final_name = "Near Finished "
			panel_overlay = image(panel_icon, "construction1")
	final_name += "[glass == 1 ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"
	SetName(final_name)
	add_overlay(filling_overlay)
	add_overlay(panel_overlay)
