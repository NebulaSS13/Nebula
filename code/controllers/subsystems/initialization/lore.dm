SUBSYSTEM_DEF(lore)
	name = "Lore"
	init_order = SS_INIT_LORE
	flags = SS_NO_FIRE

	var/list/cultural_info_by_name =      list()
	var/list/cultural_info_by_path =      list()
	var/list/tagged_info =                list()
	var/list/dreams = list(
		"a familiar face", "voices from all around", "a traitor", "an ally",
		"darkness", "light", "a catastrophe", "a loved one", "warmth", "freezing",
		"a hat", "air", "a blue light", "blood", "healing", "power", "respect",
		"riches", "a crash", "happiness", "pride", "a fall", "water", "flames",
		"ice", "flying", "a voice", "the cold", "the rain", "a creature built completely of stolen flesh",
		"a being made of light", "an old friend", "the tower", "the man with no face",
		"an old home", "right behind you", "standing above you", "someone near by", "a place forgotten"
	)

	var/list/credits_other =           list("ATTACK! ATTACK! ATTACK!")
	var/list/credits_adventure_names = list("QUEST", "FORCE", "ADVENTURE")
	var/list/credits_crew_names =      list("EVERYONE")
	var/list/credits_holidays =        list("HOLIDAY", "VACATION")
	var/list/credits_adjectives =      list("SEXY", "ARCANE", "POLITICALLY MOTIVATED")
	var/list/credits_crew_outcomes =   list("PICKLED", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD")
	var/list/credits_topics =          list("SACRED GEOMETRY","ABSTRACT MATHEMATICS","LOVE","DRUGS","CRIME","PRODUCTIVITY","LAUNDRY")
	var/list/credits_nouns =           list("DIGNITY", "SANITY")

/datum/controller/subsystem/lore/Initialize()

	for(var/ftype in subtypesof(/decl/cultural_info))
		var/decl/cultural_info/culture = ftype
		if(!initial(culture.name))
			continue
		culture = new culture
		if(cultural_info_by_name[culture.name])
			crash_with("Duplicate cultural datum ID - [culture.name] - [ftype]")
		cultural_info_by_name[culture.name] = culture
		cultural_info_by_path[ftype] = culture
		if(culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture


	for(var/jobtype in subtypesof(/datum/job))
		var/datum/job/job = jobtype
		var/title = initial(job.title)
		if(title)
			dreams |= "a [title]"
			credits_nouns |= uppertext("the [title]")

	var/list/all_content_packages = decls_repository.get_decls_of_subtype(/decl/content_package_strings)
	for(var/package in all_content_packages)
		var/decl/content_package_strings/manifest = all_content_packages[package]
		if(length(manifest.worths))
			for(var/thing in manifest.worths)
				worths[thing] = max(manifest.worths[thing], worths[thing])
		if(length(manifest.dreams))
			dreams |= manifest.dreams
		if(length(manifest.credits_other))
			credits_other |= manifest.credits_other
		if(length(manifest.credits_adventure_names))
			credits_adventure_names |= manifest.credits_adventure_names
		if(length(manifest.credits_crew_names))
			credits_crew_names |= manifest.credits_crew_names
		if(length(manifest.credits_holidays))
			credits_holidays |= manifest.credits_holidays
		if(length(manifest.credits_adjectives))
			credits_adjectives |= manifest.credits_adjectives
		if(length(manifest.credits_crew_outcomes))
			credits_crew_outcomes |= manifest.credits_crew_outcomes
		if(length(manifest.credits_topics))
			credits_topics |= manifest.credits_topics
		if(length(manifest.credits_nouns))
			credits_nouns |= manifest.credits_nouns

	. = ..()

/datum/controller/subsystem/lore/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]

/datum/controller/subsystem/lore/proc/refresh_credits_from_departments()
	for(var/thing in SSdepartments.departments)
		var/datum/department/dept = SSdepartments.departments[thing]
		if(dept.title)
			credits_nouns |= uppertext(dept.title)

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

/datum/controller/subsystem/lore/proc/get_culture(var/culture_ident)
	return cultural_info_by_name[culture_ident] ? cultural_info_by_name[culture_ident] : cultural_info_by_path[culture_ident]
