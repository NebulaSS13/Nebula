/atom/movable
	var/default_law_extension_type = /datum/extension/laws

/atom/movable/proc/get_laws()
	var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
	if(laws)
		laws.validate_lawset()
		. = laws.lawset

/atom/movable/proc/clear_laws()
	set_laws()

/atom/movable/proc/set_laws(var/datum/lawset/new_laws)

	if(ispath(new_laws, /decl/lawset))
		var/decl/lawset/lawset = decls_repository.get_decl(new_laws)
		new_laws = lawset.get_initial_lawset()

	if(!istype(new_laws))
		var/datum/extension/laws/laws = get_extension(src, /datum/extension/laws)
		if(laws)
			remove_extension(src, /datum/extension/laws)
		return

	var/datum/extension/laws/laws = get_or_create_extension(src, default_law_extension_type)
	laws.set_laws(new_laws)
	laws.lawset.owner = weakref(src)

/atom/movable/proc/get_law_subordinates()
	return

/atom/movable/proc/get_law_superior()
	return
