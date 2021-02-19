/mob/living/carbon/human/proc/eyeglow()
	set category = "IC"
	set name = "Toggle Eye Glow"
	set desc = "Toggles glowing for eyes."

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	if(istype(head) && !stat)
		head.glowing_eyes = !head.glowing_eyes
		regenerate_icons()
