/obj/screen/holomap_level_select
	icon = 'icons/misc/mark.dmi'
	layer = HUD_ITEM_LAYER
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/datum/station_holomap/holomap

/obj/screen/holomap_text
	icon = null
	layer = HUD_ITEM_LAYER
	maptext_width = 96
	requires_owner = FALSE
	requires_ui_style = FALSE

/obj/screen/holomap_text/Initialize()
	. = ..()
	appearance_flags |= RESET_COLOR

/obj/screen/holomap_level_select/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, datum/station_holomap/_holomap)
	. = ..()
	holomap = _holomap

/obj/screen/holomap_level_select/handle_click(mob/user, params)
	return !isghost(user)

/obj/screen/holomap_level_select/up
	icon_state = "fup"

/obj/screen/holomap_level_select/up/handle_click(mob/user, params)
	if(..() && holomap)
		holomap.set_level(holomap.displayed_level - 1)

/obj/screen/holomap_level_select/down
	icon_state = "fdn"

/obj/screen/holomap_level_select/down/handle_click(mob/user, params)
	if(..() && holomap)
		holomap.set_level(holomap.displayed_level + 1)

/obj/screen/holomap_legend
	icon = null
	maptext_height = 128
	maptext_width = 128
	layer = HUD_ITEM_LAYER
	pixel_x = HOLOMAP_LEGEND_X
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/saved_color
	var/datum/station_holomap/holomap = null
	var/has_areas = FALSE

/obj/screen/holomap_legend/cursor
	icon = 'icons/misc/holomap_markers.dmi'
	icon_state = "you"
	maptext_x = 11
	pixel_x = HOLOMAP_LEGEND_X - 3
	has_areas = TRUE

/obj/screen/holomap_legend/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, map_color, text)
	. = ..()
	saved_color = map_color
	maptext = "<a href='byond://?src=\ref[src]' style=\"font-family: 'Small Fonts'; color: [map_color]; -dm-text-outline: 1 [COLOR_BLACK]; font-size: 6px\">[text]</a>"
	alpha = 255

/obj/screen/holomap_legend/handle_click(mob/user, params)
	if(!isghost(user) && istype(holomap))
		holomap.legend_select(src)

/obj/screen/holomap_legend/proc/Setup(z_level)
	has_areas = FALSE
	//Get the areas for this z level and mark if we're empty
	overlays.Cut()
	for(var/area/A in SSminimap.holomaps[z_level].holomap_areas)
		if(A.holomap_color == saved_color)
			var/image/area = image(SSminimap.holomaps[z_level].holomap_areas[A])
			area.pixel_x = ((HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_X) - pixel_x
			area.pixel_y = ((HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_Y) - pixel_y
			overlays += area
			has_areas = TRUE

//What happens when we are clicked on / when another is clicked on
/obj/screen/holomap_legend/proc/Select()
	//Start blinking
	animate(src, alpha = 0, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)
	animate(alpha = 254, time = 2, loop = -1, easing = JUMP_EASING | EASE_IN | EASE_OUT)

/obj/screen/holomap_legend/proc/Deselect()
	//Stop blinking
	animate(src, flags = ANIMATION_END_NOW)

//Cursor doesnt do anything specific.
/obj/screen/holomap_legend/cursor/Setup()
	return

/obj/screen/holomap_legend/cursor/Select()
	return

/obj/screen/holomap_legend/cursor/Deselect()
	return
