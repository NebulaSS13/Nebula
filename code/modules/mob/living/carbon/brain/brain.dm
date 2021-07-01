/mob/living/brain
	use_me = FALSE
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	default_emotes = list(
		/decl/emote/audible/alarm,
		/decl/emote/audible/alert,
		/decl/emote/audible/notice,
		/decl/emote/audible/whistle,
		/decl/emote/audible/synth,
		/decl/emote/audible/boop,
		/decl/emote/visible/blink,
		/decl/emote/visible/flash
	)

/mob/living/brain/handle_regular_status_updates()
	. = ..()
	if(health <= 0)
		var/obj/item/organ/holder = loc
		if(istype(holder))
			holder.die()
		death() // slightly redundant due to above

	var/obj/item/brain_interface/container = get_container()
	var/sight_status = (stat == DEAD || !istype(container) || container.emp_damage)
	set_status(STAT_BLIND,   sight_status)
	set_status(STAT_DEAF,    sight_status)
	set_status(STAT_SILENCE, sight_status)

/mob/living/brain/Logout()
	. = ..()
	var/obj/item/brain_interface/container = get_container()
	if(istype(container))
		container.queue_icon_update()

/mob/living/brain/Login()
	. = ..()
	var/obj/item/brain_interface/container = get_container()
	if(istype(container))
		container.queue_icon_update()

/mob/living/brain/proc/get_container()
	. = loc?.loc

/mob/living/brain/can_emote()
	return (istype(get_container(), /obj/item/brain_interface) && ..())

/mob/living/brain/can_use_rig()
	return istype(get_container(), /obj/item/brain_interface)

/mob/living/brain/Destroy()
	ghostize()
	. = ..()

/mob/living/brain/say_understands(var/other)
	. = ishuman(other) || (istype(get_container(), /obj/item/brain_interface) && issilicon(other)) || ..()

/mob/living/brain/UpdateLyingBuckledAndVerbStatus()
	if(istype(loc, /obj/item/brain_interface))
		use_me = 1

/mob/living/brain/isSynthetic()
	return istype(get_container(), /obj/item/brain_interface/robotic)

/mob/living/brain/binarycheck()
	return isSynthetic()

/mob/living/brain/check_has_mouth()
	return FALSE
