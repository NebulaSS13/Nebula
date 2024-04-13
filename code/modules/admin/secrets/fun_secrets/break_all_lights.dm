/datum/admin_secret_item/fun_secret/break_all_lights
	name = "Break All Lights"

/datum/admin_secret_item/fun_secret/break_all_lights/execute(var/mob/user)
	. = ..()
	if(.)
		for(var/obj/machinery/power/apc/apc in SSmachines.machinery)
			apc.overload_lighting()
			CHECK_TICK
