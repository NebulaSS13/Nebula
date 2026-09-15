/decl/mob_controller_stance/alert
	name = "alerted"

/decl/mob_controller_stance/alert/on_stance_set(mob/living/body, datum/mob_controller/controller)
	. = ..()
	if(!controller.alert_started_str)
		return
	var/atom/target = controller.get_target()
	if(!istype(target))
		return
	var/alert_str = islist(controller.alert_started_str) ? pick(controller.alert_started_str) : controller.alert_started_str
	body.visible_message(REPLACE_EMOTE_TOKENS(alert_str, body, target))

/decl/mob_controller_stance/alert/on_body_life(mob/living/body, datum/mob_controller/controller)

	if(!(. = ..()))
		return

	var/atom/target = controller.get_target()
	if(!body.can_act() || !target || !(target in controller.get_raw_target_list()))
		controller.alert_period_elapsed(target, FALSE)
		return FALSE

	if(get_dist(body, target) <= controller.alert_threat_range || world.time > controller.stance_changed_time + controller.get_alert_time())
		controller.alert_period_elapsed(target, TRUE)
	else if(controller.alert_threatened_str)
		var/threat_str = islist(controller.alert_threatened_str) ? pick(controller.alert_threatened_str) : controller.alert_threatened_str
		body.visible_message(REPLACE_EMOTE_TOKENS(threat_str, body, target))

	return TRUE

/datum/mob_controller/proc/alert_period_elapsed(atom/target, hostile)
	if(hostile)
		set_stance(/decl/mob_controller_stance/attack)
	else
		set_stance(/decl/mob_controller_stance/idle)
