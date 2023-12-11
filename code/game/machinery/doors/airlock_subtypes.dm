// Regular airlock presets

/obj/machinery/door/airlock/command
	door_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/security
	door_color = COLOR_NT_RED

/obj/machinery/door/airlock/security/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_NT_RED

/obj/machinery/door/airlock/engineering
	name = "Maintenance Hatch"
	door_color = COLOR_AMBER

/obj/machinery/door/airlock/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/medical/open
	icon_state = "open"
	begins_closed = FALSE

/obj/machinery/door/airlock/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_BOTTLE_GREEN

/obj/machinery/door/airlock/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/sol
	door_color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/chaplain
	stripe_color = COLOR_GRAY20

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER


// Glass airlock presets

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon_state = "preview_glass"
	hitsound = 'sound/effects/Glasshit.ogg'
	max_health = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/glass/command
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/glass/security
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE

/obj/machinery/door/airlock/glass/engineering
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED

/obj/machinery/door/airlock/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/glass/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock/external_air = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock/external_air = 1
	)

/obj/machinery/door/airlock/glass/mining
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/glass/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/glass/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH

/obj/machinery/door/airlock/glass/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/glass/sol
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/glass/freezer
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/glass/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/glass/civilian
	stripe_color = COLOR_CIVIE_GREEN


// External airlock presets

/obj/machinery/door/airlock/external
	airlock_type = "External"
	name = "External Airlock"
	icon = 'icons/obj/doors/external/door.dmi'
	fill_file = 'icons/obj/doors/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/external/color.dmi'
	color_fill_file = 'icons/obj/doors/external/fill_color.dmi'
	glass_file = 'icons/obj/doors/external/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/external/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/external/lights_deny.dmi'
	lights_file = 'icons/obj/doors/external/lights_green.dmi'
	emag_file = 'icons/obj/doors/external/emag.dmi'
	frame_type = /obj/structure/door_assembly/door_assembly_ext
	door_color = COLOR_NT_RED
	paintable = PAINT_PAINTABLE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock/external_air = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock/external_air = 1
	)

/obj/machinery/door/airlock/external/open
	icon_state = "open"
	begins_closed = FALSE

/obj/machinery/door/airlock/external/get_auto_access()
	. = ..()
	var/area/A = get_area(src)
	if(A && is_station_area(A))
		LAZYADD(., access_external_airlocks)

/obj/machinery/door/airlock/external/escapepod
	name = "Escape Pod"
	locked = TRUE

/obj/machinery/door/airlock/external/escapepod/attackby(obj/item/C, mob/user)
	if(panel_open && !arePowerSystemsOn())
		if(IS_WRENCH(C))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message(SPAN_WARNING("[user.name] starts frantically pumping the bolt override mechanism!"), SPAN_WARNING("You start frantically pumping the bolt override mechanism!"))
			if(do_after(user, 160) && locked)
				visible_message("\The [src] bolts disengage!")
				locked = FALSE
				return TRUE
			else
				visible_message("\The [src] bolts engage!")
				locked = TRUE
				return TRUE
	return ..()

/obj/machinery/door/airlock/external/shuttle
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock/shuttle = 1
	)

/obj/machinery/door/airlock/external/bolted
	locked = TRUE

/obj/machinery/door/airlock/external/bolted_open
	density = FALSE
	locked = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/external/glass
	max_health = 300
	explosion_resistance = 5
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/airlock/external/glass/bolted
	locked = TRUE

/obj/machinery/door/airlock/external/glass/bolted_open
	density = FALSE
	locked = TRUE
	opacity = FALSE

// Miscellaneous airlock presets

/obj/machinery/door/airlock/centcom
	airlock_type = "centcomm"
	name = "\improper Airlock"
	icon = 'icons/obj/doors/centcomm/door.dmi'
	fill_file = 'icons/obj/doors/centcomm/fill_steel.dmi'
	paintable = PAINT_PAINTABLE|PAINT_STRIPABLE

/obj/machinery/door/airlock/highsecurity
	airlock_type = "secure"
	name = "Secure Airlock"
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_file = 'icons/obj/doors/secure/fill_steel.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	frame_type = /obj/structure/door_assembly/door_assembly_highsecurity
	paintable = 0

/obj/machinery/door/airlock/highsecurity/get_damage_leakthrough(var/damage, damtype=BRUTE)
	return 0
/obj/machinery/door/airlock/highsecurity/bolted
	locked = TRUE

/obj/machinery/door/airlock/hatch
	airlock_type = "hatch"
	name = "\improper Airtight Hatch"
	icon = 'icons/obj/doors/hatch/door.dmi'
	fill_file = 'icons/obj/doors/hatch/fill_steel.dmi'
	stripe_file = 'icons/obj/doors/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/hatch/fill_stripe.dmi'
	bolts_file = 'icons/obj/doors/hatch/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/hatch/lights_deny.dmi'
	lights_file = 'icons/obj/doors/hatch/lights_green.dmi'
	panel_file = 'icons/obj/doors/hatch/panel.dmi'
	welded_file = 'icons/obj/doors/hatch/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'
	explosion_resistance = 20
	opacity = TRUE
	frame_type = /obj/structure/door_assembly/door_assembly_hatch
	paintable = PAINT_STRIPABLE

/obj/machinery/door/airlock/hatch/maintenance
	name = "Maintenance Hatch"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/maintenance/bolted
	locked = TRUE

/obj/machinery/door/airlock/vault
	airlock_type = "vault"
	name = "Vault"
	icon = 'icons/obj/doors/vault/door.dmi'
	fill_file = 'icons/obj/doors/vault/fill_steel.dmi'
	explosion_resistance = 20
	opacity = TRUE
	secured_wires = TRUE
	frame_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	paintable = PAINT_PAINTABLE|PAINT_STRIPABLE

/obj/machinery/door/airlock/vault/get_damage_leakthrough(var/damage, damtype=BRUTE)
	return 0
/obj/machinery/door/airlock/vault/bolted
	locked = TRUE
