/datum/ai_laws/ascent
	name = "Ascent Lawset"
	law_header = "_=/--=-_"
	selectable = FALSE

/datum/ai_laws/ascent/add_ion_law(law)
	return FALSE

/datum/ai_laws/ascent/New()
	add_inherent_law("Listen to directives from Ascent leadership with precedence given to queens.")
	add_inherent_law("Preserve your own existence.")
	add_inherent_law("Enable and support Ascent activities.")
	..()