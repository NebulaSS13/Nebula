/decl/interaction_handler/vine_chop
	name = "Chop Down"
	expected_target_type = /obj/effect/vine

/decl/interaction_handler/vine_chop/invoked(atom/target, mob/user)
	var/obj/effect/vine/V = target
	var/obj/item/W = user.get_active_hand()
	if(!istype(W) || !W.edge || W.w_class < ITEM_SIZE_NORMAL)
		to_chat(user, SPAN_WARNING("You need a larger or sharper object for this task!"))
		return
	user.visible_message(SPAN_NOTICE("\The [user] starts chopping down \the [V]."))
	playsound(get_turf(V), W.hitsound, 100, 1)
	var/chop_time = (V.health/W.force) * 0.5 SECONDS
	if(user.skill_check(SKILL_BOTANY, SKILL_ADEPT))
		chop_time *= 0.5
	if(do_after(user, chop_time, V, TRUE))
		user.visible_message(SPAN_NOTICE("[user] chops down \the [V]."))
		playsound(get_turf(V), W.hitsound, 100, 1)
		V.die_off()
