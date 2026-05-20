/decl/background_detail/citizenship
	abstract_type = /decl/background_detail/citizenship
	category = /decl/background_category/citizenship
	var/issuing_body
	var/size_value
	var/size_heading
	var/capital
	var/founded

/decl/background_detail/citizenship/get_text_details()
	. = list()
	if(!isnull(issuing_body))
		. += "<b>Issuing body:</b> [issuing_body]."
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]"
	if(!isnull(founded))
		. += "<b>Founded:</b> [founded]"
	if(!isnull(size_value) && !isnull(size_heading))
		. += "[size_value] [size_heading]."
	. += ..()
