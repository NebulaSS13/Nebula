/decl/grab/normal/struggle
	name                    = "struggle grab"
	upgrab                  = /decl/grab/normal/aggressive
	downgrab                = /decl/grab/normal/passive
	shift                   = 8
	stop_move               = 1
	reverse_facing          = 0
	point_blank_mult        = 1
	same_tile               = 0
	breakability            = 3
	grab_slowdown           = 0.35
	upgrade_cooldown        = 20
	can_downgrade_on_resist = 0
	grab_icon_state         = "reinforce"
	break_chance_table      = list(5, 20, 30, 80, 100)

/decl/grab/normal/struggle/process_effect(var/obj/item/grab/grab)
	var/mob/living/affecting = grab.get_affecting_mob()
	var/mob/living/assailant = grab.assailant
	if(!affecting)
		return
	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		var/decl/pronouns/assailant_gender = assailant.get_pronouns()
		affecting.visible_message(SPAN_DANGER("\The [affecting] isn't prepared to fight back as [assailant] tightens [assailant_gender.his] grip!"))
		grab.done_struggle = TRUE
		grab.upgrade(TRUE)

/decl/grab/normal/struggle/enter_as_up(var/obj/item/grab/grab)
	var/mob/living/affecting = grab.get_affecting_mob()
	var/mob/living/assailant = grab.assailant
	if(!affecting)
		return
	if(affecting == assailant)
		grab.done_struggle = TRUE
		grab.upgrade(TRUE)
		return

	if(affecting.incapacitated(INCAPACITATION_UNRESISTING) || affecting.a_intent == I_HELP)
		var/decl/pronouns/assailant_gender = assailant.get_pronouns()
		affecting.visible_message(SPAN_DANGER("\The [affecting] isn't prepared to fight back as [assailant] tightens [assailant_gender.his] grip!"))
		grab.done_struggle = TRUE
		grab.upgrade(TRUE)
	else
		affecting.visible_message("<span class='warning'>[affecting] struggles against [assailant]!</span>")
		grab.done_struggle = FALSE
		addtimer(CALLBACK(grab, PROC_REF(handle_resist)), 1 SECOND)
		resolve_struggle(grab)

/decl/grab/normal/struggle/proc/resolve_struggle(var/obj/item/grab/grab)
	set waitfor = FALSE
	if(do_after(grab.assailant, upgrade_cooldown, grab, can_move = 1))
		grab.done_struggle = TRUE
		grab.upgrade(TRUE)
	else
		grab.downgrade()

/decl/grab/normal/struggle/can_upgrade(var/obj/item/grab/grab)
	. = ..() && grab.done_struggle

/decl/grab/normal/struggle/on_hit_disarm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(proximity)
		to_chat(grab.assailant, SPAN_WARNING("Your grip isn't strong enough to pin."))
	return FALSE

/decl/grab/normal/struggle/on_hit_grab(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(proximity)
		to_chat(grab.assailant, SPAN_WARNING("Your grip isn't strong enough to jointlock."))
	return FALSE

/decl/grab/normal/struggle/on_hit_harm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(proximity)
		to_chat(grab.assailant, SPAN_WARNING("Your grip isn't strong enough to dislocate."))
	return FALSE

/decl/grab/normal/struggle/resolve_openhand_attack(var/obj/item/grab/grab)
	return FALSE
