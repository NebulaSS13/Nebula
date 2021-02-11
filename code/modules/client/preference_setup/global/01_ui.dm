var/list/valid_icon_sizes = list(32, 48, 64, 96, 128)

/datum/preferences
	var/clientfps = 0
	var/ooccolor = "#010000" //Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/icon_size = 48
	var/UI_style = "Midnight"
	var/UI_style_alpha =     255
	var/UI_style_color =     COLOR_WHITE
	var/UI_mouseover_alpha = 255
	var/UI_mouseover_color = COLOR_AMBER
	//Style for popup tooltips
	var/tooltip_style = "Midnight"

/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	from_file(S["icon_size"],          pref.icon_size)
	from_file(S["UI_style"],           pref.UI_style)
	from_file(S["UI_mouseover_color"], pref.UI_mouseover_color)
	from_file(S["UI_style_alpha"],     pref.UI_style_alpha)
	from_file(S["UI_mouseover_alpha"], pref.UI_mouseover_alpha)
	from_file(S["UI_style_alpha"],     pref.UI_style_alpha)
	from_file(S["ooccolor"],           pref.ooccolor)
	from_file(S["clientfps"],          pref.clientfps)

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	to_file(S["icon_size"],            pref.icon_size)
	to_file(S["UI_style"],             pref.UI_style)
	to_file(S["UI_mouseover_color"],   pref.UI_mouseover_color)
	to_file(S["UI_mouseover_alpha"],   pref.UI_mouseover_alpha)
	to_file(S["UI_style_color"],       pref.UI_style_color)
	to_file(S["UI_style_alpha"],       pref.UI_style_alpha)
	to_file(S["ooccolor"],             pref.ooccolor)
	to_file(S["clientfps"],            pref.clientfps)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style		    = sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_mouseover_color	= sanitize_hexcolor(pref.UI_mouseover_color, initial(pref.UI_mouseover_color))
	pref.UI_mouseover_alpha	= sanitize_integer(pref.UI_mouseover_alpha, 0, 255, initial(pref.UI_mouseover_alpha))
	pref.UI_style_color	    = sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha	    = sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor		    = sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.clientfps	        = sanitize_integer(pref.clientfps, CLIENT_MIN_FPS, CLIENT_MAX_FPS, initial(pref.clientfps))

	if(!isnum(pref.icon_size)) 
		pref.icon_size = initial(pref.icon_size)
	pref.client?.SetWindowIconSize(pref.icon_size)

/datum/category_item/player_setup_item/player_global/ui/proc/get_ui_table(var/mob/user)
	LAZYINITLIST(.)
	. += "<tr><td>UI Color</td>"
	. += "<td><a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a></td>"
	. += "<td><table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table></td>"
	. += "<td><a href='?src=\ref[src];reset=ui'>reset</a></td>"
	. += "</tr>"
	. += "<tr><td>UI Opacity</td>"
	. += "<td colspan = 2><a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a></td>"
	. += "<td><a href='?src=\ref[src];reset=alpha'>reset</a></td>"
	. += "</tr>"

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. = "<b>UI Settings</b><br>"
	. += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"

	. += "<b>Custom UI</b> (recommended for White UI):"
	. += "<table style='margin: 0px auto; padding: 1px;'>"
	. += jointext(get_ui_table(), null)
	. += "</table><br>"
	. += "<b>Tooltip Style:</b> <a href='?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltip_style]</b></a><br>"
	. += "<b>Default icon size:</b> <a href='?src=\ref[src];select_icon_size=1'>[pref.icon_size]x[pref.icon_size]</a><br>"

	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table> <a href='?src=\ref[src];reset=ooc'>reset</a><br>"
	. += "<b>Client FPS:</b> <a href='?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.UI_style) as null|anything in all_ui_styles
		if(!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_fps"])
		var/version_message
		if (user.client && user.client.byond_version < 511)
			version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [user.client.byond_version] is too low"
		if (world.byond_version < 511)
			version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
		var/new_fps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Global Preference") as num|null
		if (isnum(new_fps) && CanUseTopic(user))
			pref.clientfps = Clamp(new_fps, CLIENT_MIN_FPS, CLIENT_MAX_FPS)

			var/mob/target_mob = preference_mob()
			if(target_mob && target_mob.client)
				target_mob.client.apply_fps(pref.clientfps)
			return TOPIC_REFRESH

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = input(user, "Choose tooltip style.", "Global Preference", pref.tooltip_style) as null|anything in all_tooltip_styles
		if(!tooltip_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.tooltip_style = tooltip_style_new
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("mouseover_color")
				pref.UI_mouseover_color = initial(pref.UI_mouseover_color)
			if("mouseover_alpha")
				pref.UI_mouseover_alpha = initial(pref.UI_mouseover_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	else if(href_list["select_icon_size"])
		var/new_icon_size = input(user, "Enter a new default icon size.", "Default Icon Size", pref.icon_size) as null|anything in global.valid_icon_sizes
		if(new_icon_size && pref.icon_size != new_icon_size)
			pref.icon_size = new_icon_size
			pref.client?.SetWindowIconSize(pref.icon_size)
			return TOPIC_REFRESH

	return ..()

/proc/can_select_ooc_color(var/mob/user)
	return config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)
