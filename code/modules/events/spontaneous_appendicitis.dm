/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/human/H in shuffle(global.living_mob_list_))
		if(H.client && H.stat != DEAD)
			var/obj/item/organ/internal/appendix/A = H.get_organ(BP_APPENDIX, /obj/item/organ/internal/appendix)
			if(!istype(A) || (A && A.inflamed))
				continue
			A.inflamed = 1
			A.update_icon()
			break
