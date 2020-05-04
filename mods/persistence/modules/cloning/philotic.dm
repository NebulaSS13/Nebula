/mob/living/carbon/human/getBrainLoss()
	var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
	if(sponge && !(sponge.status & ORGAN_DEAD) && mind.philotic_damage > 100 && prob(20))
		to_chat(src, SPAN_WARNING("The will to live slips free in a final breath."))
		sponge.status |= ORGAN_DEAD
	return ..()
	