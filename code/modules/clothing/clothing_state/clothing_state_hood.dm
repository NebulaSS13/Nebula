/decl/clothing_state_modifier/hood
	name = "adjust hood"
	icon_state_modifier = "-hood"
	toggle_verb = /obj/item/clothing/proc/toggle_hood_verb
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/hood

/decl/interaction_handler/clothing_toggle/hood
	name = "Adjust Hood"
	state_decl_type = /decl/clothing_state_modifier/hood
	examine_desc = "push the hood up or down"

/obj/item/clothing/proc/toggle_hood_verb()

	set name = "Roll Up Or Down"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return

	var/check_hood = get_hood()
	if(!ismob(loc) || !check_hood)
		remove_hood()

	if(usr.get_equipped_item(slot_wear_suit_str) != src)
		to_chat(usr, SPAN_WARNING("You must be wearing \the [src] to put up the hood!"))
		return

	var/wearing_head = usr.get_equipped_item(slot_head_str)
	if(wearing_head && wearing_head != check_hood)
		to_chat(usr, SPAN_WARNING("You're already wearing \the [wearing_head] on your head!"))
		return

	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/hood)
	if(toggled)
		var/is_toggled = toggled.clothing_state_modifiers[/decl/clothing_state_modifier/hood]
		usr.visible_message("\The [usr] [is_toggled ? "pulls up" : "pushes down"] the hood of \the [toggled].")
		if(is_toggled)
			usr.equip_to_slot_if_possible(check_hood, slot_head_str, 0, 0, 1)
		else
			remove_hood()
	else
		verbs -= /obj/item/clothing/proc/toggle_hood_verb
