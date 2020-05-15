/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	if(my_client)
		my_client.screen -= l_general
		my_client.screen -= lighting_plane_master
		my_client.screen -= mundane_plane_masters

	QDEL_NULL(l_general)
	QDEL_NULL(lighting_plane_master)
	QDEL_NULL_LIST(mundane_plane_masters)

	hide_client_images()
	..()

	my_client = null
	return 1
