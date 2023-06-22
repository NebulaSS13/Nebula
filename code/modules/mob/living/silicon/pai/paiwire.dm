/obj/item/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"
	material = /decl/material/solid/metal/copper
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)
	var/obj/machinery/machine

/obj/item/pai_cable/proc/plugin(obj/machinery/M, mob/user)
	if(istype(M, /obj/machinery/door) || istype(M, /obj/machinery/camera))
		if(!user.try_unequip(src, M))
			return
		user.visible_message("[user] inserts [src] into a data port on [M].", "You insert [src] into a data port on [M].", "You hear the satisfying click of a wire jack fastening into place.")
		machine = M
		return TRUE
	else
		user.visible_message("[user] dumbly fumbles to find a place on [M] to plug in [src].", "There aren't any ports on [M] that match the jack belonging to [src].")
		return TRUE

/obj/item/pai_cable/resolve_attackby(obj/machinery/M, mob/user)
	if(istype(M))
		return plugin(M, user)
	return ..()