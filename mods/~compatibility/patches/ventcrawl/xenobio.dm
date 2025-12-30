/mob/living/slime/Initialize(mapload, var/_stype = /decl/slime_colour/grey)
	. = ..()
	verbs += /mob/living/proc/ventcrawl

/mob/living/slime/can_ventcrawl()
	if(feeding_on)
		to_chat(src, SPAN_WARNING("You cannot ventcrawl while feeding."))
		return FALSE
	. = ..()