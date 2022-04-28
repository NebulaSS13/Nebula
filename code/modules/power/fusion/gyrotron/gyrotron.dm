#define GYRO_POWER 25000

/obj/machinery/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "It is a heavy duty industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	initial_access = list(access_engine)
	use_power = POWER_USE_IDLE
	active_power_usage = GYRO_POWER

	var/initial_id_tag
	var/rate = 3
	var/mega_energy = 1

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver
	)
	base_type = /obj/machinery/emitter/gyrotron

/obj/machinery/emitter/gyrotron/anchored
	anchored = 1
	state = 2

/obj/machinery/emitter/gyrotron/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/emitter/gyrotron/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/emitter/gyrotron/Process()
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/emitter/gyrotron/get_rand_burst_delay()
	return rate*10

/obj/machinery/emitter/gyrotron/get_burst_delay()
	return rate*10

/obj/machinery/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/machinery/emitter/gyrotron/on_update_icon()
	if (active && can_use_power_oneoff(active_power_usage))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/emitter/gyrotron/attackby(var/obj/item/W, var/mob/user)
	if(isMultitool(W))
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.get_new_tag(user)
		return
	return ..()

#undef GYRO_POWER
