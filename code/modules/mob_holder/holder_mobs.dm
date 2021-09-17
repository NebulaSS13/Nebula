/mob/proc/get_holder_icon()
	return icon

/mob/proc/get_holder_color()
	return color

/mob/living/carbon/human/get_holder_icon()
	return species.holder_icon || ..()

/mob/living/carbon/human/get_holder_color()
	return species.get_holder_color(src)

//Mob procs for scooping up
/mob/living/proc/get_scooped(var/mob/living/carbon/human/grabber, var/self_grab)
	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src))

	if(self_grab)
		if(!grabber.equip_to_slot_if_possible(H, slot_back_str, del_on_fail=0, disable_warning=1))
			to_chat(src, "<span class='warning'>You can't climb onto [grabber]!</span>")
			return

		to_chat(grabber, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(src, "<span class='notice'>You climb up onto \the [grabber]!</span>")
	else
		if(!grabber.put_in_hands(H))
			to_chat(grabber, "<span class='warning'>Your hands are full!</span>")
			return

		to_chat(grabber, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [grabber] scoops you up!</span>")

	src.forceMove(H)

	grabber.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/mob/living/attack_hand(mob/user)

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable && hattable.hat)
		hattable.hat.forceMove(get_turf(src))
		user.put_in_hands(hattable.hat)
		user.visible_message(SPAN_DANGER("\The [user] removes \the [src]'s [hattable.hat]!"))
		hattable.hat = null
		update_icon()
		return TRUE

	if(ishuman(user))
		var/mob/living/carbon/H = user
		if(H.a_intent == I_GRAB && scoop_check(user))
			get_scooped(user, FALSE)
			return TRUE

	. = ..()

/mob/living/proc/scoop_check(var/mob/living/scooper)
	. = TRUE

/mob/living/carbon/human/scoop_check(var/mob/living/scooper)
	. = ..() && scooper.mob_size > src.mob_size
