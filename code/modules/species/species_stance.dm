/decl/species
	var/list/foot_tags = list(BP_L_FOOT, BP_R_FOOT)
	var/list/leg_tags = list(BP_L_LEG, BP_R_LEG)
	var/list/stance_tags

/decl/species/proc/get_stance_tags()
	if(isnull(stance_tags))
		stance_tags = list()
		if(length(foot_tags))
			stance_tags |= foot_tags
		if(length(leg_tags))
			stance_tags |= leg_tags

/decl/species/proc/handle_stance_damage_prone(var/mob/living/mob, var/obj/item/organ/external/affected)
	if(affected.organ_tag in foot_tags)
		if(BP_IS_PROSTHETIC(affected))
			to_chat(mob, SPAN_WARNING("You lose your footing as your [affected.name] [pick("twitches", "shudders")]!"))
		else
			to_chat(mob, SPAN_WARNING("You lose your footing as your [affected.name] spasms!"))
	else if(affected.organ_tag in leg_tags)
		if(BP_IS_PROSTHETIC(affected))
			to_chat(mob, SPAN_WARNING("You lose your balance as [affected.name] [pick("malfunctions", "freezes","shudders")]!"))
		else
			to_chat(mob, SPAN_WARNING("Your [affected.name] buckles from the shock!"))
	else
		return FALSE
	SET_STATUS_MAX(mob, STAT_WEAK, 4)
	return TRUE
