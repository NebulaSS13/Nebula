/datum/forensics/trace_dna
	name = "trace DNA"
	spot_skill = null

/datum/forensics/trace_dna/add_from_atom(mob/living/human/M)
	if(!istype(M))
		return
	if(M.isSynthetic())
		return
	var/unique_enzymes = M.get_unique_enzymes()
	if(unique_enzymes)
		add_data(unique_enzymes)