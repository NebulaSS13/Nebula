/datum/forensics/trace_dna
	name = "trace DNA"
	spot_skill = null

/datum/forensics/trace_dna/add_from_atom(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.isSynthetic())
		return
	if(istype(M.dna))
		add_data(M.dna.unique_enzymes)