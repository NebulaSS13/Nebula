GLOBAL_VAR_CONST(PREF_SHOW_HOLD_SHIFT, "While Holding Shift")

/datum/client_preference/show_mouseover_highlights
	description ="Mouseover Highlights"
	key = "SHOW_MOUSEOVER_HIGHLIGHT"
	options = list(GLOB.PREF_SHOW_HOLD_SHIFT, GLOB.PREF_HIDE, GLOB.PREF_SHOW)

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	. = ..()
	if(.)
		return 
	if(href_list["select_mouseover_color"])
		var/UI_mouseover_color_new = input(user, "Choose mouseover color, dark colors are not recommended!", "Global Preference", pref.UI_mouseover_color) as color|null
		if(isnull(UI_mouseover_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_mouseover_color = UI_mouseover_color_new
		if(user?.client?.current_highlight)
			user.client.current_highlight = null
		return TOPIC_REFRESH
	else if(href_list["select_mouseover_alpha"])
		var/UI_mouseover_alpha_new = input(user, "Select mouseover alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_mouseover_alpha) as num|null
		if(isnull(UI_mouseover_alpha_new) || (UI_mouseover_alpha_new < 50 || UI_mouseover_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_mouseover_alpha = UI_mouseover_alpha_new
		if(user?.client?.current_highlight)
			user.client.current_highlight = null
		return TOPIC_REFRESH

/datum/category_item/player_setup_item/player_global/ui/get_ui_table(var/mob/user)
	. = ..() || list()
	. += "<tr><td>UI Mouseover Color</td>"
	. += "<td><a href='?src=\ref[src];select_mouseover_color=1'><b>[pref.UI_mouseover_color]</b></a></td>"
	. += "<td><table style='display:inline;' bgcolor='[pref.UI_mouseover_color]'><tr><td>__</td></tr></table></td>"
	. += "<td><a href='?src=\ref[src];reset=mouseover_color'>reset</a></td>"
	. += "</tr>"
	. += "<tr><td>UI Mouseover Opacity</td>"
	. += "<td colspan = 2><a href='?src=\ref[src];select_mouseover_alpha=1'><b>[pref.UI_mouseover_alpha]</b></a></td>"
	. += "<td><a href='?src=\ref[src];reset=mouseover_alpha'>reset</a></td>"
	. += "</tr>"
