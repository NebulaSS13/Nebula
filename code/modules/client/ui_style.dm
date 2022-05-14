

var/global/all_ui_styles = list(
	"Midnight"     = 'icons/mob/screen/midnight.dmi',
	"Orange"       = 'icons/mob/screen/orange.dmi',
	"Old"          = 'icons/mob/screen/old.dmi',
	"White"        = 'icons/mob/screen/white.dmi',
	"Old-noborder" = 'icons/mob/screen/old-noborder.dmi',
	"Minimalist"   = 'icons/mob/screen/minimalist.dmi'
	)

var/global/all_tooltip_styles = list(
	"Midnight", //Default for everyone is the first one,
	"Plasmafire",
	"Retro",
	"Slimecore",
	"Operative",
	"Clockwork"
	)

/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	return all_ui_styles["White"]


/client/verb/change_ui()
	set name = "Change UI"
	set desc = "Configure your user interface"
	set category = "OOC"

	if(!ishuman(mob))
		to_chat(src, SPAN_WARNING("You must be human to use this verb."))
		return

	var/UI_style_new = input(src, "Select a style. White is recommended for customization", "Change UI: Style", prefs.UI_style) as null|anything in global.all_ui_styles
	if(!UI_style_new)
		return

	var/UI_style_color_new = input(src, "Choose your UI color. Dark colors are not recommended!", "Change UI: Color", prefs.UI_style_color) as color|null
	if(!UI_style_color_new)
		return

	var/UI_style_alpha_new = input(src, "Select a new alpha (transparency) parameter for your UI, between 50 and 255", "Change UI: Alpha", prefs.UI_style_alpha) as null|num
	if(!UI_style_alpha_new)
		return

	UI_style_alpha_new = clamp(UI_style_alpha_new, 50, 255)

	var/list/icons = mob.hud_used.adding + mob.hud_used.other + mob.hud_used.hotkeybuttons

	icons.Add(
		mob.zone_sel,
		mob.gun_setting_icon,
		mob.item_use_icon,
		mob.gun_move_icon,
		mob.radio_use_icon
	)

	var/icon/UI_style_icon_new = all_ui_styles[UI_style_new]

	apply_ui_style(icons, UI_style_icon_new, UI_style_color_new, UI_style_alpha_new)

	if(alert("Like it? Save changes?",,"Yes", "No") == "Yes")
		prefs.UI_style = UI_style_new
		prefs.UI_style_alpha = UI_style_alpha_new
		prefs.UI_style_color = UI_style_color_new
		SScharacter_setup.queue_preferences_save(prefs)
		to_chat(usr, "Your UI settings were saved.")
	else
		apply_ui_style(icons)

/client/proc/apply_ui_style(list/atoms, ui_icon = all_ui_styles[prefs.UI_style], ui_color = prefs.UI_style_color, ui_alpha = prefs.UI_style_alpha)
	for(var/obj/screen/S in atoms)
		if(!(S.name in list(I_HELP, I_HURT, I_DISARM, I_GRAB)))
			S.icon = ui_icon
			S.color = ui_color
			S.alpha = ui_alpha
