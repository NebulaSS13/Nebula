/mob/living
	var/default_language

/mob/living/proc/set_default_language(var/decl/language/language)

	if(ispath(language, /decl/language))
		language = GET_DECL(language)

	if(species_language)
		var/decl/language/species_lang = GET_DECL(species_language)
		if(only_species_language && language != species_lang)
			to_chat(src, "<span class='notice'>You can only speak your species language, [src.species_language].</span>")
			return 0
		if(language == species_lang)
			to_chat(src, "<span class='notice'>You will now speak your standard default language, [language.name], if you do not specify a language when speaking.</span>")
			default_language = species_language
			return 1

	if(language)
		if(!can_speak(language))
			to_chat(src, "<span class='notice'>You are unable to speak that language.</span>")
			return
		to_chat(src, "<span class='notice'>You will now speak [language.name] if you do not specify a language when speaking.</span>")
	else
		to_chat(src, "<span class='notice'>You will now speak whatever your standard default language is if you do not specify one when speaking.</span>")
	default_language = language?.type

// Silicons can't neccessarily speak everything in their languages list
/mob/living/silicon/set_default_language(language)
	..()

/mob/living/verb/check_default_language()
	set name = "Check Default Language"
	set category = "IC"

	if(default_language)
		var/decl/language/lang = GET_DECL(default_language)
		to_chat(src, "<span class='notice'>You are currently speaking [lang.name] by default.</span>")
	else
		to_chat(src, "<span class='notice'>Your current default language is your species or mob type default.</span>")
