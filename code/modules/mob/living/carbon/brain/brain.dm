//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/brain
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
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
	var/alert = null
	var/emp_damage = 0//Handles a type of MMI damage
	var/timeofhostdeath = 0

/mob/living/brain/proc/get_container()
	. = loc?.loc

/mob/living/brain/can_emote()
	return (istype(get_container(), /obj/item/mmi) && ..())

/mob/living/brain/can_use_rig()
	return istype(get_container(), /obj/item/mmi)

/mob/living/brain/Initialize()
	create_reagents(1000)
	. = ..()

/mob/living/brain/Destroy()
	ghostize()
	. = ..()

/mob/living/brain/say_understands(var/other)
	. = isslime(other) || ishuman(other) || (istype(get_container(), /obj/item/mmi) && issilicon(other)) || ..()

/mob/living/brain/UpdateLyingBuckledAndVerbStatus()
	if(istype(loc, /obj/item/mmi))
		use_me = 1

/mob/living/brain/isSynthetic()
	return istype(loc, /obj/item/mmi/digital)

/mob/living/brain/binarycheck()
	return isSynthetic()

/mob/living/brain/check_has_mouth()
	return FALSE
