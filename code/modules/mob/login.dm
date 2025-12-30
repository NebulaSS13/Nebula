//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	last_ckey = ckey
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(get_config_value(/decl/config/toggle/log_access))
		var/is_multikeying = 0
		for(var/mob/M in global.player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					is_multikeying = 1
				if(matches)
					if(M.client)
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='byond://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='byond://?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B></font><font color='blue'><A href='byond://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")
		if(is_multikeying && !client.warned_about_multikeying)
			client.warned_about_multikeying = 1
			spawn(1 SECOND)
				to_chat(src, "<b>WARNING:</b> It would seem that you are sharing connection or computer with another player. If you haven't done so already, please contact the staff via the Adminhelp verb to resolve this situation. Failure to do so may result in administrative action. You have been warned.")

	var/login_export_addr =  get_config_value(/decl/config/text/login_export_addr)
	if(login_export_addr)
		spawn(-1)
			var/list/params = new
			params["login"] = 1
			params["key"] = client.key
			if(isnum(client.player_age))
				params["server_age"] = client.player_age
			params["ip"] = client.address
			params["clientid"] = client.computer_id
			params["roundid"] = game_id
			params["name"] = real_name || name
			world.Export("[login_export_addr]?[list2params(params)]", null, 1)

/mob/proc/maybe_send_staffwarns(var/action)
	if(client.staffwarn)
		for(var/client/C in global.admins)
			send_staffwarn(C, action)

/mob/proc/send_staffwarn(var/client/C, var/action, var/noise = 1)
	if(check_rights((R_ADMIN|R_MOD),0,C))
		to_chat(C,"<span class='staffwarn'>StaffWarn: [client.ckey] [action]</span><br><span class='notice'>[client.staffwarn]</span>")
		if(noise && C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == PREF_HEAR)
			sound_to(C, 'sound/effects/adminhelp.ogg')

/mob
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/Login()

	client.clear_mouse_pointers() // in case we are transferring mobs.
	global.player_list |= src
	update_Login_details()
	world.update_status()

	maybe_send_staffwarns("joined the round")

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case
	client.set_right_click_menu_mode(shift_to_open_context_menu)

	next_move = 1
	set_sight(sight|SEE_SELF)

	..()

	my_client = client

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	if(eyeobj)
		eyeobj.possess(src)

	RAISE_EVENT(/decl/observ/logged_in, src)

	hud_reset(TRUE)

	if(istype(machine))
		machine.on_user_login(src)

/mob/proc/hud_reset(var/full_reset = FALSE)
	if(!client)
		return
	if(full_reset)
		client.images = null	//remove the images such as AIs being unable to see runes
		client.screen = list()	//remove hud items just in case
		client.set_right_click_menu_mode(shift_to_open_context_menu)
		initialize_hud()

	refresh_lighting_master()
	client.update_skybox(full_reset) // readd to client.screen if we cleared it
	refresh_client_images()
	reload_fullscreen() // Reload any fullscreen overlays this mob has.
	add_click_catcher()
	update_action_buttons()
	update_mouse_pointer()

	if(get_preference_value(/datum/client_preference/show_status_markers) == PREF_SHOW)
		if(status_markers?.mob_image_personal)
			client.images |= status_markers.mob_image_personal
		for(var/datum/status_marker_holder/marker in global.status_marker_holders)
			if(marker.mob_image && marker != status_markers)
				client.images |= marker.mob_image

	for(var/obj/item/gear in get_equipped_items(TRUE))
		client.screen |= gear

	if(istype(hud_used))
		hud_used.hidden_inventory_update()
		hud_used.persistent_inventory_update()
		update_action_buttons()

	return TRUE
