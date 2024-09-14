/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = TRUE
	idle_power_usage = 5
	power_channel = EQUIP
	var/chargelevel = -1

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	maximum_component_parts = list(
		/obj/item/stock_parts = 10,
		/obj/item/stock_parts/power/battery = 1
	)

/obj/machinery/cell_charger/components_are_accessible(path)
	if(ispath(path, /obj/item/stock_parts/power/battery))
		return TRUE
	return ..()

/obj/machinery/cell_charger/on_update_icon()
	var/obj/item/cell/charging = get_cell()
	icon_state = "ccharger[charging ? 1 : 0]"
	if(charging && !(stat & (BROKEN|NOPOWER)) )
		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		if(chargelevel != newlevel)
			overlays.Cut()
			overlays += "ccharger-o[newlevel]"
			chargelevel = newlevel
	else
		overlays.Cut()

/obj/machinery/cell_charger/examine(var/mob/user, var/distance)
	. = ..()
	if(distance <= 5)
		var/obj/item/cell/cell = get_cell()
		to_chat(user, "There's [cell ? "a" : "no"] cell in the charger.")
		if(cell)
			to_chat(user, "Current charge: [cell.charge].")

/obj/machinery/cell_charger/component_stat_change(obj/item/stock_parts/part, old_stat, flag)
	. = ..()
	if(istype(part, /obj/item/stock_parts/power/battery) && (flag & PART_STAT_CONNECTED))
		chargelevel = -1
		if(part.status & PART_STAT_CONNECTED)
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
			var/obj/item/stock_parts/power/battery/bat = part
			bat.charge_wait_counter = 0 // make it start charging immediately
		else
			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		update_icon()

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W) && !panel_open)
		. = TRUE
		if(get_cell())
			to_chat(user, "<span class='warning'>Remove the cell first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] \the [src] [anchored ? "to" : "from"] the ground.")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		return

	return ..()

/obj/machinery/cell_charger/Process()
	update_icon()