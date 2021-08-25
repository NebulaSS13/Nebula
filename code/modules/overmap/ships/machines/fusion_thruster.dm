/obj/machinery/atmospherics/unary/engine/fusion
	name = "fusion nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."

	base_type = /obj/machinery/atmospherics/unary/engine/fusion
	engine_extension = /datum/extension/ship_engine/gas/fusion

	idle_power_usage = 13600
	var/initial_id_tag
	var/obj/machinery/power/fusion_core/harvest_from

/obj/machinery/atmospherics/unary/engine/fusion/Initialize()
	..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		lanm.set_tag(null, initial_id_tag)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/unary/engine/fusion/LateInitialize()
	find_core()

/obj/machinery/atmospherics/unary/engine/fusion/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/atmospherics/unary/engine/fusion/proc/find_core()
	harvest_from = null
	var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = lanm.get_local_network()

	if(lan)	
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power/fusion_core)
		if(fusion_cores && fusion_cores.len)
			harvest_from = fusion_cores[1]
	return harvest_from

/obj/machinery/atmospherics/unary/engine/fusion/attackby(var/obj/item/thing, var/mob/user)
	if(isMultitool(thing))
		var/datum/extension/local_network_member/lanm = get_extension(src, /datum/extension/local_network_member)
		if(lanm.get_new_tag(user))
			find_core()
		return
	return ..()