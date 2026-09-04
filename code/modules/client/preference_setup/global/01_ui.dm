var/global/list/valid_icon_sizes = list(32, 48, 64, 96, 128)

/datum/preferences
	var/clientfps                = 0
	var/ooccolor                 = "#010000" //Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/icon_size                = 64
	var/UI_style
	var/UI_style_alpha           = 255
	var/UI_style_color           = "#8a8872"
	var/UI_style_highlight_color = "#545e78"
	var/UI_mouseover_alpha       = 255
	var/UI_mouseover_color       = COLOR_AMBER
	//Style for popup tooltips
	var/tooltip_style            = "Midnight"

/datum/category_item/player_setup_item/player_global
	abstract_type = /datum/category_item/player_setup_item/player_global

/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(datum/pref_record_reader/R)

	var/style_uid = R.read("UI_style")
	if(style_uid)
		// Retrieve by var in case of grandfathered saves using decl name.
		var/decl/ui_style/ui_style = decls_repository.get_decl_by_id_or_var(style_uid, /decl/ui_style)
		if(ui_style)
			pref.UI_style = ui_style.type

	pref.icon_size                = R.read("icon_size")
	pref.UI_mouseover_color       = R.read("UI_mouseover_color")
	pref.UI_mouseover_alpha       = R.read("UI_mouseover_alpha")
	pref.UI_style_color           = R.read("UI_style_color")
	pref.UI_style_highlight_color = R.read("UI_style_highlight_color")
	pref.UI_style_alpha           = R.read("UI_style_alpha")
	pref.ooccolor                 = R.read("ooccolor")
	pref.clientfps                = R.read("clientfps")

/datum/category_item/player_setup_item/player_global/ui/save_preferences(datum/pref_record_writer/writer)

	var/decl/ui_style/ui_style = GET_DECL(pref.UI_style)
	writer.write("UI_style", ui_style.uid)

	writer.write("icon_size",                pref.icon_size)
	writer.write("UI_mouseover_color",       pref.UI_mouseover_color)
	writer.write("UI_mouseover_alpha",       pref.UI_mouseover_alpha)
	writer.write("UI_style_color",           pref.UI_style_color)
	writer.write("UI_style_highlight_color", pref.UI_style_highlight_color)
	writer.write("UI_style_alpha",           pref.UI_style_alpha)
	writer.write("ooccolor",                 pref.ooccolor)
	writer.write("clientfps",                pref.clientfps)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()

	var/list/all_ui_style_types = list()
	for(var/decl/ui_style/style in get_ui_styles())
		all_ui_style_types |= style.type

	pref.UI_style                 = sanitize_inlist(pref.UI_style, all_ui_style_types, all_ui_style_types[1])
	pref.UI_mouseover_color       = sanitize_hexcolor(pref.UI_mouseover_color, initial(pref.UI_mouseover_color))
	pref.UI_mouseover_alpha       = sanitize_integer(pref.UI_mouseover_alpha, 0, 255, initial(pref.UI_mouseover_alpha))
	pref.UI_style_color	          = sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_highlight_color = sanitize_hexcolor(pref.UI_style_highlight_color, initial(pref.UI_style_highlight_color))
	pref.UI_style_alpha	          = sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor                 = sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.clientfps                = sanitize_integer(pref.clientfps, CLIENT_MIN_FPS, CLIENT_MAX_FPS, initial(pref.clientfps))

	if(!isnum(pref.icon_size))
		pref.icon_size = initial(pref.icon_size)
	pref.client?.SetWindowIconSize(pref.icon_size)

