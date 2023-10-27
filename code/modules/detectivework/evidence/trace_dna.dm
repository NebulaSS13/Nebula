/datum/forensics/trace_dna
	name = "trace DNA"
	spot_skill = null

/datum/forensics/trace_dna/add_from_atom(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.get_bodytype()?.is_robotic)
		return
	var/unique_enzymes = M.get_unique_enzymes()
	if(unique_enzymes)
		add_data(unique_enzymes)