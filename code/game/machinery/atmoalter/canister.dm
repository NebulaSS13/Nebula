/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow"
	density = TRUE
	max_health = 100
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_GARGANTUAN
	construct_state = /decl/machine_construction/pipe/welder
	uncreated_component_parts = null
	start_pressure             = 45 ATM
	volume                     = 1000
	interact_offline           = TRUE
	matter = list(
		/decl/material/solid/metal/steel = 10 * SHEET_MATERIAL_AMOUNT
	)

	var/valve_open             = FALSE
	var/release_pressure       = ONE_ATMOSPHERE
	var/release_flow_rate      = ATMOS_DEFAULT_VOLUME_PUMP //in L/s
	var/canister_color         = "yellow"
	var/can_label              = TRUE
	var/temperature_resistance = 1000 + T0C

/obj/machinery/portable_atmospherics/canister/Initialize(mapload, material)
	if(ispath(material))
		matter = list()
		matter[material] = 10 * SHEET_MATERIAL_AMOUNT
	. = ..(mapload)

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name           = "\improper N2O canister"
	icon_state     = "redws"
	canister_color = "redws"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/nitrogen
	name           = "nitrogen canister"
	icon_state     = "red"
	canister_color = "red"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled
	name           = "cryogenic nitrogen canister"
	start_pressure = 20 ATM

/obj/machinery/portable_atmospherics/canister/oxygen
	name           = "oxygen canister"
	icon_state     = "blue"
	canister_color = "blue"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name           = "cryogenic oxygen canister"
	start_pressure = 20 ATM

/obj/machinery/portable_atmospherics/canister/hydrogen
	name           = "hydrogen canister"
	icon_state     = "purple"
	canister_color = "purple"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name           = "\improper CO2 canister"
	icon_state     = "black"
	canister_color = "black"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/air
	name           = "air canister"
	icon_state     = "grey"
	canister_color = "grey"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 ATM

/obj/machinery/portable_atmospherics/canister/empty
	start_pressure = 0
	can_label      = TRUE
	var/obj/machinery/portable_atmospherics/canister/canister_type = /obj/machinery/portable_atmospherics/canister

/obj/machinery/portable_atmospherics/canister/empty/Initialize()
	. = ..()
	name           = initial(canister_type.name)
	icon_state     = initial(canister_type.icon_state)
	canister_color = initial(canister_type.canister_color)

/obj/machinery/portable_atmospherics/canister/empty/air
	icon_state    = "grey"
	canister_type = /obj/machinery/portable_atmospherics/canister/air
/obj/machinery/portable_atmospherics/canister/empty/oxygen
	icon_state    = "blue"
	canister_type = /obj/machinery/portable_atmospherics/canister/oxygen
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	icon_state    = "red"
	canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	icon_state    = "black"
	canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
/obj/machinery/portable_atmospherics/canister/empty/sleeping_agent
	icon_state    = "redws"
	canister_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
/obj/machinery/portable_atmospherics/canister/empty/hydrogen
	icon_state    = "purple"
	canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen

/obj/machinery/portable_atmospherics/canister/on_update_icon()

	cut_overlays()

	if(destroyed)
		icon_state = "[canister_color]-1"
		return

	icon_state = canister_color

	if(holding)
		add_overlay("can-open")
	if(get_port())
		add_overlay("can-connector")

	var/tank_pressure = return_pressure()
	if(tank_pressure < 10)
		add_overlay("can-o0")
	else if(tank_pressure < ONE_ATMOSPHERE)
		add_overlay("can-o1")
	else if(tank_pressure < (15 ATM))
		add_overlay("can-o2")
	else
		add_overlay("can-o3")

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		current_health -= 5
		healthcheck()
	return ..()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(!destroyed && current_health <= 10)
		var/atom/location = loc
		location.assume_air(air_contents)
		destroyed = TRUE
		playsound(loc, 'sound/effects/spray.ogg', 10, 1, -3)
		set_density(FALSE)
		if(holding)
			holding.dropInto(loc)
			holding = null
		update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/canister/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		T.assume_air(air_contents)
	for(var/path in matter)
		SSmaterials.create_object(path, get_turf(src), round(matter[path]/SHEET_MATERIAL_AMOUNT))
	qdel(src)

/obj/machinery/portable_atmospherics/canister/Process()

	if (destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit
			pump_gas_passive(src, air_contents, environment, transfer_moles)

	can_label = (air_contents?.return_pressure() < 1)
	air_contents?.react()

	update_icon()
	if(holding)
		holding.update_icon()

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.atom_damage_type == BRUTE || Proj.atom_damage_type == BURN))
		return
	if(Proj.damage)
		current_health -= round(Proj.damage / 2)
		healthcheck()
	return ..()

