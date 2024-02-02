/obj/machinery/computer
	name = "computer console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 300
	active_power_usage = 300
	construct_state = /decl/machine_construction/default/panel_closed/computer
	uncreated_component_parts = null
	stat_immune = 0
	frame_type = /obj/machinery/constructable_frame/computerframe/deconstruct

	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/light_range_on = 2
	var/light_power_on = 1
	var/overlay_layer
	atom_flags = ATOM_FLAG_CLIMBABLE
	clicksound = "keyboard"

/obj/machinery/computer/Initialize()
	. = ..()
	overlay_layer = layer
	update_icon()

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken(TRUE)
	..()

/obj/machinery/computer/on_update_icon()

	cut_overlays()
	icon = initial(icon)
	icon_state = initial(icon_state)

	if(reason_broken & MACHINE_BROKEN_NO_PARTS)
		set_light(0)
		icon = 'icons/obj/computer.dmi' //#FIXME: I really don't know why you'd do that after re-initializing it above.
		icon_state = "wired"
		var/screen = get_component_of_type(/obj/item/stock_parts/console_screen)
		var/keyboard = get_component_of_type(/obj/item/stock_parts/keyboard)
		if(screen)
			add_overlay("comp_screen")
		if(keyboard)
			add_overlay(icon_keyboard ? "[icon_keyboard]_off" : "keyboard")
		return

	var/offline = (stat & NOPOWER)
	if(!offline)
		var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
		if(os && !os.on)
			offline = TRUE

	if(offline)
		set_light(0)
		if(icon_keyboard)
			add_overlay(image(icon,"[icon_keyboard]_off", overlay_layer))
		if(stat & BROKEN)
			add_overlay(image(icon,"[icon_state]_broken", overlay_layer))
		return

	set_light(light_range_on, light_power_on, light_color)
	if(stat & BROKEN)
		add_overlay(image(icon,"[icon_state]_broken", overlay_layer))
	else
		var/screen_overlay = get_screen_overlay()
		if(screen_overlay)
			add_overlay(screen_overlay)
	var/keyboard_overlay = get_keyboard_overlay()
	if(keyboard_overlay)
		add_overlay(keyboard_overlay)

/obj/machinery/computer/proc/get_screen_overlay()
	if(icon_screen)
		var/image/I = image(icon, icon_screen, overlay_layer)
		I.appearance_flags |= RESET_COLOR
		return I

/obj/machinery/computer/proc/get_keyboard_overlay()
	if(icon_keyboard)
		var/image/I = image(icon, icon_keyboard, overlay_layer)
		I.appearance_flags |= RESET_COLOR
		return I

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/dismantle(mob/user)
	if(stat & BROKEN)
		to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
		for(var/obj/item/stock_parts/console_screen/screen in component_parts)
			qdel(screen)
			new /obj/item/shard(loc)
	else
		to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
	return ..()