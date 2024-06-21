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

/obj/item/paper/talisman/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/paper/talisman/stun/attack_self(var/mob/user)
	if(iscultist(user))
		to_chat(user, "This is a stun talisman.")
	return ..()

/obj/item/paper/talisman/stun/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(!iscultist(user))
		return FALSE

	user.say("Dream Sign: Evil Sealing Talisman!") //TODO: never change this shit
	var/obj/item/nullrod/nrod = locate() in target
	if(nrod)
		user.visible_message(
			SPAN_DANGER("\The [user] invokes \the [src] at [target], but they are unaffected."), 
			SPAN_DANGER("You invoke \the [src] at [target], but they are unaffected.")
		)
		return TRUE

	user.visible_message(SPAN_DANGER("\The [user] invokes \the [src] at [target]."), SPAN_DANGER("You invoke \the [src] at [target]."))
	if(isliving(target))
		if(issilicon(target))
			SET_STATUS_MAX(target, STAT_WEAK, 15)
			SET_STATUS_MAX(target, STAT_SILENCE, 15)
		else
			SET_STATUS_MAX(target, STAT_WEAK, 20)
			SET_STATUS_MAX(target, STAT_STUN, 20)
			SET_STATUS_MAX(target, STAT_SILENCE, 20)
	admin_attack_log(user, target, "Used a stun talisman.", "Was victim of a stun talisman.", "used a stun talisman on")
	user.try_unequip(src)
	qdel(src)
	return TRUE


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
