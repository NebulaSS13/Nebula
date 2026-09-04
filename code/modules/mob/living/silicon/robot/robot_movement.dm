/mob/living/silicon/robot/has_non_slip_footing(obj/item/shoes)
	return module?.has_nonslip_feet

/mob/living/silicon/robot/has_magnetised_footing(obj/item/shoes)
	return module?.has_magnetic_feet

/mob/living/silicon/robot/get_jetpack()
	return locate(/obj/item/tank/jetpack) in module?.equipment

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/get_movement_delay(var/travel_dir)
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed

	// Gross, todo slowdown for robots
	if(istype(get_active_held_item(), /obj/item/borg/combat/mobility))
		tally-=3

	return tally+get_config_value(/decl/config/num/movement_robot)
