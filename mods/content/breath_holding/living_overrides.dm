// override to make a held breath take priority
/mob/living/get_breath(obj/item/organ/internal/lungs/lungs)
	if(lungs?.holding_breath && lungs.held_breath)
		return lungs.held_breath
	return ..()

// override that prevents getting a new breath if we already have one
/mob/living/obtain_new_breath(obj/item/organ/internal/lungs/lungs)
	if(lungs?.held_breath) // don't ever take a new breath if we have one held
		return null
	. = ..()
	if(lungs?.holding_breath) // hold our current breath
		lungs.held_breath = .

/mob/living/handle_pre_breath(obj/item/organ/internal/lungs/lungs)
	if((. = ..())) // something skipped breathing, so we can't breathe in or out
		return
	if(!lungs) // can't do any of this without lungs
		return
	if(stat != CONSCIOUS && lungs.holding_breath) // if you pass out from holding your breath too long, you should start breathing again
		lungs.holding_breath = FALSE
	// exhale the currently held breath if we're done not holding it anymore
	if(lungs.held_breath && !lungs.holding_breath)
		handle_post_breath(lungs.held_breath)

/mob/living/handle_post_breath(datum/gas_mixture/breath)
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype?.breathing_organ)
		return
	var/obj/item/organ/internal/lungs/lungs = get_organ(root_bodytype.breathing_organ, /obj/item/organ/internal/lungs)
	if(lungs?.holding_breath)
		return // don't exhale if holding a breath
	. = ..() // exhale our held breath
	if(lungs)
		lungs.held_breath = null // clear the old breath

// OVERRIDE: can't sniff while holding your breath
/mob/living/sniff_verb()
	var/obj/item/organ/internal/lungs/breathe_organ = get_organ(get_bodytype().breathing_organ, /obj/item/organ/internal/lungs)
	if(breathe_organ?.holding_breath)
		to_chat(src, SPAN_WARNING("You can't sniff while holding your breath!"))
		return
	return ..()
