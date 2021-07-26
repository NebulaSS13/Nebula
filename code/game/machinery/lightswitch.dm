// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	anchored = 1.0
	idle_power_usage = 20
	power_channel = LIGHT
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	z_flags = ZMM_MANGLE_PLANES

	var/on = 0
	var/area/connected_area = null
	var/other_area = null

	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	frame_type = /obj/item/frame/button/light_switch
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable
	)
	base_type = /obj/machinery/light_switch/buildable

/obj/machinery/light_switch/buildable
	uncreated_component_parts = null

/obj/machinery/light_switch/on
	on = TRUE

/obj/machinery/light_switch/Initialize()
	..()
	if(other_area)
		connected_area = locate(other_area)
	else
		connected_area = get_area(src)

	if(connected_area && name == initial(name))
		SetName("light switch ([connected_area.name])")
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/light_switch/LateInitialize()
	. = ..()
	connected_area?.set_lightswitch(on)
	update_icon()

/obj/machinery/light_switch/on_update_icon()
	cut_overlays()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		add_overlay(emissive_overlay(icon, "[icon_state]-overlay"))
		set_light(2, 0.25, on ? "#82ff4c" : "#f86060")

/obj/machinery/light_switch/examine(mob/user, distance)
	. = ..()
	if(distance)
		to_chat(user, "A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/proc/set_state(var/newstate)
	if(on != newstate)
		on = newstate
		connected_area.set_lightswitch(on)
		update_icon()

/obj/machinery/light_switch/proc/sync_state()
	if(connected_area && on != connected_area.lightswitch)
		on = connected_area.lightswitch
		update_icon()
		return 1

/obj/machinery/light_switch/interface_interact(mob/user)
	if(CanInteract(user, DefaultTopicState()))
		playsound(src, "switch", 30)
		set_state(!on)
		return TRUE