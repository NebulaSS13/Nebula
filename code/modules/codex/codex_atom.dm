/atom
	var/atom_codex_ref

/obj
	atom_codex_ref = TRUE

/mob
	atom_codex_ref = TRUE

/turf
	atom_codex_ref = TRUE

/atom/proc/get_codex_value()
	return src

/atom/proc/get_atom_codex_entry(mob/user, permanent = FALSE)

	if(!atom_codex_ref)
		return SScodex.get_codex_entry(get_codex_value(user), skip_atom_codex = TRUE)

	if(istype(atom_codex_ref, /datum/codex_entry))
		return atom_codex_ref

	var/lore = get_lore_info()
	var/mechanics = get_mechanics_info()
	var/antag = get_antag_info()
	if(!lore && !mechanics && !antag)
		return

	if(!permanent)
		atom_codex_ref = new /datum/codex_entry/temporary(name, list(type), _lore_text = lore, _mechanics_text = mechanics, _antag_text = antag)
		return atom_codex_ref

	return SScodex.get_codex_entry(get_codex_value(user), skip_atom_codex = TRUE) || new /datum/codex_entry(name, list(type), _lore_text = lore, _mechanics_text = mechanics, _antag_text = antag)

/atom/proc/get_mechanics_info()
	return

/atom/proc/get_antag_info()
	return

/atom/proc/get_lore_info()
	return
