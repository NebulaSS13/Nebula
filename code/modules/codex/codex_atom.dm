/atom
	VAR_PROTECTED/datum/codex_entry/_atom_codex_value // /datum for initial()
	VAR_PROTECTED/datum/codex_entry/_atom_codex_ref

/atom/proc/get_codex_value()
	return ispath(_atom_codex_value, /datum/codex_entry) ? _atom_codex_value::name : src

/atom/proc/get_atom_codex_entry(mob/user, permanent = FALSE, strict = TRUE)

	var/existing = SScodex.get_codex_entry(get_codex_value(user), do_search = !strict, skip_atom_codex = TRUE)
	if(existing)
		return existing

	if(istype(_atom_codex_ref, /datum/codex_entry))
		return _atom_codex_ref

	var/lore_text      = get_lore_info()
	var/mechanics_text = get_mechanics_info()
	var/antag_text     = get_antag_info()

	if(!length(lore_text) && !length(mechanics_text) && !length(antag_text))
		return

	lore_text      = islist(lore_text)      ? jointext(lore_text,      "<br><br>") : null
	mechanics_text = islist(mechanics_text) ? jointext(mechanics_text, "<br><br>") : null
	antag_text     = islist(antag_text)     ? jointext(antag_text,     "<br><br>") : null

	if(!permanent)
		_atom_codex_ref = new /datum/codex_entry/temporary(name, _lore_text = lore_text, _mechanics_text = mechanics_text, _antag_text = antag_text)
		return _atom_codex_ref

	return SScodex.get_codex_entry(get_codex_value(user), do_search = TRUE, skip_atom_codex = TRUE) || new /datum/codex_entry(name, _lore_text = lore_text, _mechanics_text = mechanics_text, _antag_text = antag_text)

/atom/proc/get_mechanics_info()
	return

/atom/proc/get_antag_info()
	return

/atom/proc/get_lore_info()
	return
