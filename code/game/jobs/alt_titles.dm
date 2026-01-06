/decl/alt_title
	abstract_type = /decl/alt_title
	var/name
	var/desc
	var/outfit

/decl/alt_title/validate()
	. = ..()
	if(!name)
		. += "missing name"
	if(!desc)
		. += "missing desc"
	if(!ispath(outfit, /decl/outfit))
		. += "missing or invalid outfit: [outfit || "NULL"]"

/datum/job/New()
	if(length(alt_titles))
		for(var/title in alt_titles)
			if(ispath(title, /decl/alt_title))
				var/decl/alt_title/title_data = GET_DECL(title)
				alt_titles -= title
				alt_titles[title_data.name] = title_data.outfit
	..()
