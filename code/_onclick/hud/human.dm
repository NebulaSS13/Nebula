/mob/living/carbon/human
	hud_type = /datum/hud/human

/datum/hud/human/FinalizeInstantiation()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	var/mob/living/carbon/human/target = mymob
	var/datum/hud_data/hud_data = istype(target) ? target.species.hud : new()
	if(hud_data.icon)
		ui_style = hud_data.icon

	hotkeybuttons = list() //These can be disabled for hotkey usersx

	stamina_bar = new(null, mymob)
	adding += stamina_bar

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		action_intent = new(null, mymob)
		src.adding += action_intent
		hud_elements |= action_intent

	if(hud_data.has_m_intent)
		move_intent = new(null, mymob, ui_style, ui_color, ui_alpha)
		move_intent.icon_state = mymob.move_intent.hud_icon_state
		src.adding += move_intent

	if(hud_data.has_drop)
		src.hotkeybuttons += new /obj/screen/drop(null, mymob, ui_style, ui_color, ui_alpha)

	if(hud_data.has_resist)
		src.hotkeybuttons += new /obj/screen/resist(null, mymob, ui_style, ui_color, ui_alpha)

	mymob.maneuver_icon = new(null, mymob, ui_style, ui_color, ui_alpha)
	src.hotkeybuttons += mymob.maneuver_icon
	hud_elements |= mymob.maneuver_icon

	if(hud_data.has_throw)
		mymob.throw_icon = new(null, mymob, ui_style, ui_color, ui_alpha)
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

	if(hud_data.has_internals)
		mymob.internals = new(null, mymob, ui_style)
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.healths = new(null, mymob, ui_style)
		hud_elements |= mymob.healths

		mymob.oxygen = new(null, mymob)
		hud_elements |= mymob.oxygen

		mymob.toxin = new(null, mymob)
		hud_elements |= mymob.toxin

		mymob.fire = new(null, mymob, ui_style)
		hud_elements |= mymob.fire

	if(hud_data.has_pressure)
		mymob.pressure = new(null, mymob)
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new(null, mymob)
		hud_elements |= mymob.bodytemp

	if(target.isSynthetic())
		target.cells = new(null, mymob)
		hud_elements |= target.cells

	else if(hud_data.has_nutrition)
		mymob.nutrition_icon = new(null, mymob)
		hud_elements |= mymob.nutrition_icon

		mymob.hydration_icon = new(null, mymob)
		hud_elements |= mymob.hydration_icon

	if(hud_data.has_up_hint)
		mymob.up_hint = new(null, mymob, ui_style)
		hud_elements |= mymob.up_hint

	mymob.pain = new(null, mymob)
	hud_elements |= mymob.pain

	mymob.zone_sel = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.zone_sel.update_icon()
	hud_elements |= mymob.zone_sel

	target.attack_selector = new(null, mymob, ui_style, ui_color, ui_alpha)
	hud_elements |= target.attack_selector

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new(null, mymob, ui_style, ui_color, ui_alpha)
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon  = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.gun_move_icon  = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.radio_use_icon = new(null, mymob, ui_style, ui_color, ui_alpha)

	..()

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1
