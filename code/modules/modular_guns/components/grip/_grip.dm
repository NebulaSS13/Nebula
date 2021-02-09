/obj/item/firearm_component/grip
	name = "grip"
	desc = "A textured grip meant for some kind of firearm."
	icon_state = "world-grip"
	firearm_component_category = FIREARM_COMPONENT_GRIP

/obj/item/firearm_component/grip/proc/is_secured()
	return FALSE

/obj/item/firearm_component/grip/proc/get_network()
	return

/obj/item/firearm_component/grip/proc/get_authorized_mode(var/index)
	return ALWAYS_AUTHORIZED

/obj/item/firearm_component/grip/proc/authorize(var/mode, var/authorized, var/by)
	return FALSE
