/decl/clothing_state_modifier/untied
	name = "tie or untie"
	icon_state_modifier = "-untied"
	toggle_verb = /obj/item/clothing/proc/toggle_untied_verb
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/untied

/decl/interaction_handler/clothing_toggle/untied
	name = "Tie Or Untie"
	state_decl_type = /decl/clothing_state_modifier/untied

/obj/item/clothing/proc/toggle_untied_verb()

	set name = "Tie or Untie"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return
	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/untied)
	if(toggled)
		usr.visible_message("\The [usr] [toggled.clothing_state_modifiers[/decl/clothing_state_modifier/untied] ? "unties" : "ties"] \the [toggled].")
		update_icon()
		update_clothing_icon()
	else
		verbs -= /obj/item/clothing/proc/toggle_untied_verb
