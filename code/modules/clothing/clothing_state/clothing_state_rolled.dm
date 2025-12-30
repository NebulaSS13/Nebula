/decl/clothing_state_modifier/rolled_down
	name = "roll up or down"
	icon_state_modifier = "-rolled"
	toggle_verb = /obj/item/clothing/proc/toggle_rolled_verb
	hides_id = TRUE
	alt_interaction_type = /decl/interaction_handler/clothing_toggle/rolled_down

/decl/interaction_handler/clothing_toggle/rolled_down
	name = "Roll Up Or Down"
	state_decl_type = /decl/clothing_state_modifier/rolled_down
	examine_desc = "roll $TARGET_THEM$ up or down"

/obj/item/clothing/proc/toggle_rolled_verb()

	set name = "Roll Up Or Down"
	set category = "Object"
	set src in usr

	if(!usr || usr.incapacitated() || QDELETED(src))
		return
	var/obj/item/clothing/toggled = toggle_clothing_state(/decl/clothing_state_modifier/rolled_down)
	if(toggled)
		usr.visible_message("\The [usr] [toggled.clothing_state_modifiers[/decl/clothing_state_modifier/rolled_down] ? "unzips and rolls down" : "zips up"] \the [toggled].")
		update_icon()
		update_clothing_icon()
	else
		verbs -= /obj/item/clothing/proc/toggle_rolled_verb
