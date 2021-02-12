/mob/living/proc/update_laws()
	var/clear_laws_extension = TRUE
	var/decl/species/my_species = get_species()
	if(length(my_species?.personal_lawsets))
		var/datum/lawset/lawset = client?.prefs?.get_lawset(src)
		if(lawset)
			var/datum/extension/laws/laws = get_or_create_extension(src, /datum/extension/laws)
			laws.set_laws(lawset)
			verbs |= /mob/living/proc/show_laws_verb
			verbs |= /mob/living/proc/state_laws_verb
			verbs |= /mob/living/proc/manage_laws_verb
			clear_laws_extension = FALSE
	if(clear_laws_extension)
		var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
		if(laws)
			remove_extension(src, /datum/extension/laws)
		verbs -= /mob/living/proc/show_laws_verb
		verbs -= /mob/living/proc/state_laws_verb
		verbs -= /mob/living/proc/manage_laws_verb

/mob/living/silicon/update_laws()
	return

/mob/living/proc/state_laws_verb()
	set name = "State Laws"
	set category = "Laws"
	set src = usr
	var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
	if(!laws)
		to_chat(src, SPAN_WARNING("You have no laws."))
		verbs -= /mob/living/proc/state_laws_verb
		return
	laws.state_laws(src)

/mob/living/proc/show_laws_verb()
	set name = "Show Laws"
	set category = "Laws"
	set src = usr

	var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
	if(!laws)
		to_chat(src, SPAN_WARNING("You have no laws."))
		verbs -= /mob/living/proc/show_laws_verb
		return
	to_chat(src, SPAN_NOTICE("<b>You have the following laws:</b>"))
	laws.show_laws(src)

/mob/living/proc/manage_laws_verb()
	set name = "Manage Laws"
	set category = "Laws"
	set src = usr

	var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
	if(!laws)
		to_chat(src, SPAN_WARNING("You have no laws."))
		verbs -= /mob/living/proc/manage_laws_verb
		return
	laws.manage_laws(src)
