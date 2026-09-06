/decl/ui_style
	abstract_type = /decl/ui_style
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// Whether or not this style is selectable in preferences.
	var/restricted = FALSE
	/// A descriptive string.
	var/name
	/// Associative mapping of UI icon key to icon file.
	var/list/icons = list(
		(HUD_ATTACK)          = 'icons/mob/screen/styles/midnight/attack_selector.dmi',
		(HUD_FIRE_INTENT)     = 'icons/mob/screen/styles/midnight/fire_intent.dmi',
		(HUD_HANDS)           = 'icons/mob/screen/styles/midnight/hands.dmi',
		(HUD_HEALTH)          = 'icons/mob/screen/styles/health.dmi',
		(HUD_CRIT_MARKER)     = 'icons/mob/screen/styles/crit_markers.dmi',
		(HUD_HYDRATION)       = 'icons/mob/screen/styles/hydration.dmi',
		(HUD_RESIST)          = 'icons/mob/screen/styles/midnight/interaction_resist.dmi',
		(HUD_THROW)           = 'icons/mob/screen/styles/midnight/interaction_throw.dmi',
		(HUD_DROP)            = 'icons/mob/screen/styles/midnight/interaction_drop.dmi',
		(HUD_MANEUVER)        = 'icons/mob/screen/styles/midnight/interaction_maneuver.dmi',
		(HUD_INTERNALS)       = 'icons/mob/screen/styles/internals.dmi',
		(HUD_INVENTORY)       = 'icons/mob/screen/styles/midnight/inventory.dmi',
		(HUD_MOVEMENT)        = 'icons/mob/screen/styles/midnight/movement.dmi',
		(HUD_NUTRITION)       = 'icons/mob/screen/styles/nutrition.dmi',
		(HUD_FIRE)            = 'icons/mob/screen/styles/status_fire.dmi',
		(HUD_PRESSURE)        = 'icons/mob/screen/styles/status_pressure.dmi',
		(HUD_BODYTEMP)        = 'icons/mob/screen/styles/status_bodytemp.dmi',
		(HUD_TOX)             = 'icons/mob/screen/styles/status_tox.dmi',
		(HUD_OXY)             = 'icons/mob/screen/styles/status_oxy.dmi',
		(HUD_UP_HINT)         = 'icons/mob/screen/styles/midnight/uphint.dmi',
		(HUD_ZONE_SELECT)     = 'icons/mob/screen/styles/midnight/zone_selector.dmi',
		(HUD_CHARGE)          = 'icons/mob/screen/styles/charge.dmi',
		(HUD_INTENT)          = 'icons/screen/intents.dmi',
		(HUD_MODIFIERS)       = 'icons/mob/screen/styles/midnight/modifiers.dmi'
	)
	/// A subset of UI keys to icon files used to override the above.
	var/list/override_icons
	/// A color to reset this UI to on pref selection.
	var/default_color = COLOR_WHITE
	/// An alpha to reset this UI to on pref selection.
	var/default_alpha = 255
	var/use_overlay_color = FALSE
	var/use_ui_color      = FALSE

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
		var/list/remaining_states = get_states_in_icon(check_icon)
		for(var/check_state in checking_states)
			remaining_states -= check_state
			if(check_state_in_icon(check_state, check_icon))
				check_state = "[check_state]-overlay"
				if(check_state_in_icon(check_state, check_icon))
					remaining_states -= check_state
			else
				missing_states |= check_state

		if(length(remaining_states))
			. += "icon [check_icon] for key [ui_key] has extraneous states: '[jointext(remaining_states, "', '")]'"
		if(length(missing_states))
			. += "icon [check_icon] for key [ui_key] is missing states: '[jointext(missing_states, "', '")]'"

/decl/ui_style/proc/get_icon(var/ui_key)
	return (!isnull(ui_key) && !isnum(ui_key) && length(icons)) ? icons[ui_key] : null
