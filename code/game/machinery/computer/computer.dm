/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1.0
	idle_power_usage = 300
	active_power_usage = 300
	construct_state = /decl/machine_construction/default/panel_closed/computer
	uncreated_component_parts = null
	stat_immune = 0
	frame_type = /obj/machinery/constructable_frame/computerframe/deconstruct
	var/processing = 0

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_max_bright_on = 0.2
	var/light_inner_range_on = 0.1
	var/light_outer_range_on = 2
	var/overlay_layer
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	clicksound = "keyboard"

/obj/machinery/computer/Initialize()
	. = ..()
	overlay_layer = layer
	update_icon()

/obj/machinery/computer/get_codex_value()
	return "computer"
	
/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken(TRUE)
	..()

/obj/machinery/computer/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1 || (severity == 2 && prob(25)))
			qdel(src)
		else if(prob(100 - (severity * 25)))
			verbs.Cut()
			set_broken(TRUE)

/obj/machinery/computer/on_update_icon()
	overlays.Cut()
	icon = initial(icon)
	icon_state = initial(icon_state)

	if(reason_broken & MACHINE_BROKEN_NO_PARTS)
		set_light(0)
		icon = 'icons/obj/computer.dmi'
		icon_state = "wired"
		var/screen = get_component_of_type(/obj/item/stock_parts/console_screen)
		var/keyboard = get_component_of_type(/obj/item/stock_parts/keyboard)
		if(screen)
			overlays += "comp_screen"
		if(keyboard)
			overlays += icon_keyboard ? "[icon_keyboard]_off" : "keyboard"
		return

	if(stat & NOPOWER)
		set_light(0)
		if(icon_keyboard)
			overlays += image(icon,"[icon_keyboard]_off", overlay_layer)
		return
	else
		set_light(light_max_bright_on, light_inner_range_on, light_outer_range_on, 2, light_color)

	if(stat & BROKEN)
		overlays += image(icon,"[icon_state]_broken", overlay_layer)
	else
		overlays += get_screen_overlay()

	overlays += get_keyboard_overlay()

/obj/machinery/computer/proc/get_screen_overlay()
	return image(icon,icon_screen, overlay_layer)

/obj/machinery/computer/proc/get_keyboard_overlay()
	if(icon_keyboard)
		overlays += image(icon, icon_keyboard, overlay_layer)

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/dismantle(mob/user)
	if(stat & BROKEN)
		to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
		for(var/obj/item/stock_parts/console_screen/screen in component_parts)
			qdel(screen)
			new /obj/item/material/shard(loc)
	else
		to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
	return ..()