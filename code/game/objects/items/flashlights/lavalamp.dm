//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/flashlight/lamp/lava
	name = "lava lamp"
	desc = "A kitchy throwback decorative light. Noir Edition."
	icon = 'icons/obj/lighting/lavalamp.dmi'
	icon_state = "lavalamp"
	on = 0
	action_button_name = "Toggle lamp"
	flashlight_range = 3 //range of light when on
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/flashlight/lamp/lava/get_emissive_overlay_color()
	return light_color

/obj/item/flashlight/lamp/lava/on_update_icon()
	. = ..()
	if(!on) // This is handled for lit lamps in the parent call.
		var/image/I = emissive_overlay(icon, "[icon_state]-over")
		I.color = get_emissive_overlay_color()
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/flashlight/lamp/lava/red
	desc = "A kitchy red decorative light."
	light_color = COLOR_RED

/obj/item/flashlight/lamp/lava/blue
	desc = "A kitchy blue decorative light"
	light_color = COLOR_BLUE

/obj/item/flashlight/lamp/lava/cyan
	desc = "A kitchy cyan decorative light"
	light_color = COLOR_CYAN

/obj/item/flashlight/lamp/lava/green
	desc = "A kitchy green decorative light"
	light_color = COLOR_GREEN

/obj/item/flashlight/lamp/lava/orange
	desc = "A kitchy orange decorative light"
	light_color = COLOR_ORANGE

/obj/item/flashlight/lamp/lava/purple
	desc = "A kitchy purple decorative light"
	light_color = COLOR_PURPLE
/obj/item/flashlight/lamp/lava/pink
	desc = "A kitchy pink decorative light"
	light_color = COLOR_PINK

/obj/item/flashlight/lamp/lava/yellow
	desc = "A kitchy yellow decorative light"
	light_color = COLOR_YELLOW
