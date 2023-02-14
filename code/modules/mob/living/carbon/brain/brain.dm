//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	mob_sort_value = 7

/mob/living/brain/Initialize()
	create_reagents(1000)
	. = ..()

/mob/living/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	. = ..()

/mob/living/brain/say_understands(mob/speaker, decl/language/speaking)
	return (issilicon(speaker) && istype(container, /obj/item/mmi)) || ishuman(speaker) || ..()

/mob/living/brain/UpdateLyingBuckledAndVerbStatus()
	if(istype(loc, /obj/item/mmi))
		use_me = 1

/mob/living/brain/isSynthetic()
	return istype(loc, /obj/item/mmi/digital) || istype(loc, /obj/item/organ/internal/posibrain)

/mob/living/brain/binarycheck()
	return isSynthetic()

/mob/living/brain/check_has_mouth()
	return 0

/mob/living/brain/can_use_rig()
	return istype(loc, /obj/item/mmi)

/mob/living/carbon/can_emote()
	return (istype(container, /obj/item/mmi) && ..())
