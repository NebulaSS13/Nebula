/datum/job/standard/counselor/equip_job(var/mob/living/human/H)
	if(H.mind.role_alt_title == "Counselor")
		psi_faculties = list("[PSI_REDACTION]" = PSI_RANK_OPERANT)
	if(H.mind.role_alt_title == "Mentalist")
		psi_faculties = list("[PSI_COERCION]" = PSI_RANK_OPERANT)
	return ..()

// Counselors can be psions without a control implant
/datum/job/standard/counselor
	give_psionic_implant_on_join = FALSE