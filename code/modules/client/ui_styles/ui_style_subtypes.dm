// Midnight just uses base type defaults since that's where they came from.
/decl/ui_style/midnight
	name = "Midnight"
	uid  = "ui_style_midnight"

/decl/ui_style/orange
	name = "Orange"
	uid  = "ui_style_orange"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/orange/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/orange/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/orange/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/orange/interaction_drop.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/orange/interaction_throw.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/orange/interaction_resist.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/orange/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/orange/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/orange/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/orange/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/orange/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/orange/modifiers.dmi'
	)

/decl/ui_style/old
	name = "Old"
	uid  = "ui_style_old"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/old/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/old/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/old/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/old/interaction_drop.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/old/interaction_throw.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/old/interaction_resist.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/old/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/old/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/old/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/old/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/old/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/old/modifiers.dmi'
	)

/decl/ui_style/old_noborder
	name = "Old (no border)"
	uid  = "ui_style_old_noborder"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/old/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/old/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/old/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/old/interaction_drop.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/old/interaction_throw.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/old/interaction_resist.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/old/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/old_noborder/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/old/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/old_noborder/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/old_noborder/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/old_noborder/modifiers.dmi'
	)

/decl/ui_style/white
	name = "White"
	uid  = "ui_style_white"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/white/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/white/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/white/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/white/interaction_drop.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/white/interaction_throw.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/white/interaction_resist.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/white/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/white/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/white/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/white/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/white/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/white/modifiers.dmi'
	)
	use_overlay_color = TRUE
	use_ui_color      = TRUE

/decl/ui_style/minimalist
	name = "Minimalist"
	uid  = "ui_style_minimalist"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/minimalist/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/minimalist/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/minimalist/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/minimalist/interaction_drop.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/minimalist/interaction_resist.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/minimalist/interaction_throw.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/minimalist/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/minimalist/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/minimalist/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/minimalist/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/minimalist/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/minimalist/modifiers.dmi'
	)
	use_overlay_color = TRUE
	use_ui_color      = TRUE

/decl/ui_style/underworld
	name = "Underworld"
	uid  = "ui_style_underworld"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/underworld/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/underworld/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/underworld/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/underworld/interaction_drop.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/underworld/interaction_resist.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/underworld/interaction_throw.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/underworld/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/underworld/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/underworld/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/underworld/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/underworld/zone_selector.dmi',
		(HUD_MODIFIERS)   = 'icons/mob/screen/styles/underworld/modifiers.dmi'
	)
	use_overlay_color = TRUE
	use_ui_color = TRUE

/decl/ui_style/robot
	name = "Stationbound"
	uid = "ui_style_robot"
	override_icons = list(
		(HUD_ATTACK)      = 'icons/mob/screen/styles/robot/attack_selector.dmi',
		(HUD_FIRE_INTENT) = 'icons/mob/screen/styles/robot/fire_intent.dmi',
		(HUD_HANDS)       = 'icons/mob/screen/styles/robot/hands.dmi',
		(HUD_DROP)        = 'icons/mob/screen/styles/robot/interaction_drop.dmi',
		(HUD_THROW)       = 'icons/mob/screen/styles/robot/interaction_throw.dmi',
		(HUD_RESIST)      = 'icons/mob/screen/styles/robot/interaction_resist.dmi',
		(HUD_MANEUVER)    = 'icons/mob/screen/styles/robot/interaction_maneuver.dmi',
		(HUD_INVENTORY)   = 'icons/mob/screen/styles/robot/inventory.dmi',
		(HUD_MOVEMENT)    = 'icons/mob/screen/styles/robot/movement.dmi',
		(HUD_UP_HINT)     = 'icons/mob/screen/styles/robot/uphint.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/robot/zone_selector.dmi'
	)
