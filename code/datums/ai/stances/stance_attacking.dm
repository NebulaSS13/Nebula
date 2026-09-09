/decl/mob_controller_stance/attack
	name = "attacking a target"

/decl/mob_controller_stance/attack/on_body_life(mob/living/body, datum/mob_controller/controller)

	if(!(. = ..()))
		return

	// Can't see or find out target, we shouldn't be in this stance anymore.
	if(controller.check_lost_target())
		if(controller.ai_flags & AI_FLAG_ALERTS)
			controller.set_stance(/decl/mob_controller_stance/alert)
		else
			controller.set_stance(/decl/mob_controller_stance/idle)
		return FALSE

	// We are eepy...
	if((controller.ai_flags & AI_FLAG_TIRES) && world.time > controller.stance_changed_time + 25 SECONDS)
		body.custom_emote(VISIBLE_MESSAGE, "is worn out and needs to rest." )
		controller.set_stance(/decl/mob_controller_stance/tired)
		return FALSE

	// We moved too recently.
	if(world.time < body.next_move)
		return FALSE

	return try_attack_target(body, controller)

/decl/mob_controller_stance/attack/resume_activity(mob/living/body, datum/mob_controller/controller)
	try_attack_target(body, controller)

/decl/mob_controller_stance/attack/proc/try_attack_target(mob/living/body, datum/mob_controller/controller)
	// If we can't attack our target, find another one.
	var/atom/target = controller.get_target()
	if(!istype(target) || !controller.is_attackable(target))
		controller.lose_target()
		return FALSE

	body.face_atom(target)
	switch(controller.in_attack_position(target))

		// Move towards our target and smash anything in our way.
		if(ATTACK_POSITION_TOO_FAR)
			if(controller.ai_flags & AI_FLAG_DESTROYER)
				controller.destroy_surroundings(target)
			controller.move_to_attack(target)
			return FALSE

		// We are in position to attack - go ahead and do it.
		if(ATTACK_POSITION_IDEAL)
			controller.try_attack(target)
			return FALSE

	// We are still moving; don't do anything yet.
	return FALSE
