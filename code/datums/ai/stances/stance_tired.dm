/decl/mob_controller_stance/tired
	name = "tired"

/decl/mob_controller_stance/tired/on_body_life(mob/living/body, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	if(world.time < controller.stance_changed_time + 10 SECONDS)
		return
	var/atom/target = controller.get_target()
	if(target && (target in controller.get_raw_target_list()))
		controller.set_stance(/decl/mob_controller_stance/attack)
	else
		controller.set_stance(/decl/mob_controller_stance/idle)
