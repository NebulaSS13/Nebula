/decl/lawset
	var/name = "Unknown Laws"
	var/law_header = "Prime Directives"
	var/list/laws
	var/selectable = TRUE

/decl/lawset/Initialize()
	. = ..()
	for(var/i = 1 to length(laws))
		laws[i] = new /datum/law(laws[i], i)

/decl/lawset/proc/get_all_laws()
	return laws?.Copy() || list()

/decl/lawset/proc/get_initial_lawset()
	var/datum/lawset/custom_laws = new()
	for(var/datum/law/law in laws)
		custom_laws.add_inherent_law(law.law_text, law.law_priority)
	return custom_laws
