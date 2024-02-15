/mob
	var/list/usable_emotes

/mob/proc/get_base_default_emotes()
	return

/mob/proc/update_emotes(var/skip_sort)
	LAZYCLEARLIST(usable_emotes)
	for(var/emote in get_base_default_emotes())
		var/decl/emote/emote_datum = GET_DECL(emote)
		if(emote_datum.check_user(src))
			LAZYSET(usable_emotes, emote_datum.key, emote_datum)
	if(LAZYLEN(usable_emotes) && !skip_sort)
		usable_emotes = sortTim(usable_emotes, /proc/cmp_text_asc, associative = TRUE)

/mob/living/update_emotes()
	. = ..(skip_sort=1)
	var/decl/species/my_species = get_species()
	if(LAZYLEN(my_species?.default_emotes))
		for(var/emote in my_species.default_emotes)
			var/decl/emote/emote_datum = GET_DECL(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	if(LAZYLEN(usable_emotes))
		usable_emotes = sortTim(usable_emotes, /proc/cmp_text_asc, associative = TRUE)

/mob/Initialize()
	. = ..()
	update_emotes()
