/obj/item/paper/talisman
	info = "<center><img src='talisman.png'></center><br/><br/>"
	var/imbue = null

/obj/item/paper/talisman/update_contents_overlays()
	add_overlay(overlay_image('icons/obj/bureaucracy.dmi', icon_state = "paper_talisman", flags = RESET_COLOR))

/obj/item/paper/talisman/attack_self(var/mob/user)
	if(iscultist(user))
		to_chat(user, "Attack your target to use this talisman.")
	else
		to_chat(user, "You see strange symbols on the paper. Are they supposed to mean something?")

/obj/item/paper/talisman/attack(var/mob/living/M, var/mob/living/user)
	return

/obj/item/paper/talisman/stun/attack_self(var/mob/user)
	if(iscultist(user))
		to_chat(user, "This is a stun talisman.")
	return ..()

/obj/item/paper/talisman/stun/attack(var/mob/living/M, var/mob/living/user)
	if(!iscultist(user))
		return
	user.say("Dream Sign: Evil Sealing Talisman!") //TODO: never change this shit
	var/obj/item/nullrod/nrod = locate() in M
	if(nrod)
		user.visible_message(SPAN_DANGER("\The [user] invokes \the [src] at [M], but they are unaffected."), SPAN_DANGER("You invoke \the [src] at [M], but they are unaffected."))
		return
	else
		user.visible_message(SPAN_DANGER("\The [user] invokes \the [src] at [M]."), SPAN_DANGER("You invoke \the [src] at [M]."))

	if(issilicon(M))
		SET_STATUS_MAX(M, STAT_WEAK, 15)
		SET_STATUS_MAX(M, STAT_SILENCE, 15)
	else if(iscarbon(M))
		var/mob/living/carbon/C = M
		SET_STATUS_MAX(C, STAT_WEAK, 20)
		SET_STATUS_MAX(C, STAT_STUN, 20)
		SET_STATUS_MAX(C, STAT_SILENCE, 20)
	admin_attack_log(user, M, "Used a stun talisman.", "Was victim of a stun talisman.", "used a stun talisman on")
	user.try_unequip(src)
	qdel(src)

/obj/item/paper/talisman/emp/attack_self(var/mob/user)
	if(iscultist(user))
		to_chat(user, "This is an emp talisman.")
	..()

/obj/item/paper/talisman/emp/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!iscultist(user))
		return
	if(!proximity)
		return
	user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	user.visible_message(SPAN_DANGER("\The [user] invokes \the [src] at [target]."), SPAN_DANGER("You invoke \the [src] at [target]."))
	target.emp_act(1)
	user.try_unequip(src)
	qdel(src)
