var/global/list/trait_categories = list() // Containers for ease of printing data.

/datum/trait_category
	var/name
	var/list/items = list()
	var/hide_from_chargen = TRUE

/datum/trait_category/New(var/newcategory)
	..()
	name = newcategory
