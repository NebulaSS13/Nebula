/datum/objective/steal
	var/theft_name
	var/theft_type
	var/theft_material
	var/theft_amount = 1

/datum/objective/steal/find_target()

	var/list/possible_items = global.using_map.get_theft_targets() | global.using_map.get_special_theft_targets()
	if(!length(possible_items))
		return
	theft_name = pick(possible_items)
	var/theft_data = possible_items[theft_name]
	if(ispath(theft_data))
		theft_type = theft_data
	else if(islist(theft_data))
		if(length(theft_data) >= 1 && ispath(theft_data[1]))
			theft_type = theft_data[1]
		if(length(theft_data) >= 2 && isnum(theft_data[2]))
			theft_amount = theft_data[2]
		if(length(theft_data) >= 3 && ispath(theft_data[3], /decl/material))
			theft_material = theft_data[3]

	if(!theft_type || theft_amount <= 0)
		explanation_text = "Free objective."
	else
		explanation_text = "Steal [theft_name]."
	return theft_type
