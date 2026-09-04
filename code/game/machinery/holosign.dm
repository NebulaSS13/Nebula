////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector."
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_DOOR_LAYER
	idle_power_usage = 2
	active_power_usage = 70
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'
	var/lit = FALSE
	var/on_icon = "sign_on"
	var/sign_light_color = COLOR_CYAN_BLUE

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_variables = list(
		/decl/public_access/public_variable/holosign_on
	)
	public_methods = list(
		/decl/public_access/public_method/holosign_toggle
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/holosign = 1)

/obj/machinery/holosign/proc/toggle()
	if (inoperable())
		return
	lit = !lit
	update_use_power(lit ? POWER_USE_ACTIVE : POWER_USE_IDLE)

/obj/machinery/holosign/on_update_icon()
	if (!lit || inoperable())
		icon_state = initial(icon_state)
		set_light(0)
	else
		icon_state = on_icon
		set_light(1, 0.5, sign_light_color)

/decl/public_access/public_variable/holosign_on
	expected_type = /obj/machinery/holosign
	name = "holosign active"
	desc = "Whether or not the holosign is active."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/holosign_on/access_var(obj/machinery/holosign/sign)
	return sign.lit

/decl/public_access/public_method/holosign_toggle
	name = "holosign toggle"
	desc = "Toggle the holosign's active state."
	call_proc = TYPE_PROC_REF(/obj/machinery/holosign, toggle)

/decl/stock_part_preset/radio/receiver/holosign
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/holosign_toggle)

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"

/obj/machinery/holosign/chapel
	name = "chapel holosign"
	desc = "Small wall-mounted holographic projector. This one reads SERVICE."
	on_icon = "service"

/obj/machinery/holosign/bar
	name = "bar holosign"
	desc = "Small wall-mounted holographic projector. This one reads OPEN."
	icon_state = "barclosed"
	on_icon = "baropen"
	sign_light_color = COLOR_LIGHT_CYAN

////////////////////SWITCH///////////////////////////////////////
/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crematorium_switch"

/obj/machinery/button/holosign/on_update_icon()
	icon_state = "light[active]"