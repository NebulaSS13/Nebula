/decl/mob_controller_stance/returning
	name = "returning to handler"

/decl/mob_controller_stance/returning/on_stance_set(mob/living/body, datum/mob_controller/controller)
	controller.set_target(null)
	controller.stop_wandering()

/decl/mob_controller_stance/returning/on_body_life(mob/living/body, datum/mob_controller/controller)
	if(!(. = ..()))
		return
	var/atom/handler = controller.last_handler?.resolve()
	if(!handler)
		controller.set_stance(/decl/mob_controller_stance/idle)
		return
	if(!body.Adjacent(handler))
		body.start_automove(handler)
		return
	if(body.scoop_check(handler) && body.get_scooped(handler, body, silent = TRUE))
		body.visible_message(SPAN_NOTICE("\The [body] returns to \the [handler]."))
	else
		body.visible_message(SPAN_NOTICE("\The [body] returns to beside \the [handler]."))
	controller.give_held_items_to_handler(handler)
	controller.set_stance(/decl/mob_controller_stance/idle)
