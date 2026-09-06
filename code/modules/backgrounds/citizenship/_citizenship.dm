/decl/background_detail/citizenship
	abstract_type = /decl/background_detail/citizenship
	category = /decl/background_category/citizenship
	var/issuing_body

/decl/background_detail/citizenship/get_text_details()
	. = list()
	if(!isnull(issuing_body))
		. += "<b>Issuing body:</b> [issuing_body]."
	. += ..()
