/datum/ai/human
	name = "human"
	expected_type = /mob/living/carbon/human

/datum/ai/human/do_process(var/time_elapsed)
	var/mob/living/carbon/human/H = body
	if(H.stat != CONSCIOUS)
		return

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.emote(pick("moan","groan"))

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

	if(!H.restrained() && H.shock_stage < 40 && prob(3))
		var/maxdam = 0
		var/obj/item/organ/external/damaged_organ = null
		for(var/obj/item/organ/external/E in H.organs)
			if(!E.can_feel_pain()) continue
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(50)) )
				damaged_organ = E
				maxdam = dam
		var/datum/gender/T = gender_datums[H.get_gender()]
		if(damaged_organ)
			if(damaged_organ.status & ORGAN_BLEEDING)
				H.custom_emote("clutches [T.his] [damaged_organ.name], trying to stop the blood.")
			else if(damaged_organ.status & ORGAN_BROKEN)
				H.custom_emote("holds [T.his] [damaged_organ.name] carefully.")
			else if(damaged_organ.burn_dam > damaged_organ.brute_dam && damaged_organ.organ_tag != BP_HEAD)
				H.custom_emote("blows on [T.his] [damaged_organ.name] carefully.")
			else
				H.custom_emote("rubs [T.his] [damaged_organ.name] carefully.")

		for(var/obj/item/organ/I in H.internal_organs)
			if((I.status & ORGAN_DEAD) || BP_IS_PROSTHETIC(I)) continue
			if(I.damage > 2) if(prob(2))
				var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
				H.custom_emote("clutches [T.his] [parent.name]!")