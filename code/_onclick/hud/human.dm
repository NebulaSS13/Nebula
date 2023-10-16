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

	var/obj/screen/using

	stamina_bar = new
	adding += stamina_bar

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		using = new /obj/screen/intent()
		src.adding += using
		action_intent = using
		hud_elements |= using

	if(hud_data.has_m_intent)
		using = new /obj/screen/movement()
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen/drop()
		using.icon = ui_style
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_resist)
		using = new /obj/screen/resist()
		using.icon = ui_style
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	mymob.maneuver_icon       = new
	mymob.maneuver_icon.icon  = ui_style
	mymob.maneuver_icon.color = ui_color
	mymob.maneuver_icon.alpha = ui_alpha
	src.hotkeybuttons += mymob.maneuver_icon
	hud_elements |= mymob.maneuver_icon

	if(hud_data.has_throw)
		mymob.throw_icon = new /obj/screen/throw_toggle(null)
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

	if(hud_data.has_internals)
		mymob.internals = new /obj/screen/internals()
		mymob.internals.icon = ui_style
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.healths = new /obj/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = ui_health
		hud_elements |= mymob.healths

		mymob.oxygen = new /obj/screen/oxygen()
		hud_elements |= mymob.oxygen

		mymob.toxin = new /obj/screen/toxins()
		hud_elements |= mymob.toxin

		mymob.fire = new /obj/screen/fire_warning()
		mymob.fire.icon = ui_style
		hud_elements |= mymob.fire

	if(hud_data.has_pressure)
		mymob.pressure = new /obj/screen/pressure()
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /obj/screen/bodytemp()
		hud_elements |= mymob.bodytemp

	if(target.isSynthetic())
		target.cells = new /obj/screen()
		target.cells.icon = 'icons/mob/screen1_robot.dmi'
		target.cells.icon_state = "charge-empty"
		target.cells.SetName("cell")
		target.cells.screen_loc = ui_nutrition
		hud_elements |= target.cells

	else if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /obj/screen/food()
		hud_elements |= mymob.nutrition_icon

		mymob.hydration_icon = new /obj/screen/drink()
		hud_elements |= mymob.hydration_icon

	if(hud_data.has_up_hint)
		mymob.up_hint = new /obj/screen/up_hint()
		mymob.up_hint.icon = ui_style
		hud_elements |= mymob.up_hint

	mymob.pain = new /obj/screen/fullscreen/pain( null )
	hud_elements |= mymob.pain

	mymob.zone_sel = new
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.update_icon()
	hud_elements |= mymob.zone_sel

	target.attack_selector = new
	target.attack_selector.set_owner(target)
	target.attack_selector.icon = ui_style
	target.attack_selector.color = ui_color
	target.attack_selector.alpha = ui_alpha
	target.attack_selector.update_icon()
	hud_elements |= target.attack_selector

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.gun_setting_icon.icon = ui_style
	mymob.gun_setting_icon.color = ui_color
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /obj/screen/gun/item(null)
	mymob.item_use_icon.icon = ui_style
	mymob.item_use_icon.color = ui_color
	mymob.item_use_icon.alpha = ui_alpha

	mymob.gun_move_icon = new /obj/screen/gun/move(null)
	mymob.gun_move_icon.icon = ui_style
	mymob.gun_move_icon.color = ui_color
	mymob.gun_move_icon.alpha = ui_alpha

	mymob.radio_use_icon = new /obj/screen/gun/radio(null)
	mymob.radio_use_icon.icon = ui_style
	mymob.radio_use_icon.color = ui_color
	mymob.radio_use_icon.alpha = ui_alpha

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
