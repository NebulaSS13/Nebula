/decl/codex_category
	var/name = "Generic Category"
	var/desc = "Some description for category's codex entry"
	var/list/items = list()

	var/guide_name
	var/guide_html
	var/list/guide_strings

//Children should call ..() at the end after filling the items list
/decl/codex_category/Initialize()
	. = ..()
	if(items.len)
		var/datum/codex_entry/entry = new(_display_name = "[name] (category)")
		entry.lore_text = desc + "<hr>"
		if(guide_name && guide_html)
			entry.lore_text += "This category has <span codexlink='Guide to [capitalize(guide_name || name)]'>an associated guide</span>.<hr>"
		var/list/links = list()
		for(var/item in items)
			links+= "<l>[item]</l>"
		entry.lore_text += jointext(links, "<br>")
		SScodex.add_entry_by_string(lowertext(entry.display_name), entry)

	if(guide_html)
		if(guide_name)
			LAZYDISTINCTADD(guide_strings, lowertext(guide_name))
		var/datum/codex_entry/entry = new(      \
			_display_name = "Guide to [capitalize(guide_name || name)]",  \
			_associated_strings = guide_strings \
			)
		entry.mechanics_text = guide_html
		SScodex.add_entry_by_string(lowertext(entry.display_name), entry)
