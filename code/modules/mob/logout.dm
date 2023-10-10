/mob/Logout()

	RAISE_EVENT(/decl/observ/logged_out, src, my_client)
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	global.player_list -= src
	log_access("Logout: [key_name(src)]")

	hide_client_images()
	SStyping.set_indicator_state(client, FALSE)

	. = ..()
	my_client = null
