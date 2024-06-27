/decl/clothing_state_modifier/tucked_in
	name = "tuck in or untuck"
	icon_state_modifier = "-tucked"
	toggle_verb = /obj/item/clothing/proc/toggle_tucked_verb
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/tucked_in

/decl/interaction_handler/clothing_toggle/tucked_in
	name = "Tuck In Or Untuck"
	state_decl_type = /decl/clothing_state_modifier/tucked_in

/obj/item/clothing/proc/toggle_tucked_verb()

	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return
	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/tucked_in)
	if(toggled)
		usr.visible_message("\The [usr] [toggled.clothing_state_modifiers[/decl/clothing_state_modifier/tucked_in] ? "tucks in" : "untucks"] \the [toggled].")
		update_icon()
		update_clothing_icon()
	else
		verbs -= /obj/item/clothing/proc/toggle_tucked_verb
