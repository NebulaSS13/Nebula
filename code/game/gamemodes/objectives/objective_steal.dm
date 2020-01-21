/datum/objective/steal
	var/obj/item/steal_target
	var/target_name

/datum/objective/steal/proc/set_target(item_name)
	target_name = item_name
	var/list/possible_items = GLOB.using_map.get_theft_targets()
	steal_target = possible_items[target_name]
	if (!steal_target )
		var/list/possible_items_special = GLOB.using_map.get_special_theft_targets()
		steal_target = possible_items_special[target_name]
	explanation_text = "Steal [target_name]."
	return steal_target

/datum/objective/steal/find_target()
	return set_target(pick(GLOB.using_map.get_theft_targets()))

/datum/objective/steal/proc/select_target()
	var/possible_items = GLOB.using_map.get_theft_targets()
	var/possible_items_special = GLOB.using_map.get_special_theft_targets()
	var/list/possible_items_all = possible_items+possible_items_special+"custom"
	var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if (!new_target) return
	if (new_target == "custom")
		var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/obj/item)
		if (!custom_target) return
		var/tmp_obj = new custom_target
		var/custom_name = tmp_obj:name
		qdel(tmp_obj)
		custom_name = sanitize(input("Enter target name:", "Objective target", custom_name) as text|null)
		if (!custom_name) return
		target_name = custom_name
		steal_target = custom_target
		explanation_text = "Steal [target_name]."
	else
		set_target(new_target)
	return steal_target