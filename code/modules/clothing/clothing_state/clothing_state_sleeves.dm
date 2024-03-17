/decl/clothing_state_modifier/rolled_sleeves
	name = "roll sleeves up or down"
	icon_state_modifier = "-sleeves"
	toggle_verb = /obj/item/clothing/proc/toggle_sleeves_verb
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/rolled_sleeves

/decl/interaction_handler/clothing_toggle/rolled_sleeves
	name = "Roll Sleeves Up Or Down"
	state_decl_type = /decl/clothing_state_modifier/rolled_sleeves

/obj/item/clothing/proc/toggle_sleeves_verb()

	set name = "Roll Sleeves Up Or Down"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return
	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/rolled_sleeves)
	if(toggled)
		usr.visible_message("\The [usr] [toggled.clothing_state_modifiers[/decl/clothing_state_modifier/rolled_sleeves] ? "rolls up" : "rolls down"] \the [toggled]'s sleeves.")
		update_icon()
		update_clothing_icon()
	else
		verbs -= /obj/item/clothing/proc/toggle_sleeves_verb
