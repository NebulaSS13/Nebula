/decl/mob_controller_stance/fleeing
	name = "fleeing"
	stance_can_flee = FALSE

/decl/mob_controller_stance/fleeing/on_body_life(mob/living/body, datum/mob_controller/controller)
	. = ..()

	if(!(. = ..()))
		return

	controller.turns_since_flee_scan++
	if(controller.turns_since_flee_scan < 10)
		return

	controller.turns_since_flee_scan = 0
	var/atom/flee_target = controller.get_flee_target()
	if(isnull(flee_target) || !(flee_target in view(body)))
		controller.set_stance(/decl/mob_controller_stance/idle)
		return

	controller.startle()
	controller.stop_wandering()
	var/static/datum/automove_metadata/_passive_flee_metadata = new(
		_avoid_target = TRUE,
		_acceptable_distance = 6
	)
	body.set_moving_quickly()
	body.start_automove(flee_target, metadata = _passive_flee_metadata)
	return TRUE
