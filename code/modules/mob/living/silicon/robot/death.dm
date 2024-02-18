/mob/living/silicon/robot/dust(do_gibs)
	. = ..()
	if(.)
		clear_brain()

/mob/living/silicon/robot/get_death_message(gibbed)
	return "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."

/mob/living/silicon/robot/death(gibbed)
	. = ..()
	if(.)
		if(module)
			for(var/obj/item/gripper/G in module.equipment)
				G.drop_gripped_item()
		locked = 0
		remove_robot_verbs()
