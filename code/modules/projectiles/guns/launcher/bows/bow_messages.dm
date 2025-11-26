/obj/item/gun/launcher/bow/proc/show_string_relax_message(mob/user)
	if(user)
		user.visible_action_message("relax", "the tension on \the [src]'s string.")

/obj/item/gun/launcher/bow/proc/show_unload_message(mob/user)
	if(user)
		user.visible_action_message("remove", "\the [_loaded] from \the [src].")

/obj/item/gun/launcher/bow/proc/show_draw_message(mob/user)
	if(user)
		user.visible_action_message("begin", "to draw back the string of \the [src].")

/obj/item/gun/launcher/bow/proc/show_max_draw_message(mob/user)
	var/decl/pronouns/self_pronouns = user.get_self_pronouns()
	to_chat(user, SPAN_NOTICE("\The [src] strains as [self_pronouns.he] [verb_agree_with_pronouns("draw", self_pronouns)] the string to its maximum tension!"))

/obj/item/gun/launcher/bow/proc/show_cancel_draw_message(mob/user)
	if(user)
		user.visible_action_message("stop", "drawing back and relax$USER_ES$ the string of \the [src].")

/obj/item/gun/launcher/bow/proc/show_working_draw_message(mob/user)
	if(user)
		user.visible_action_message("continue", "drawing back the string of \the [src]!")

/obj/item/gun/launcher/bow/proc/show_load_message(mob/user)
	if(user)
		user.visible_action_message("nock", "\the [_loaded] on \the [src].")

/obj/item/gun/launcher/bow/proc/show_string_remove_message(mob/user)
	if(user)
		user.visible_action_message("unstring", "\the [src].")

/obj/item/gun/launcher/bow/proc/show_string_message(mob/user)
	if(user)
		user.visible_action_message("string", "\the [src] with \the [string].")
