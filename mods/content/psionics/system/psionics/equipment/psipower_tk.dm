/obj/item/ability/psionic/telekinesis
	name = "telekinetic grip"
	maintain_cost = 3
	icon_state = "telekinesis"
	var/atom/movable/focus

/obj/item/ability/psionic/telekinesis/Destroy()
	focus = null
	. = ..()

/obj/item/ability/psionic/telekinesis/Process()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(!focus || !isturf(focus.loc) || get_dist(get_turf(focus), get_turf(owner)) > psi?.get_rank(PSI_PSYCHOKINESIS))
		owner.drop_from_inventory(src)
		return
	. = ..()

/obj/item/ability/psionic/telekinesis/proc/set_focus(var/atom/movable/_focus)

	if(!_focus.simulated || !isturf(_focus.loc))
		return FALSE

	var/check_paramount
	if(ismob(_focus))
		var/mob/victim = _focus
		check_paramount = (victim.mob_size >= MOB_SIZE_MEDIUM)
	else if(isobj(_focus))
		var/obj/thing = _focus
		check_paramount = (thing.w_class >= ITEM_SIZE_HUGE)
	else
		return FALSE

	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(_focus.anchored || (check_paramount && psi?.get_rank(PSI_PSYCHOKINESIS) < PSI_RANK_PARAMOUNT))
		focus = _focus
		. = attack_self(owner)
		if(!.)
			to_chat(owner, SPAN_WARNING("\The [_focus] is too hefty for you to get a mind-grip on."))
		qdel(src)
		return FALSE

	focus = _focus
	overlays.Cut()
	var/image/I = image(icon = focus.icon, icon_state = focus.icon_state)
	I.color = focus.color
	I.overlays = focus.overlays
	overlays += I
	return TRUE

/obj/item/ability/psionic/telekinesis/attack_self(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] makes a strange gesture."))
	sparkle()
	return focus.do_simple_ranged_interaction(user)

/obj/item/ability/psionic/telekinesis/afterattack(var/atom/target, var/mob/living/user, var/proximity)

	var/datum/ability_handler/psionics/psi = user.get_ability_handler(/datum/ability_handler/psionics)
	if(!target || !user || (isobj(target) && !isturf(target.loc)) || !psi?.can_use() || !psi?.spend_power(5))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	psi.set_cooldown(5)

	var/user_psi_leech = user.do_psionics_check(5, user)
	if(user_psi_leech)
		to_chat(user, SPAN_WARNING("You reach for \the [target] but your telekinetic power is leeched away by \the [user_psi_leech]..."))
		return

	if(target.do_psionics_check(5, user))
		to_chat(user, SPAN_WARNING("Your telekinetic power skates over \the [target] but cannot get a grip..."))
		return

	var/distance = get_dist(get_turf(user), get_turf(focus ? focus : target))
	if(distance > psi.get_rank(PSI_PSYCHOKINESIS))
		to_chat(user, SPAN_WARNING("Your telekinetic power won't reach that far."))
		return FALSE

	if(target == focus)
		attack_self(user)
	else
		user.visible_message(SPAN_DANGER("\The [user] gestures sharply!"))
		sparkle()
		if(!isturf(target) && istype(focus,/obj/item) && target.Adjacent(focus))
			var/obj/item/I = focus
			var/resolved = target.attackby(I, user, user:get_organ_target())
			if(!resolved && target && I)
				I.afterattack(target,user,1) // for splashing with beakers
		else
			if(!focus.anchored)
				var/user_rank = psi?.get_rank(PSI_PSYCHOKINESIS)
				focus.throw_at(target, user_rank*2, user_rank*10, owner)
			sleep(1)
			sparkle()

/obj/item/ability/psionic/telekinesis/proc/sparkle()
	set waitfor = 0
	if(focus)
		var/obj/effect/overlay/O = new /obj/effect/overlay(get_turf(focus))
		O.name = "sparkles"
		O.anchored = TRUE
		O.density = FALSE
		O.layer = FLY_LAYER
		O.set_dir(pick(global.cardinal))
		O.icon = 'icons/effects/effects.dmi'
		O.icon_state = "nothing"
		flick("empdisable",O)
		sleep(5)
		qdel(O)
