/datum/extension/demolisher/energy
	demolish_sound = "sparks"
	demolish_verb = "slicing through"

/datum/extension/demolisher/energy/try_demolish(mob/user, turf/wall/wall)
	var/obj/item/tool = holder
	if(!tool.is_special_cutting_tool())
		return FALSE
	if(istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = tool
		if(!cutter.slice(user))
			return TRUE
	return ..()

/datum/extension/demolisher/energy/get_demolish_delay(turf/wall/wall)
	return ..() * 0.5
