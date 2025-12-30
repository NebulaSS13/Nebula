#define MAX_FIELD_STR 10000
#define MIN_FIELD_STR 1

/obj/machinery/fusion_core
	name = "\improper R-UST Mk. 8 Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machines/power/fusion_core.dmi'
	icon_state = "core0"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = FALSE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOINPUT
	base_type = /obj/machinery/fusion_core
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/initial_id_tag

/obj/machinery/fusion_core/mapped
	anchored = TRUE

/obj/machinery/fusion_core/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)

/obj/machinery/fusion_core/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/fusion_core/Process()
	if(use_power == POWER_USE_ACTIVE)
		if((stat & BROKEN) || !owned_field)
			update_use_power(POWER_USE_IDLE)
		else
			owned_field.handle_tick()

/obj/machinery/fusion_core/update_use_power(new_use_power)
	. = ..()
	if(use_power == POWER_USE_IDLE && owned_field)
		Shutdown()

/obj/machinery/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	update_use_power(POWER_USE_ACTIVE)
	. = 1

/obj/machinery/fusion_core/proc/Shutdown(var/force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.Rupture()
		else
			owned_field.RadiateAll()
		qdel(owned_field)
		owned_field = null

/obj/machinery/fusion_core/proc/AddParticles(var/name, var/quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/fusion_core/bullet_act(var/obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/fusion_core/proc/set_strength(var/value)
	value = clamp(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	change_power_consumption(5 * value, POWER_USE_ACTIVE)
	if(owned_field)
		owned_field.ChangeFieldStrength(value)

/obj/machinery/fusion_core/physical_attack_hand(var/mob/user)
	visible_message(SPAN_NOTICE("\The [user] hugs \the [src] to make it feel better!"))
	Shutdown()
	return TRUE

/obj/machinery/fusion_core/attackby(var/obj/item/used_item, var/mob/user)

	if(owned_field)
		to_chat(user, SPAN_WARNING("Shut \the [src] off first!"))
		return TRUE

	if(IS_MULTITOOL(used_item))
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.get_new_tag(user)
		return TRUE

	else if(IS_WRENCH(used_item))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("\The [user] secures \the [src] to the floor.", 
				"You secure \the [src] to the floor.", 
				"You hear a ratchet."
			)
		else
			user.visible_message("\The [user] unsecures \the [src] from the floor.", 
				"You unsecure \the [src] from the floor.", 
				"You hear a ratchet."
			)
		return TRUE

	return ..()

/obj/machinery/fusion_core/proc/jumpstart(var/field_temperature)
	field_strength = 200 // 3x3, generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE