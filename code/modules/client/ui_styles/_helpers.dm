/proc/get_ui_styles(var/filter_available = TRUE)
	var/list/all_ui_styles = decls_repository.get_decls_of_subtype(/decl/ui_style)
	for(var/ui_type in all_ui_styles)
		var/decl/ui_style/ui = all_ui_styles[ui_type]
		if(!ui.restricted || !filter_available)
			LAZYADD(., ui)

/proc/get_default_ui_icon(ui_key)
	var/static/list/default_icons = list(
		UI_ICON_ATTACK      = 'icons/mob/screen/styles/midnight/attack_selector.dmi',
		UI_ICON_FIRE_INTENT = 'icons/mob/screen/styles/midnight/fire_intent.dmi',
		UI_ICON_HANDS       = 'icons/mob/screen/styles/midnight/hands.dmi',
		UI_ICON_HEALTH      = 'icons/mob/screen/styles/health.dmi',
		UI_ICON_CRIT_MARKER = 'icons/mob/screen/styles/crit_markers.dmi',
		UI_ICON_HYDRATION   = 'icons/mob/screen/styles/hydration.dmi',
		UI_ICON_INTENT      = 'icons/mob/screen/styles/intents.dmi',
		UI_ICON_INTERACTION = 'icons/mob/screen/styles/midnight/interaction.dmi',
		UI_ICON_INTERNALS   = 'icons/mob/screen/styles/internals.dmi',
		UI_ICON_INVENTORY   = 'icons/mob/screen/styles/midnight/inventory.dmi',
		UI_ICON_MOVEMENT    = 'icons/mob/screen/styles/midnight/movement.dmi',
		UI_ICON_NUTRITION   = 'icons/mob/screen/styles/nutrition.dmi',
		UI_ICON_STATUS      = 'icons/mob/screen/styles/status.dmi',
		UI_ICON_UP_HINT     = 'icons/mob/screen/styles/midnight/uphint.dmi',
		UI_ICON_ZONE_SELECT = 'icons/mob/screen/styles/midnight/zone_selector.dmi'
	)
	return istext(ui_key) ? default_icons[ui_key] : null

/proc/get_ui_icon(ui_style, ui_key)
	var/decl/ui_style/style = GET_DECL(ui_style)
	return style?.get_icon(ui_key) || get_default_ui_icon(ui_key)
