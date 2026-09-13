/decl/mob_modifier/chilled
	name              = "Chilled"
	desc              = "You are half-frozen and slowed."
	hud_icon_state    = "chilled"
	on_add_message_1p = SPAN_DANGER("You feel like you're going to freeze! It's hard to move.")
	on_end_message_1p = SPAN_NOTICE("You feel somewhat warmer and more mobile.")
	mob_overlay_icon  = 'icons/effects/status_modifier.dmi'
	mob_overlay_state = "chilled"

	movement_slowdown         = 2
	click_cooldown_multiplier = 1.4
