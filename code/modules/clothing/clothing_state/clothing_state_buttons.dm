/decl/clothing_state_modifier/buttons
	name = "toggle open or closed"
	icon_state_modifier = "-open"
	toggle_verb = /obj/item/clothing/proc/toggle_buttons_verb
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/buttons

/decl/interaction_handler/clothing_toggle/buttons
	name = "Toggle Open Or Closed"
	state_decl_type = /decl/clothing_state_modifier/buttons

/obj/item/clothing/proc/toggle_buttons_verb()

	set name = "Toggle Open Or Closed"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return
	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/buttons)
	if(toggled)
		usr.visible_message("\The [usr] [toggled.clothing_state_modifiers[/decl/clothing_state_modifier/buttons] ? "opens" : "fastens"] \the [toggled].")
		update_icon()
		update_clothing_icon()
	else
		verbs -= /obj/item/clothing/proc/toggle_buttons_verb
