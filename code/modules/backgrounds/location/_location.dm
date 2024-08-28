/decl/background_detail/location
	abstract_type = /decl/background_detail/location
	category = /decl/background_category/homeworld
	var/distance_heading = "Distance from Sol"
	var/distance = 0
	var/ruling_body = "Other Faction"
	var/capital

	// Used by the random news generator. Populate with subtypes of /decl/location_event.
	var/list/viable_random_events = list()
	var/list/viable_mundane_events = list()

/decl/background_detail/location/get_text_details()
	. = list()
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]."
	if(!isnull(ruling_body))
		. += "<b>Territory:</b> [ruling_body]."
	if(!isnull(distance) && !isnull(distance_heading))
		. += "<b>[distance_heading]:</b> [distance]."
	. += ..()
