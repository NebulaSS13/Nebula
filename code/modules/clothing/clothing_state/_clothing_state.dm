/*
 * Decl system for handling modifiers to clothing icons.
 * Replaces the old bespoke systems for rolled-down jumpsuits, sleeves, etc.
 */

/obj/item/clothing
	var/mimicking_state_modifiers = FALSE
	var/list/clothing_state_modifiers

/obj/item/clothing/proc/get_flat_accessory_list()
	. = list()
	var/list/check_contents_list = list(src)
	while(length(check_contents_list))
		var/obj/item/clothing/check = check_contents_list[1]
		check_contents_list -= check
		if(check in .)
			continue
		. |= check
		if(length(check.accessories))
			check_contents_list |= check.accessories

/obj/item/clothing/proc/get_assumed_clothing_state_modifiers()
	return null

/obj/item/clothing/proc/get_available_clothing_state_modifiers()
	var/list/state_modifiers = get_assumed_clothing_state_modifiers()
	if(length(state_modifiers))
		state_modifiers = sortTim(state_modifiers.Copy(), /proc/cmp_name_asc)
		return state_modifiers
	return null

/obj/item/clothing/proc/update_clothing_state_toggles()
	if(mimicking_state_modifiers && clothing_state_modifiers)
		return FALSE
	clothing_state_modifiers = null
	for(var/decl/clothing_state_modifier/modifier in get_available_clothing_state_modifiers())
		LAZYSET(clothing_state_modifiers, modifier.type, FALSE)
		. = TRUE
	if(.)
		update_clothing_toggle_verbs()

/obj/item/clothing/proc/update_clothing_toggle_verbs()

	// If we're not at the top of the pile, pass it back to the top.
	if(istype(loc, /obj/item/clothing))
		var/obj/item/clothing/holder = loc
		return holder.update_clothing_toggle_verbs()

	// If we have no accessories, we don't need to care about iterating accessories.
	// We need to iterate the entire clothing state modifier list because our accessories
	// don't necessarily line up with our expected state list.
	var/list/all_modifiers = decls_repository.get_decls_of_subtype(/decl/clothing_state_modifier)
	if(!length(accessories))
		for(var/modifier_type in all_modifiers)
			var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
			if(modifier_type in clothing_state_modifiers)
				verbs += modifier.toggle_verb
			else
				verbs -= modifier.toggle_verb
		return

	// Check which states are unclear and need to be checked in accessories.
	var/list/ambiguous_states = list()
	for(var/modifier_type in all_modifiers)
		if(modifier_type in clothing_state_modifiers)
			var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
			verbs += modifier.toggle_verb
		else
			ambiguous_states += modifier_type

	// If we don't need to check any, we can stop here.
	if(!length(ambiguous_states))
		return

	// Regrettably we now need to check all our accessories for the toggles.
	var/list/accessory_states = list()
	for(var/obj/item/clothing/accessory in get_flat_accessory_list())
		if(length(accessory.clothing_state_modifiers))
			accessory_states |= accessory.clothing_state_modifiers
			ambiguous_states -= accessory.clothing_state_modifiers
			if(!length(ambiguous_states))
				break

	for(var/modifier_type in ambiguous_states)
		var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
		verbs -= modifier.toggle_verb

	for(var/modifier_type in accessory_states)
		var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
		verbs += modifier.toggle_verb

/obj/item/clothing/proc/toggle_clothing_state(var/modifier_type)
	var/set_state_to
	var/atom/first_altered
	for(var/obj/item/clothing/accessory in get_flat_accessory_list())
		if(modifier_type in accessory.clothing_state_modifiers)
			if(isnull(set_state_to))
				first_altered = accessory
				set_state_to = !accessory.clothing_state_modifiers[modifier_type]
			if(accessory.clothing_state_modifiers[modifier_type] != set_state_to)
				accessory.clothing_state_modifiers[modifier_type] = set_state_to
				accessory.update_icon()
	return first_altered

/obj/item/clothing/proc/get_clothing_state_modifier()
	for(var/modifier_type in clothing_state_modifiers)
		if(clothing_state_modifiers[modifier_type])
			var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
			if(modifier.applies_icon_state_modifier)
				LAZYADD(., modifier.icon_state_modifier)
	if(.)
		. = JOINTEXT(.)

/obj/item/clothing/proc/should_show_id()
	if(!should_display_id)
		return FALSE
	for(var/modifier_type in clothing_state_modifiers)
		var/decl/clothing_state_modifier/modifier = GET_DECL(modifier_type)
		if(modifier.hides_id && clothing_state_modifiers[modifier_type])
			return TRUE
	return FALSE

/obj/item/clothing/proc/should_hide_accessory(var/list/check_states)
	for(var/modifier_type in check_states)
		if((modifier_type in clothing_state_modifiers) && clothing_state_modifiers[modifier_type])
			return TRUE
	return FALSE

/decl/interaction_handler/clothing_toggle
	abstract_type = /decl/interaction_handler/clothing_toggle
	expected_target_type = /obj/item/clothing
	var/state_decl_type

/decl/interaction_handler/clothing_toggle/invoked(atom/target, mob/user, obj/item/prop)
	var/decl/clothing_state_modifier/modifier = GET_DECL(state_decl_type)
	call(target, modifier.toggle_verb)()
