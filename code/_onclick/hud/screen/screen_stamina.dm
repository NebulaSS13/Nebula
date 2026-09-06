/obj/screen/stamina
	name              = "stamina"
	icon              = 'icons/effects/staminabar.dmi'
	icon_state        = "bar"
	invisibility      = INVISIBILITY_MAXIMUM
	use_supplied_ui_color = FALSE
	use_supplied_ui_alpha = FALSE
	use_supplied_ui_icon = FALSE
	requires_ui_style = FALSE
	layer = HUD_BASE_LAYER + 0.1 // needs to layer over the movement intent element
	var/const/STAMINA_STATE_PERIOD = 5

/obj/screen/stamina/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	update_icon()

/obj/screen/stamina/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		set_invisibility(INVISIBILITY_MAXIMUM)
		return

	var/hand_row_offset = /datum/hud::HAND_UI_INITIAL_Y_OFFSET + (ceil(length(owner.get_held_item_slots()) / /datum/hud::HAND_UI_PER_ROW) * world.icon_size) + 16
	screen_loc = "CENTER:-32,BOTTOM:[hand_row_offset]"

	var/stamina = owner.get_stamina()
	cut_overlays()
	if(stamina < 100)
		set_invisibility(INVISIBILITY_NONE)
		var/stamina_amt = floor(stamina/STAMINA_STATE_PERIOD)*STAMINA_STATE_PERIOD
		var/bar_overlay_state = "bar_[stamina_amt]"
		if(stamina_amt > 0 && stamina <= 25)
			bar_overlay_state = "[bar_overlay_state]_fail"
		var/image/bar_overlay = image(icon = icon, icon_state = bar_overlay_state)
		bar_overlay.appearance_flags |= RESET_COLOR
		bar_overlay.color = COLOR_WHITE
		add_overlay(bar_overlay)
	else
		set_invisibility(INVISIBILITY_MAXIMUM)
	compile_overlays()