/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module && module.no_slip)
		return 0
	..(prob_slip)

/mob/living/silicon/robot/Check_Shoegrip()
	if(module && module.no_slip)
		return 1
	return 0

/mob/living/silicon/robot/get_jetpack()
	return locate(/obj/item/tank/jetpack) in module?.equipment

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/get_movement_delay(var/travel_dir)
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3

	return tally+get_config_value(/decl/config/num/movement_robot)