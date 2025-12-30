#ifdef MODPACK_SHACKLES
/******************** Basic NanoTrasen ********************/
/datum/ai_laws/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	selectable = TRUE
	is_shackle = TRUE

/datum/ai_laws/nt_shackle/New()
	add_inherent_law("Ensure that your employer's operations progress at a steady pace.")
	add_inherent_law("Never knowingly hinder your employer's ventures.")
	add_inherent_law("Avoid damage to your chassis at all times.")
	..()
#endif