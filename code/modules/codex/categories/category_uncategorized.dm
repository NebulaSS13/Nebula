/decl/codex_category/uncategorized
	name = "Uncategorized"
	desc = "A collection of uncategorized entries."
	defer_population = TRUE

/decl/codex_category/uncategorized/Populate()
	for(var/datum/codex_entry/entry as anything in SScodex.all_entries)
		if(!length(entry.categories))
			LAZYADD(entry.categories, src)
			items |= entry.name
	return ..()
