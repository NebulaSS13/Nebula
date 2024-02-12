/mob/living
	var/immunity 		= 100		//current immune system strength
	var/immunity_norm 	= 100		//it will regenerate to this value

/mob/living/proc/handle_immunity()
	if(status_flags & GODMODE)	return 0	//godmode

	if(immunity > 0.2 * immunity_norm && immunity < immunity_norm)
		immunity = min(immunity + 0.25, immunity_norm)

/mob/living/proc/adjust_immunity(var/amt)
	immunity = clamp(immunity + amt, 0, immunity_norm)

/mob/living/proc/get_immunity()
	var/antibiotic_boost = REAGENT_VOLUME(reagents, /decl/material/liquid/antibiotics) / (REAGENTS_OVERDOSE/2)
	return max(immunity/100 * (1+antibiotic_boost), antibiotic_boost)

/mob/living/proc/immunity_weakness()
	return max(2-get_immunity(), 0)
