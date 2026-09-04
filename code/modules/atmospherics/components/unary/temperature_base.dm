/obj/machinery/atmospherics/unary/temperature
	abstract_type = /obj/machinery/atmospherics/unary/temperature
	name = "gas thermoregulation system"
	desc = "This should not be visible."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater_0"
	layer = STRUCTURE_LAYER
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 5			//5 Watts for thermostat related circuitry
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	connect_types = CONNECT_TYPE_REGULAR | CONNECT_TYPE_FUEL
	var/internal_volume = 600	//L
	var/max_power_rating = 20000	//power rating when the usage is turned up to 100
	var/power_setting = 100
	var/set_temperature = T20C	//thermostat
	var/is_modifying_gas = FALSE //mainly for icon updates
	var/base_icon_state = "heater"
	var/performance_multiplier = 1
	var/max_temperature = T20C+500
	var/ui_title = "Gas Thermoregulation System"

/obj/machinery/atmospherics/unary/temperature/on_update_icon()
	if(!LAZYLEN(nodes_to_networks))
		icon_state = "[base_icon_state]_0"
	else if(use_power && is_modifying_gas)
		icon_state = "[base_icon_state]_1"
	else
		icon_state = base_icon_state

// Modify air_contents in this proc.
/obj/machinery/atmospherics/unary/temperature/proc/modify_gas()

/obj/machinery/atmospherics/unary/temperature/proc/should_modify_gas()
	return FALSE

/obj/machinery/atmospherics/unary/temperature/Process()
	..()

	is_modifying_gas = FALSE
	if(stat & (NOPOWER|BROKEN) || !use_power)
		update_icon()
		return

	if(LAZYLEN(nodes_to_networks) && air_contents.total_moles && should_modify_gas())
		modify_gas()
		is_modifying_gas = TRUE
		use_power_oneoff(power_rating)
		update_networks()

	update_icon()

/obj/machinery/atmospherics/unary/temperature/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/atmospherics/unary/temperature/proc/get_temperature_class()
	PROTECTED_PROC(TRUE)
	return "normal"

/obj/machinery/atmospherics/unary/temperature/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = round(max_temperature)
	data["targetGasTemperature"] = round(set_temperature)
	data["powerSetting"] = power_setting

	data["gasTemperatureClass"] = get_temperature_class()

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "freezer.tmpl", ui_title, 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/temperature/OnTopic(mob/user, href_list)
	if((. = ..()))
		return
	if(href_list["toggleStatus"])
		update_use_power(!use_power)
		. = TOPIC_REFRESH
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		set_temperature = clamp(set_temperature + amount, 0, max_temperature)
		. = TOPIC_REFRESH
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		var/new_setting = clamp(text2num(href_list["setPower"]), 0, 100)
		set_power_level(new_setting)
		. = TOPIC_REFRESH

//upgrading parts
/obj/machinery/atmospherics/unary/temperature/RefreshParts()
	..()
	var/cap_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 1, 20)
	var/bin_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)

	max_power_rating = initial(max_power_rating) * cap_rating / 2
	air_contents.total_volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/temperature/proc/set_power_level(var/new_power_setting)
	power_setting = new_power_setting
	power_rating = max_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/temperature/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(panel_open)
		. += "The maintenance hatch is open."
