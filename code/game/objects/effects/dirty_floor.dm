/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	persistent = TRUE
	alpha = 0
	var/dirt_amount = 0

/obj/effect/decal/cleanable/dirt/Initialize()
	. = ..()
	name = ""
	verbs.Cut()

/obj/effect/decal/cleanable/dirt/on_update_icon()
	. = ..()
	if (dirt_amount <= 50)
		alpha = 0
	else
		alpha = min((dirt_amount - 50) * 5, 255)
