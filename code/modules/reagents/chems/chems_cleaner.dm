
/decl/material/cleaner
	name = "spray cleaner"
	lore_text = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	color = "#a5f0ee"
	touch_met = 50
	value = 0.15 // shelf price of bug spray per ml, cleaner in general is too cheap

/decl/material/cleaner/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.clean_blood()

/decl/material/cleaner/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
			if(S.wet > 1)
				S.unwet_floor(FALSE)
		T.clean_blood()
		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

/decl/material/cleaner/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.wear_mask)
		if(M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(H.shoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)
		else
			H.clean_blood(1)
			return
	M.clean_blood()