/datum/category_item/player_setup_item/player_global/ui/proc/get_ui_table(var/mob/user)
	LAZYINITLIST(.)
	. += "<tr><td>UI Color</td>"
	. += "<td><a href='byond://?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a></td>"
	. += "<td><table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table></td>"
	. += "<td><a href='byond://?src=\ref[src];reset=ui'>reset</a></td>"
	. += "</tr>"
	. += "<tr><td>UI Highlight</td>"
	. += "<td><a href='byond://?src=\ref[src];select_highlight_color=1'><b>[pref.UI_style_highlight_color]</b></a></td>"
	. += "<td><table style='display:inline;' bgcolor='[pref.UI_style_highlight_color]'><tr><td>__</td></tr></table></td>"
	. += "<td><a href='byond://?src=\ref[src];reset=highlight'>reset</a></td>"
	. += "</tr>"
	. += "<tr><td>UI Opacity</td>"
	. += "<td colspan = 2><a href='byond://?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a></td>"
	. += "<td><a href='byond://?src=\ref[src];reset=alpha'>reset</a></td>"
	. += "</tr>"

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. = "<b>UI Settings</b><br>"

	var/decl/ui_style/current_style = GET_DECL(pref.UI_style)
	. += "<b>UI Style:</b> <a href='byond://?src=\ref[src];select_style=1'><b>[current_style.name]</b></a><br>"

	. += "<b>Custom UI</b> (recommended for White UI):"
	. += "<table style='margin: 0px auto; padding: 1px;'>"
	. += jointext(get_ui_table(), null)
	. += "</table><br>"
	. += "<b>Tooltip Style:</b> <a href='byond://?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltip_style]</b></a><br>"
	. += "<b>Default icon size:</b> <a href='byond://?src=\ref[src];select_icon_size=1'>[pref.icon_size]x[pref.icon_size]</a><br>"

	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='byond://?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='byond://?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table> <a href='byond://?src=\ref[src];reset=ooc'>reset</a><br>"
	. += "<b>Client FPS:</b> <a href='byond://?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)

	if(href_list["select_style"])
		var/decl/ui_style/current_style = GET_DECL(pref.UI_style)
		var/decl/ui_style/UI_style_new = input(user, "Choose UI style.", CHARACTER_PREFERENCE_INPUT_TITLE, current_style) as null|anything in get_ui_styles()
		if(!istype(UI_style_new) || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style = UI_style_new.type
		if(!isnull(UI_style_new.default_color))
			pref.UI_style_color = UI_style_new.default_color
		if(!isnull(UI_style_new.default_alpha))
			pref.UI_style_alpha = UI_style_new.default_alpha
		. = TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		. = TOPIC_REFRESH

	else if(href_list["select_highlight_color"])
		var/UI_style_highlight_color_new = input(user, "Choose UI highlight color, dark colors are not recommended!", "Global Preference", pref.UI_style_highlight_color) as color|null
		if(isnull(UI_style_highlight_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_highlight_color = UI_style_highlight_color_new
		. = TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		. = TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("highlight")
				pref.UI_style_highlight_color = initial(pref.UI_style_highlight_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("mouseover_color")
				pref.UI_mouseover_color = initial(pref.UI_mouseover_color)
			if("mouseover_alpha")
				pref.UI_mouseover_alpha = initial(pref.UI_mouseover_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		// This is overkill, but we do not currently have a way to tell what elements should grab a new color or alpha.
		// TODO: maybe limit or debounce/queue this?
		user.hud_reset(TRUE)
		return

	if(href_list["select_ooc_color"])
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
			pref.clientfps = clamp(new_fps, CLIENT_MIN_FPS, CLIENT_MAX_FPS)
			pref.client?.apply_fps(pref.clientfps)
			return TOPIC_REFRESH

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = input(user, "Choose tooltip style.", "Global Preference", pref.tooltip_style) as null|anything in all_tooltip_styles
		if(!tooltip_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.tooltip_style = tooltip_style_new
		return TOPIC_REFRESH

	else if(href_list["select_icon_size"])
		var/new_icon_size = input(user, "Enter a new default icon size.", "Default Icon Size", pref.icon_size) as null|anything in global.valid_icon_sizes
		if(new_icon_size && pref.icon_size != new_icon_size)
			pref.icon_size = new_icon_size
			pref.client?.SetWindowIconSize(pref.icon_size)
			return TOPIC_REFRESH

	return ..()

/proc/can_select_ooc_color(var/mob/user)
	return get_config_value(/decl/config/toggle/admin_ooccolor) && check_rights(R_ADMIN, 0, user)
