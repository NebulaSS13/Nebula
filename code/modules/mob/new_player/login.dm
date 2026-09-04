/mob/new_player/Login()

	ASSERT(loc == null)

	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	global.using_map.show_titlescreen(client)
	my_client = client
	set_sight(sight|SEE_TURFS)
	global.player_list |= src

	if(!SScharacter_setup.initialized)
		SScharacter_setup.newplayers_requiring_init += src
	else
		deferred_login()

// This is called when the charcter setup system has been sufficiently initialized and prefs are available.
// Do not make any calls in mob/Login which may require prefs having been loaded.
// It is safe to assume that any UI or sound related calls will fall into that category.
/mob/new_player/proc/deferred_login()
	if(!client)
		return

	client.prefs?.apply_post_login_preferences()
	client.playtitlemusic()
	maybe_send_staffwarns("connected as new player")

	show_lobby_menu(TRUE)

	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if(security_state?.show_on_login)
		var/decl/security_level/sec_level = security_state.current_security_level
		// todo: allow maps to override this string for things like the fantasy map being on high alert?
		// eg "The alert level *in* Karzerfeste Keep is currently high alert." or "Karzerfeste Keep is currently on high alert."
		to_chat(src, SPAN_NOTICE("The alert level on the [station_name()] is currently: <span class='[sec_level.light_color_class]'><B>[sec_level.name]</B></span>. [sec_level?.up_description]"))

	// bolds the changelog button on the interface so we know there are updates.
	if(client.prefs?.lastchangelog != global.changelog_hash)
		to_chat(client, SPAN_NOTICE("You have unread updates in the changelog."))
		if(get_config_value(/decl/config/toggle/aggressive_changelog))
			client.changes()
