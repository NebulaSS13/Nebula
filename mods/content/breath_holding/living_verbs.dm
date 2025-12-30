/mob/living/proc/hold_breath()
	set name = "Hold Breath"
	set desc = "Hold your breath, or stop holding your breath."
	set category = "IC"
	set src = usr
	if(!need_breathe())
		return
	var/obj/item/organ/internal/lungs/lungs = get_organ(get_bodytype().breathing_organ, /obj/item/organ/internal/lungs)
	return lungs?.hold_breath()