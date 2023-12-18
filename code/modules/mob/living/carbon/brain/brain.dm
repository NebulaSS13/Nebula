//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"
	mob_sort_value = 7

/mob/living/carbon/brain/can_emote()
	return stat == CONSCIOUS && (istype(container, /obj/item/mmi) || istype(loc, /obj/item/organ/internal/posibrain))

/mob/living/carbon/brain/Initialize()
	create_reagents(1000)
	. = ..()

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	. = ..()

/mob/living/carbon/brain/say_understands(mob/speaker, decl/language/speaking)
	return (issilicon(speaker) && (istype(container, /obj/item/mmi) || istype(loc, /obj/item/organ/internal/posibrain))) || ishuman(speaker) || ..()

/mob/living/carbon/brain/UpdateLyingBuckledAndVerbStatus()
	return

/mob/living/carbon/brain/isSynthetic()
	return istype(container, /obj/item/mmi/digital) || istype(loc, /obj/item/organ/internal/posibrain)

/mob/living/carbon/brain/binarycheck()
	return isSynthetic()

/mob/living/carbon/brain/check_has_mouth()
	return 0

