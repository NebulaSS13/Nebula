/obj/item/energy_blade/sword
	name = "energy sword"
	desc = "May the force be mass times acceleration."
	icon = 'icons/obj/items/weapon/e_sword.dmi'
	origin_tech = @'{"magnets":3,"esoteric":4}'
	active_parry_chance = 50

	var/blade_color
	var/static/list/blade_colors = list(
		COLOR_RED =    COLOR_SABER_RED,
		COLOR_CYAN =   COLOR_SABER_BLUE,
		COLOR_LIME =   COLOR_SABER_GREEN,
		COLOR_VIOLET = COLOR_SABER_PURPLE
	)

/obj/item/energy_blade/sword/Initialize()
	if(!blade_color)
		blade_color = pick(blade_colors)
		lighting_color = blade_colors[blade_color]
	if(!lighting_color)
		lighting_color = blade_color
	. = ..()

/obj/item/energy_blade/sword/is_special_cutting_tool(var/high_power)
	return active && !high_power

/obj/item/energy_blade/sword/dropped(var/mob/user)
	..()
	addtimer(CALLBACK(src, PROC_REF(check_loc)), 1) // Swapping hands or passing to another person should not deactivate the sword.

/obj/item/energy_blade/sword/proc/check_loc()
	if(!ismob(loc) && active)
		toggle_active()

/obj/item/energy_blade/sword/on_update_icon()
	. = ..()
	if(active && check_state_in_icon("[icon_state]-extended-glow", icon))
		var/image/I
		if(plane == HUD_PLANE)
			I = image(icon, "[icon_state]-extended-glow")
		else
			I = emissive_overlay(icon, "[icon_state]-extended-glow")
		I.color = blade_color
		add_overlay(I)

/obj/item/energy_blade/sword/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && active && check_state_in_icon("[overlay.icon_state]-extended-glow", overlay.icon))
		overlay.overlays += emissive_overlay(overlay.icon, "[overlay.icon_state]-extended-glow", color = blade_color)
	return ..()

// Subtypes
/obj/item/energy_blade/sword/green
	blade_color = COLOR_LIME

/obj/item/energy_blade/sword/red
	blade_color = COLOR_RED

/obj/item/energy_blade/sword/blue
	blade_color = COLOR_BLUE

/obj/item/energy_blade/sword/purple
	blade_color = COLOR_VIOLET
