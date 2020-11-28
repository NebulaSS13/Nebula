/datum/forensics/blood_dna
	name = "blood DNA traces"
	spot_skill = SKILL_PROF

/datum/forensics/blood_dna/spot_message(mob/detective, atom/location)
	to_chat(detective, SPAN_NOTICE("You notice faint blood traces on \the [location]."))