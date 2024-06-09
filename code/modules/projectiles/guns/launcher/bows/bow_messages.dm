/obj/item/gun/launcher/bow/proc/show_string_relax_message(mob/user)
	if(user)
		user.visible_message(
			"\The [user] relaxes the tension on \the [src]'s string.",
			"You relax the tension on \the [src]'s string."
		)

/obj/item/gun/launcher/bow/proc/show_unload_message(mob/user)
	if(user)
		user.visible_message(
			"\The [user] removes \the [_loaded] from \the [src].",
			"You remove \the [_loaded] from \the [src]."
		)

/obj/item/gun/launcher/bow/proc/show_draw_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins to draw back the string of \the [src]."),
			SPAN_NOTICE("You begin to draw back the string of \the [src].")
		)

/obj/item/gun/launcher/bow/proc/show_max_draw_message(mob/user)
	to_chat(user, SPAN_NOTICE("\The [src] strains as you draw the string to its maximum tension!"))

/obj/item/gun/launcher/bow/proc/show_cancel_draw_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] stops drawing and relaxes the string of \the [src]."),
			SPAN_NOTICE("You stop drawing back and relax the string of \the [src].")
		)

/obj/item/gun/launcher/bow/proc/show_working_draw_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] draws back the string of \the [src]!"),
			SPAN_NOTICE("You continue drawing back the string of \the [src]!")
		)

/obj/item/gun/launcher/bow/proc/show_load_message(mob/user)
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] nocks \the [_loaded] on \the [src]."),
			SPAN_NOTICE("You nock \the [_loaded] on \the [src].")
		)

/obj/item/gun/launcher/bow/proc/show_string_remove_message(mob/user)
	if(user)
		user.visible_message("\The [user] unstrings \the [src].")

/obj/item/gun/launcher/bow/proc/show_string_message(mob/user)
	if(user)
		user.visible_message("\The [user] strings \the [src] with \the [string].")
