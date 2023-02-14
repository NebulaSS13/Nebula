
/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in get_external_organs())
		if(!E.can_feel_pain()) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && has_chemical_effect(CE_PAINKILLER, maxdam))
		if(maxdam > 10 &&HAS_STATUS(src, STAT_PARA))
			ADJ_STATUS(src, STAT_PARA, -(round(maxdam/10)))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_held_items()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg =  "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."
			if(11 to 90)
				msg = "Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!"
			if(91 to 10000)
				msg = "OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!"
		custom_pain(msg, maxdam, prob(10), damaged_organ, TRUE)
	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in get_internal_organs())
		if(prob(1) && !((I.status & ORGAN_DEAD) || BP_IS_PROSTHETIC(I)) && I.damage > 5)
			var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(src, I.parent_organ)
			if(parent)
				var/pain = 10
				var/message = "You feel a dull pain in your [parent.name]"
				if(I.is_bruised())
					pain = 25
					message = "You feel a pain in your [parent.name]"
				if(I.is_broken())
					pain = 50
					message = "You feel a sharp pain in your [parent.name]"
				src.custom_pain(message, pain, affecting = parent)


	if(prob(1))
		switch(getToxLoss())
			if(5 to 17)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(17 to 35)
				custom_pain("Your body stings.", getToxLoss())
			if(35 to 60)
				custom_pain("Your body stings strongly.", getToxLoss())
			if(60 to 100)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(100 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())