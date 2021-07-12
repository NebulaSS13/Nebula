/decl/cultural_info
	var/name
	var/desc_type
	var/description
	var/economic_power = 1
	var/language
	var/name_language
	var/default_language
	var/list/additional_langs
	var/list/secondary_langs
	var/category
	var/subversive_potential = 0
	var/hidden
	var/hidden_from_codex
	var/list/qualifications

/decl/cultural_info/New()

	if(!default_language)
		default_language = language

	if(!name_language && default_language)
		name_language = default_language

	// Remove any overlap for the sake of presentation.
	if(LAZYLEN(additional_langs))
		additional_langs -= language
		additional_langs -= name_language
		additional_langs -= default_language
		UNSETEMPTY(additional_langs)

	if(LAZYLEN(secondary_langs))
		secondary_langs -= language
		secondary_langs -= name_language
		secondary_langs -= default_language
		if(LAZYLEN(additional_langs))
			secondary_langs -= additional_langs
		UNSETEMPTY(secondary_langs)

	..()

/decl/cultural_info/proc/get_random_name(var/mob/M, var/gender)
	var/decl/language/_language
	if(name_language)
		_language = GET_DECL(name_language)
	else if(default_language)
		_language = GET_DECL(default_language)
	else if(language)
		_language = GET_DECL(language)
	if(_language)
		return _language.get_random_name(gender)
	return capitalize(pick(gender==FEMALE ? global.first_names_female : global.first_names_male)) + " " + capitalize(pick(global.last_names))

/decl/cultural_info/proc/sanitize_name(var/new_name)
	return sanitizeName(new_name)

/decl/cultural_info/proc/get_description(var/verbose = TRUE)
	LAZYSET(., "details", jointext(get_text_details(), "<br>"))
	if(verbose || length(get_text_body()) <= 50)
		LAZYSET(., "body", get_text_body())
	else
		LAZYSET(., "body", "[copytext(get_text_body(), 1, 44)] <small>\[...\]</small>")

/decl/cultural_info/proc/get_text_body()
	return description

/decl/cultural_info/proc/get_text_details()
	. = list()
	var/list/spoken_langs = get_spoken_languages()
	if(LAZYLEN(spoken_langs))
		var/list/spoken_lang_names = list()
		for(var/thing in spoken_langs)
			var/decl/language/lang = GET_DECL(thing)
			spoken_lang_names |= lang.name
		. += "<b>Language(s):</b> [english_list(spoken_lang_names)]."
	if(LAZYLEN(secondary_langs))
		var/list/secondary_lang_names = list()
		for(var/thing in secondary_langs)
			var/decl/language/lang = GET_DECL(thing)
			secondary_lang_names |= lang.name
		. += "<b>Optional language(s):</b> [english_list(secondary_lang_names)]."
	if(!isnull(economic_power))
		. += "<b>Economic power:</b> [round(100 * economic_power)]%"

/decl/cultural_info/proc/get_spoken_languages()
	. = list()
	if(language)                  . |= language
	if(default_language)          . |= default_language
	if(LAZYLEN(additional_langs)) . |= additional_langs

/decl/cultural_info/proc/get_formal_name_suffix()
	return

/decl/cultural_info/proc/get_formal_name_prefix()
	return

/decl/cultural_info/proc/get_qualifications()
	return qualifications

/decl/cultural_info/proc/get_possible_personal_goals(var/department_types)
	return
