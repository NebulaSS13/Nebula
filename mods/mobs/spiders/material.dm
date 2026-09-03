/decl/material/gas/methyl_bromide/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/human/H = M
	for(var/obj/item/organ/external/E in H.get_external_organs())
		for(var/obj/effect/spider/spider in E.implants)
			if(prob(25))
				E.implants -= spider
				H.visible_message(SPAN_NOTICE("The dying form of \a [spider] emerges from inside \the [M]'s [E.name]."))
				qdel(spider)
				break
