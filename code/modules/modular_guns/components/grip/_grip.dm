/obj/item/firearm_component/grip
	name = "pistol grip"
	desc = "A textured grip meant for a handgun."
	icon_state = "world-grip"
	firearm_component_category = FIREARM_COMPONENT_GRIP

/obj/item/firearm_component/grip/long
	name = "rifle grip"

/obj/item/firearm_component/grip/staff
	name = "staff handle"

/obj/item/firearm_component/grip/cannon
	name = "cannon grip"

/obj/item/firearm_component/grip/proc/is_secured()
	return FALSE

/obj/item/firearm_component/grip/proc/get_network()
	return

/obj/item/firearm_component/grip/proc/get_authorized_mode(var/index)
	return ALWAYS_AUTHORIZED

/obj/item/firearm_component/grip/proc/authorize(var/mode, var/authorized, var/by)
	return FALSE
