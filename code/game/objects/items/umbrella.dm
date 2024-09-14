/obj/item/umbrella
	name = "umbrella"
	desc = "It's an umbrella. Good for keeping the rain off."
	icon = 'icons/obj/items/umbrella.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)
	color = COLOR_BEASTY_BROWN
	var/fabric_color = COLOR_GRAY20
	var/tip_color = COLOR_GOLD
	var/is_open = FALSE

/obj/item/umbrella/gives_weather_protection()
	return is_open

/obj/item/umbrella/attack_self(mob/user)
	. = ..()
	if(!.)
		is_open = !is_open
		if(is_open)
			to_chat(user, SPAN_NOTICE("You unfurl and shake out \the [src]."))
			w_class = ITEM_SIZE_LARGE
		else
			to_chat(user, SPAN_NOTICE("You close up \the [src]."))
			w_class = initial(w_class)
		playsound(loc, "rustle", 30, 1)
		update_icon()
		update_held_icon()
		return TRUE

/obj/item/umbrella/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(is_open)
		icon_state = "[icon_state]-open"
	var/image/I = image(icon, "[icon_state]-fabric")
	I.color = fabric_color
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)
	I = image(icon, "[icon_state]-tip")
	I.color = tip_color
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

/obj/item/umbrella/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(is_open && check_state_in_icon("[overlay.icon_state]-open", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-open"
		var/image/I = image(overlay.icon, "[overlay.icon_state]-fabric")
		I.color = fabric_color
		I.appearance_flags |= RESET_COLOR
		overlay.overlays += I
		I = image(overlay.icon, "[overlay.icon_state]-tip")
		I.color = tip_color
		I.appearance_flags |= RESET_COLOR
		overlay.overlays += I
	return ..()

/obj/item/umbrella/blue
	fabric_color = COLOR_BLUE_GRAY
/obj/item/umbrella/green
	fabric_color = COLOR_GREEN_GRAY
/obj/item/umbrella/red
	fabric_color = COLOR_RED_GRAY
/obj/item/umbrella/yellow
	fabric_color = COLOR_YELLOW_GRAY
/obj/item/umbrella/orange
	fabric_color = COLOR_PALE_ORANGE
/obj/item/umbrella/purple
	fabric_color = COLOR_PURPLE_GRAY
