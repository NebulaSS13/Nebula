SUBSYSTEM_DEF(lore)
	name = "Lore"
	init_order = SS_INIT_LORE
	flags = SS_NO_FIRE

	var/list/dreams = list(
		"a familiar face", "voices from all around", "a traitor", "an ally",
		"darkness", "light", "a catastrophe", "a loved one", "warmth", "freezing",
		"a hat", "air", "a blue light", "blood", "healing", "power", "respect",
		"riches", "a crash", "happiness", "pride", "a fall", "water", "flames",
		"ice", "flying", "a voice", "the cold", "the rain", "a creature built completely of stolen flesh",
		"a being made of light", "an old friend", "the tower", "the man with no face",
		"an old home", "right behind you", "standing above you", "someone near by", "a place forgotten"
	)

	var/list/tagged_info =             list()
	var/list/credits_other =           list("ATTACK! ATTACK! ATTACK!")
	var/list/credits_adventure_names = list("QUEST", "FORCE", "ADVENTURE")
	var/list/credits_crew_names =      list("EVERYONE")
	var/list/credits_holidays =        list("HOLIDAY", "VACATION")
	var/list/credits_adjectives =      list("SEXY", "ARCANE", "POLITICALLY MOTIVATED")
	var/list/credits_crew_outcomes =   list("PICKLED", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD")
	var/list/credits_topics =          list("SACRED GEOMETRY","ABSTRACT MATHEMATICS","LOVE","DRUGS","CRIME","PRODUCTIVITY","LAUNDRY")
	var/list/credits_nouns =           list("DIGNITY", "SANITY")

	// Probably not the best subsystem for these, but oh well.
	var/list/languages_by_key
	var/list/languages_by_name

/datum/controller/subsystem/lore/Initialize()

	var/list/all_cultural_decls = decls_repository.get_decls_of_subtype(/decl/cultural_info)
	for(var/ftype in all_cultural_decls)
		var/decl/cultural_info/culture = all_cultural_decls[ftype]
		if(culture.name && culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture

	for(var/jobtype in subtypesof(/datum/job))
		var/datum/job/job = jobtype
		var/title = initial(job.title)
		if(title)
			dreams |= "\an ["\improper [title]"]"
			credits_nouns |= uppertext("the [title]")

	. = ..()

/datum/controller/subsystem/lore/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]

/datum/controller/subsystem/lore/proc/refresh_credits_from_departments()
	var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
	for(var/thing in all_departments)
		var/decl/department/dept = all_departments[thing]
		credits_nouns |= uppertext(dept.name)

/datum/controller/subsystem/lore/proc/get_end_credits_title(var/force)
	if(!GLOB.end_credits_title || force)
		var/list/possible_titles = list()
		refresh_credits_from_departments()
		possible_titles += "THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF", "DESOLATION OF", "DESTRUCTION OF", "CRISIS OF")] [pick(credits_nouns)]"
		possible_titles += "[pick(credits_crew_names)] GETS SERIOUS ABOUT [pick(credits_topics)]"
		possible_titles += "[pick(credits_crew_names)] GETS [pick(credits_crew_outcomes)]"
		possible_titles += "[pick(credits_crew_names)] LEARNS ABOUT [pick(credits_topics)]"
		possible_titles += "A VERY [pick(credits_adjectives)] [pick(credits_holidays)]"
		possible_titles += "[pick(credits_adjectives)] [pick(credits_adventure_names)]"
		possible_titles += "[pick(credits_topics)] [pick(credits_adventure_names)]"
		possible_titles += "THE DAY [uppertext(GLOB.using_map.station_short)] STOOD STILL"
		possible_titles |= credits_other
		GLOB.end_credits_title = pick(possible_titles)
	. = GLOB.end_credits_title

/datum/controller/subsystem/lore/proc/get_language_by_name(var/language_name)
	if(!languages_by_name)
		languages_by_name = list()
		var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
		for(var/thing in language_types)
			var/decl/language/lang = language_types[thing]
			if(lang.name)
				languages_by_name[lang.name] = lang
	. = languages_by_name[language_name]

/datum/controller/subsystem/lore/proc/get_language_by_key(var/language_key)
	if(!languages_by_key)
		languages_by_key = list()
		var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
		for(var/thing in language_types)
			var/decl/language/lang = language_types[thing]
			if(lang.key)
				languages_by_key[lang.key] = lang
	. = languages_by_key[language_key]
