/datum/extension/forensic_evidence
	base_type = /datum/extension/forensic_evidence
	expected_type = /atom
	var/list/evidence // type=instance list of evidence types

/datum/extension/forensic_evidence/Destroy()
	. = ..()
	for(var/T in evidence)
		qdel(evidence[T])
	evidence = null

/datum/extension/forensic_evidence/proc/add_data(evidence_type, data)
	if(!LAZYACCESS(evidence, evidence_type))
		LAZYSET(evidence, evidence_type, new evidence_type)
	var/datum/forensics/F = LAZYACCESS(evidence, evidence_type)
	F.add_data(data)

/datum/extension/forensic_evidence/proc/remove_data(evidence_type)
	if(!LAZYACCESS(evidence, evidence_type))
		return
	var/datum/forensics/F = LAZYACCESS(evidence, evidence_type)
	evidence -= evidence_type
	qdel(F)
	
/datum/extension/forensic_evidence/proc/has_evidence(evidence_type)
	return (evidence_type in evidence)

/datum/extension/forensic_evidence/proc/add_from_atom(evidence_type, atom/A)
	var/datum/forensics/temp = new evidence_type
	temp.add_from_atom(arglist(args.Copy(2)))
	for(var/item in temp.data)
		add_data(evidence_type, item)

/datum/extension/forensic_evidence/proc/check_spotting(mob/detective)
	. = FALSE
	if(get_dist(detective, holder) > (detective.get_skill_value(SKILL_FORENSICS) - SKILL_TRAINED))
		return FALSE
	for(var/T in evidence)
		var/datum/forensics/F = evidence[T]
		if(F.can_spot(detective, holder))
			F.spot_message(detective, holder)
			. |= TRUE