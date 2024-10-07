/decl/ability/deity/veil_of_shadows
	name = "Veil of Shadows"
	desc = "Become intangable, invisible. Like a ghost."
	cooldown_time = 40 SECONDS
	invocation_type = SpI_EMOTE
	invocation = "flickers out of existance"
	school = "Divine"
	requires_wizard_garb = FALSE
	duration = 100
	ability_icon_state = "wiz_statue"
	var/timer_id
	var/light_steps = 4

/decl/ability/deity/veil_of_shadows/choose_targets()
	if(!timer_id && ishuman(holder))
		return list(holder)
	. = null

/decl/ability/deity/veil_of_shadows/cast(var/list/targets, var/mob/user)
	var/mob/living/human/H = user
	H.AddMovementHandler(/datum/movement_handler/mob/incorporeal)
	if(H.add_cloaking_source(src))
		H.visible_message(SPAN_WARNING("\The [H] shrinks from view!"))
	events_repository.register(/decl/observ/moved, H,src,PROC_REF(check_light))
	timer_id = addtimer(CALLBACK(src,PROC_REF(cancel_veil)),duration, TIMER_STOPPABLE)

/decl/ability/deity/veil_of_shadows/proc/cancel_veil()
	var/mob/living/human/H = holder
	H.RemoveMovementHandler(/datum/movement_handler/mob/incorporeal)
	deltimer(timer_id)
	timer_id = null
	var/turf/T = get_turf(H)
	if(T.get_lumcount() > 0.1) //If we're somewhere somewhat shadowy we can stay invis as long as we stand still
		drop_cloak()
	else
		events_repository.unregister(/decl/observ/moved, H,src)
		events_repository.register(/decl/observ/moved, H,src,PROC_REF(drop_cloak))

/decl/ability/deity/veil_of_shadows/proc/drop_cloak()
	var/mob/living/human/H = holder
	if(H.remove_cloaking_source(src))
		H.visible_message(SPAN_NOTICE("\The [H] appears from nowhere!"))
	events_repository.unregister(/decl/observ/moved, H,src)

/decl/ability/deity/veil_of_shadows/proc/check_light()
	if(light_steps)
		light_steps--
		return
	light_steps = initial(light_steps)
	for(var/obj/machinery/light/light in view(1,holder))
		light.flicker(20)

/decl/ability/deity/veil_of_shadows/Destroy()
	deltimer(timer_id)
	cancel_veil()
	.= ..()