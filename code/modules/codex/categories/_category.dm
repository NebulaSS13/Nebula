/decl/codex_category
	var/name = "Generic Category"
	var/desc = "Some description for category's codex entry"
	var/list/items = list()

	var/guide_name
	var/guide_html

//Children should call ..() at the end after filling the items list
/decl/codex_category/proc/Populate()

	if(items.len)
		var/lore_text = desc + "<hr>"
		if(guide_name && guide_html)
			lore_text += "This category has <span codexlink='Guide to [capitalize(guide_name || name)]'>an associated guide</span>.<hr>"
		var/list/links = list()
		for(var/item in items)
			links+= "<l>[item]</l>"
		lore_text += jointext(links, "<br>")
		new /datum/codex_entry(
			_display_name = "[name] (category)",
			_lore_text = lore_text
		)

	if(guide_html)
		new /datum/codex_entry(
			_display_name = "Guide to [capitalize(guide_name || name)]",
			_mechanics_text = guide_html
		)
