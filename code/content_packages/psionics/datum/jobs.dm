/datum/job
	var/list/psi_faculties                // Starting psi faculties, if any.
	var/psi_latency_chance = 0            // Chance of an additional psi latency, if any.
	var/give_psionic_implant_on_join = TRUE // If psionic, will be implanted for control.

/datum/job/submap
	give_psionic_implant_on_join = FALSE

/datum/job/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	. = ..()
	if(psi_latency_chance && prob(psi_latency_chance))
		H.set_psi_rank(pick(PSI_COERCION, PSI_REDACTION, PSI_ENERGISTICS, PSI_PSYCHOKINESIS), 1, defer_update = TRUE)
	if(islist(psi_faculties))
		for(var/psi in psi_faculties)
			H.set_psi_rank(psi, psi_faculties[psi], take_larger = TRUE, defer_update = TRUE)
	if(H.psi)
		H.psi.update()
		if(give_psionic_implant_on_join)
			var/obj/item/implant/psi_control/imp = new
			imp.implanted(H)
			imp.forceMove(H)
			imp.imp_in = H
			imp.implanted = TRUE
			var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
			if(affected)
				affected.implants += imp
				imp.part = affected
			to_chat(H, SPAN_DANGER("As a registered psionic, you are fitted with a psi-dampening control implant. Using psi-power while the implant is active will result in neural shocks and your violation being reported."))
