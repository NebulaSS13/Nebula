//Spiders in your body
/datum/hallucination/spiderbabies
	min_power = 40

/datum/hallucination/spiderbabies/start()
	. = ..()
	var/list/limbs = holder.get_external_organs()
	if(!LAZYLEN(limbs))
		return
	var/obj/O = pick(limbs)
	to_chat(holder, SPAN_WARNING("You feel something [pick("moving","squirming","skittering")] inside of your [O.name]!"))
