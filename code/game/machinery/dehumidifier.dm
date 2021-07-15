//This magic dehumidifier is a portable water-to-nothing machine, although it does need a charged cell to work.
//See drain.dm!
/obj/machinery/dehumidifier
	name = "emergency dehumidifier"
	desc = "A portable dehumidifier with emergency high-volume pump to help keep you dry when it's getting damp... just very slowly."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "dhum-off"
	anchored = FALSE
	density = TRUE

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/dehumidifier
	stat_immune = 0

	power_channel = LOCAL
	use_power = POWER_USE_OFF

	obj_flags = OBJ_FLAG_ANCHORABLE
	atom_flags = ATOM_FLAG_CLIMBABLE
	clicksound = "switch"

	var/active = FALSE
	var/drainage = TRUE
	var/last_gurgle = 0

/obj/machinery/dehumidifier/Initialize()
	. = ..()
	queue_icon_update()

/obj/machinery/dehumidifier/on_update_icon()
	icon_state = "dhum-[active ? "on" : "off"]"
	overlays.Cut()
	if(panel_open)
		overlays.Add("dhum-open")

/obj/machinery/dehumidifier/examine(mob/user)
	. = ..()
	if(.)
		to_chat(user, "The dehumidifier is [active ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"].")
		var/obj/item/cell/cell = get_cell()
		if(panel_open)
			to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
		else
			to_chat(user, "The charge meter reads [cell ? round(cell.percent(), 1) : 0]%")

/obj/machinery/dehumidifier/proc/set_active(new_active)
	if(active != new_active)
		active = new_active
		queue_icon_update()

/obj/machinery/dehumidifier/components_are_accessible(path)
	return !active && ..()

/obj/machinery/dehumidifier/physical_attack_hand(mob/user)
	if(!panel_open)
		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNING("You try to switch [src] on, but nothing happens."))
			return TRUE
		set_active(!active)
		user.visible_message(
			SPAN_NOTICE("[user] switches [active ? "on" : "off"] the [src]."),
			SPAN_NOTICE("You switch [active ? "on" : "off"] the [src]."))
		return TRUE

/obj/machinery/dehumidifier/Process()
	if(!active)
		return

	if(!(stat & NOPOWER))
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/fluid_here = T.get_fluid_depth()
		if(fluid_here <= 0)
			use_power_oneoff(drainage * 1000)
			return

		T.remove_fluid(CEILING(fluid_here * drainage))
		T.show_bubbles()
		use_power_oneoff(drainage * 5000)

		if(world.time > last_gurgle + 80)
			last_gurgle = world.time
			playsound(T, pick(SSfluids.gurgles), 50, 1)
	else
		set_active(FALSE)
