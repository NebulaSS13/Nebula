/obj/machinery/atmospherics/unary/engine
	name = "rocket nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	opacity = 1
	density = 1
	atmos_canpass = CANPASS_NEVER
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	var/engine_extension = /datum/extension/ship_engine/gas
	construct_state = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(/obj/item/stock_parts = 8)//don't want too many, let upgraded component shine

	use_power = POWER_USE_OFF
	power_channel = EQUIP
	idle_power_usage = 11600

/obj/machinery/atmospherics/unary/engine/Initialize()
	. = ..()
	update_nearby_tiles(need_rebuild=1)

	set_extension(src, engine_extension, "propellant thruster")

/obj/machinery/atmospherics/unary/engine/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 0

/obj/machinery/atmospherics/unary/engine/Destroy()
	update_nearby_tiles()
	. = ..()

/obj/machinery/atmospherics/unary/engine/power_change()
	. = ..()
	if(stat & NOPOWER)
		update_use_power(POWER_USE_OFF)

/obj/machinery/atmospherics/unary/engine/RefreshParts()
	..()
	var/datum/extension/ship_engine/E = get_extension(src, /datum/extension/ship_engine)
	if(!E)
		return
	//allows them to upgrade the max limit of fuel intake (which only gives diminishing returns) for increase in max thrust but massive reduction in fuel economy
	var/bin_upgrade = 10 * Clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 6)//5 litre per rank
	E.volume_per_burn = bin_upgrade ? initial(E.volume_per_burn) + bin_upgrade : 2 //Penalty missing part: 10% fuel use, no thrust
	E.boot_time = bin_upgrade ? initial(E.boot_time) - bin_upgrade : initial(E.boot_time) * 2
	//energy cost - thb all of this is to limit the use of back up batteries
	var/energy_upgrade = Clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 6)
	E.charge_per_burn = initial(E.charge_per_burn) / energy_upgrade
	change_power_consumption(initial(idle_power_usage) / energy_upgrade, POWER_USE_IDLE)

//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	light_color = "#ed9200"
	anchored = 1

/obj/effect/engine_exhaust/Initialize(mapload, var/ndir, var/flame)
	. = ..(mapload)
	if(flame)
		icon_state = "exhaust"
		if(isturf(loc))
			var/turf/T = loc
			T.hotspot_expose(1000,125)
		set_light(0.5, 1, 4)
	set_dir(ndir)
	QDEL_IN(src, 2 SECONDS)

/obj/machinery/atmospherics/unary/engine/terminal
	base_type = /obj/machinery/atmospherics/unary/engine
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)
