/decl/codex_category
	var/name = "Generic Category"
	var/desc = "Some description for category's codex entry"
	var/list/items = list()
	var/defer_population = FALSE
	var/guide_name
	var/guide_html
	var/link_columns = 2

/decl/codex_category/proc/get_category_link(var/datum/codex_entry/entry)
	return "This page is categorized under <span codexlink='[name] (category)'>[name].</span>"

//Children should call ..() at the end after filling the items list
/decl/codex_category/proc/Populate()

	if(items.len)
		var/lore_text = desc + "<hr>"
		if(guide_name && guide_html)
			lore_text += "This category has <span codexlink='Guide to [capitalize(guide_name || name)]'>an associated guide.</span><hr>"

		items = sortTim(items, /proc/cmp_text_asc, TRUE)
		var/list/links = list()
		for(var/item as anything in items)
			var/datum/codex_entry/item_entry = SScodex.get_entry_by_string(item)
			if(!item_entry)
				PRINT_STACK_TRACE("Invalid item supplied to codex category Populate(): [item]")
				continue
			var/starter = uppertext(copytext(strip_improper(item_entry.name), 1, 2))
			LAZYDISTINCTADD(item_entry.categories, src)
			if(item_entry.unsearchable) // Unsearchable entries don't show up in category listings either.
				continue
			LAZYADD(links[starter], "<l>[item_entry.name]</l>")

		var/list/link_cells = list()
		for(var/letter in global.alphabet_capital)
			if(length(links[letter]))
				link_cells += "<td><b><center>[letter]</center></b>\n<hr>\n<br>\n[jointext(links[letter], "\n<br>\n")]</td>\n"

		var/list/link_table = list("<table>")
		var/link_counter = 0
		for(var/i = 1 to length(link_cells))
			if(link_counter == 0)
				link_table += "<tr>"
			link_table += link_cells[i]
			if(link_counter == link_columns)
				link_table += "</tr>"
			link_counter++
			if(link_counter > link_columns)
				link_counter = 0

		if(link_counter != link_columns)
			link_table += "</tr>"
		link_table += "</table>"

		lore_text += jointext(link_table, "\n")
		var/datum/codex_entry/entry = new(
			_display_name = "[name] (category)",
			_lore_text = lore_text
		)
		// Categorize the categories.
		var/decl/codex_category/categories/cats_cat = GET_DECL(/decl/codex_category/categories)
		LAZYDISTINCTADD(entry.categories, cats_cat)
		LAZYDISTINCTADD(cats_cat.items, entry.name)

	if(guide_html)
		var/datum/codex_entry/entry = new(
			_display_name = "Guide to [capitalize(guide_name || name)]",
			_mechanics_text = guide_html
		)
		LAZYDISTINCTADD(entry.categories, src)
		// It's a guide so we track it.
		var/decl/codex_category/guides/guides_cat = GET_DECL(/decl/codex_category/guides)
		LAZYDISTINCTADD(entry.categories, guides_cat)
		LAZYDISTINCTADD(guides_cat.items, entry.name)
