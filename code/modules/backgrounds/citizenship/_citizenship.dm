/decl/background_detail/citizenship
	abstract_type = /decl/background_detail/citizenship
	category = /decl/background_category/citizenship
	var/ruling_body = "Other Faction"
	var/capital
	var/size_heading = "Systems"
	var/size_value
	var/founded

/decl/background_detail/citizenship/get_text_details()
	. = list()
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]."
	if(!isnull(size_value) && !isnull(size_heading))
		. += "<b>Extent:</b> [size_value] [size_heading]."
	if(!isnull(founded))
		. += "<b>Founded:</b> [founded]"
	. += ..()