/obj/machinery/portable_atmospherics/canister/bash(var/obj/item/W, var/mob/user)
	. = ..()
	if(.)
		current_health -= W.get_attack_force(user)
		healthcheck()

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W, var/mob/user)
	if(isrobot(user) && istype(W, /obj/item/tank/jetpack))
		var/obj/item/tank/jetpack/pack = W
		var/datum/gas_mixture/thejetpack = pack.air_contents
		if(thejetpack)
			var/env_pressure = thejetpack.return_pressure()
			var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
			//Can not have a pressure delta that would cause environment pressure > tank pressure
			var/transfer_moles = 0
			if((air_contents.temperature > 0) && (pressure_delta > 0))
				transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
				thejetpack.merge(removed)
				to_chat(user, "You pulse-pressurize your jetpack from the tank.")
				return TRUE
	return ..()

/obj/machinery/portable_atmospherics/canister/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/data[0]
	data["name"] = name
	data["canLabel"] = can_label ? 1 : 0
	data["portConnected"] = get_port() ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(0.1 ATM)
	data["maxReleasePressure"] = round(10 ATM)
	data["valveOpen"] = valve_open ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/canister/OnTopic(var/mob/user, href_list, state)
	if(href_list["toggle"])
		if (!valve_open)
			if(!holding)
				log_open()
		valve_open = !valve_open
		. = TOPIC_REFRESH

	else if (href_list["remove_tank"])
		if(!holding)
			return TOPIC_HANDLED
		if (valve_open)
			valve_open = 0
		if(istype(holding, /obj/item/tank))
			holding.manipulated_by = user.real_name
		holding.dropInto(loc)
		holding = null
		update_icon()
		. = TOPIC_REFRESH

	else if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10 ATM, release_pressure+diff)
		else
			release_pressure = max(0.1 ATM, release_pressure+diff)
		. = TOPIC_REFRESH

	else if (href_list["relabel"])
		if (!can_label)
			return 0
		var/list/colors = list(
			"\[N2O\]" =       "redws",
			"\[N2\]" =        "red",
			"\[O2\]" =        "blue",
			"\[CO2\]" =       "black",
			"\[H2\]" =        "purple",
			"\[Air\]" =       "grey",
			"\[CAUTION\]" =   "yellow",
			"\[Explosive\]" = "orange"
		)
		var/label = input(user, "Choose canister label", "Gas canister") as null|anything in colors
		if (label && CanUseTopic(user, state))
			canister_color = colors[label]
			icon_state = colors[label]
			SetName("canister: [label]")
		update_icon()
		. = TOPIC_REFRESH

/obj/machinery/portable_atmospherics/canister/CanUseTopic()
	if(destroyed)
		return STATUS_CLOSE
	return ..()

/obj/machinery/portable_atmospherics/canister/oxygen/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/oxygen, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/hydrogen/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/hydrogen, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/Initialize()
	. = ..()
	air_contents.temperature = 80
	update_icon()

/obj/machinery/portable_atmospherics/canister/sleeping_agent/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/nitrous_oxide, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/nitrogen/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/nitrogen, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled/Initialize()
	. = ..()
	air_contents.temperature = 80
	update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/carbon_dioxide, MolesForPressure())
	update_icon()


/obj/machinery/portable_atmospherics/canister/air/Initialize()
	. = ..()
	var/list/air_mix = StandardAirMix()
	air_contents.adjust_multi(/decl/material/gas/oxygen, air_mix[/decl/material/gas/oxygen], /decl/material/gas/nitrogen, air_mix[/decl/material/gas/nitrogen])
	update_icon()


// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/nitrogen, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/carbon_dioxide, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/hydrogen/engine_setup/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/hydrogen, MolesForPressure())
	update_icon()

// Spawn debug tanks.
/obj/machinery/portable_atmospherics/canister/helium
	name           = "helium canister"
	icon_state     = "black"
	canister_color = "black"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/helium/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/helium, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/methyl_bromide
	name           = "\improper CH3Br canister"
	icon_state     = "black"
	canister_color = "black"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/methyl_bromide/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/methyl_bromide, MolesForPressure())
	update_icon()

/obj/machinery/portable_atmospherics/canister/chlorine
	name           = "chlorine canister"
	icon_state     = "black"
	canister_color = "black"
	can_label      = FALSE

/obj/machinery/portable_atmospherics/canister/chlorine/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/gas/chlorine, MolesForPressure())
	update_icon()
// End debug tanks.
