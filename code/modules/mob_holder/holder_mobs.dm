/mob/proc/get_holder_icon()
	return icon

/mob/proc/get_holder_color()
	return color

/mob/living/human/get_holder_icon()
	return species.holder_icon || ..()

/mob/living/human/get_holder_color()
	return species.get_holder_color(src)

//Mob procs for scooping up
/mob/living/proc/get_scooped(var/mob/living/target, var/mob/living/initiator)

	if(!holder_type || buckled || LAZYLEN(pinned))
		return FALSE

	if(initiator.incapacitated())
		return FALSE

	var/obj/item/holder/H = new holder_type(get_turf(src))
	H.w_class = get_object_size()
	if(initiator == src)
		if(!target.equip_to_slot_if_possible(H, slot_back_str, del_on_fail=0, disable_warning=1))
			to_chat(initiator, "<span class='warning'>You can't climb onto [target]!</span>")
			return
		to_chat(target, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(initiator, "<span class='notice'>You climb up onto \the [target]!</span>")
	else
		if(!target.put_in_hands(H))
			to_chat(initiator, "<span class='warning'>Your hands are full!</span>")
			return

		to_chat(initiator, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [initiator] scoops you up!</span>")

	forceMove(H)
	reset_offsets(0)

	target.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/mob/living/proc/scoop_check(var/mob/living/scooper)
	if(!isliving(scooper) || scooper == src || scooper.current_posture.prone)
		return FALSE
	if(QDELETED(scooper) || QDELETED(src))
		return FALSE
	if(istype(loc, /obj/item/holder))
		if(loc.CanUseTopicPhysical(scooper) != STATUS_INTERACTIVE)
			return FALSE
	else if(!CanPhysicallyInteract(scooper))
		return FALSE
	return !!holder_type && scooper.mob_size > src.mob_size
