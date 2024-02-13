/decl/ui_style
	abstract_type = /decl/ui_style
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// Whether or not this style is selectable in preferences.
	var/restricted = FALSE
	/// A descriptive string.
	var/name
	/// Associative mapping of UI icon key to icon file.
	var/list/icons = list(
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
		UI_ICON_STATUS_FIRE = 'icons/mob/screen/styles/status_fire.dmi',
		UI_ICON_STATUS      = 'icons/mob/screen/styles/status.dmi',
		UI_ICON_UP_HINT     = 'icons/mob/screen/styles/midnight/uphint.dmi',
		UI_ICON_ZONE_SELECT = 'icons/mob/screen/styles/midnight/zone_selector.dmi',
		UI_ICON_CHARGE      = 'icons/mob/screen/styles/charge.dmi'
	)
	/// A subset of UI keys to icon files used to override the above.
	var/list/override_icons

/decl/ui_style/Initialize()
	for(var/ui_key in override_icons)
		icons[ui_key] = override_icons[ui_key]
	return ..()

/decl/ui_style/validate()
	. = ..()
	if(!istext(name))
		. += "invalid name: [name || "NULL"]"

	// Validate we have icons and states as expected.
	var/list/states_to_check = get_expected_states()
	for(var/ui_key in global._ui_all_keys)
		if(!(ui_key in icons))
			. += "no entry for UI key [ui_key]"
			continue
		var/check_icon = icons[ui_key]
		var/list/missing_states  = list()
		var/list/checking_states = states_to_check[ui_key]
		var/list/remaining_states = icon_states(check_icon)
		for(var/check_state in checking_states)
			remaining_states -= check_state
			if(!check_state_in_icon(check_state, check_icon))
				missing_states |= check_state
		if(length(remaining_states))
			. += "icon [check_icon] for key [ui_key] has extraneous states: '[jointext(remaining_states, "', '")]'"
		if(length(missing_states))
			. += "icon [check_icon] for key [ui_key] is missing states: '[jointext(missing_states, "', '")]'"

/decl/ui_style/proc/get_icon(var/ui_key)
	return istext(ui_key) && length(icons) ? icons[ui_key] : null
