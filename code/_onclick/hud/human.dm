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

	adding = list()
	other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/obj/screen/using

	stamina_bar = new
	adding += stamina_bar

	BuildInventoryUI()

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		using = new /obj/screen/intent()
		src.adding += using
		action_intent = using
		hud_elements |= using

	if(hud_data.has_m_intent)
		using = new /obj/screen/movement()
		using.SetName("movement method")
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.screen_loc = ui_movi
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.SetName("drop")
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_hands)
		BuildHandsUI()

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.SetName("resist")
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_throw)
		mymob.throw_icon = new /obj/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.SetName("throw")
		mymob.throw_icon.screen_loc = ui_drop_throw
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		src.hotkeybuttons += mymob.throw_icon
		hud_elements |= mymob.throw_icon

	if(hud_data.has_internals)
		mymob.internals = new /obj/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.SetName("internal")
		mymob.internals.screen_loc = ui_internal
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.healths = new /obj/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = ui_health
		hud_elements |= mymob.healths

		mymob.oxygen = new /obj/screen/oxygen()
		mymob.oxygen.icon = 'icons/mob/status_indicators.dmi'
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.SetName("oxygen")
		mymob.oxygen.screen_loc = ui_temp
		hud_elements |= mymob.oxygen

		mymob.toxin = new /obj/screen/toxins()
		mymob.toxin.icon = 'icons/mob/status_indicators.dmi'
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.SetName("toxin")
		mymob.toxin.screen_loc = ui_temp
		hud_elements |= mymob.toxin

		mymob.fire = new /obj/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.SetName("fire")
		mymob.fire.screen_loc = ui_fire
		hud_elements |= mymob.fire

	if(hud_data.has_pressure)
		mymob.pressure = new /obj/screen/pressure()
		mymob.pressure.icon = 'icons/mob/status_indicators.dmi'
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.SetName("pressure")
		mymob.pressure.screen_loc = ui_temp
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /obj/screen/bodytemp()
		mymob.bodytemp.icon = 'icons/mob/status_indicators.dmi'
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.SetName("body temperature")
		mymob.bodytemp.screen_loc = ui_temp
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
		mymob.nutrition_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.nutrition_icon.pixel_w = 8
		mymob.nutrition_icon.icon_state = "nutrition1"
		mymob.nutrition_icon.SetName("nutrition")
		mymob.nutrition_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.nutrition_icon

		mymob.hydration_icon = new /obj/screen/drink()
		mymob.hydration_icon.icon = 'icons/mob/status_hunger.dmi'
		mymob.hydration_icon.icon_state = "hydration1"
		mymob.hydration_icon.SetName("hydration")
		mymob.hydration_icon.screen_loc = ui_nutrition_small
		hud_elements |= mymob.hydration_icon

	if(hud_data.has_up_hint)
		mymob.up_hint = new /obj/screen()
		mymob.up_hint.icon = ui_style
		mymob.up_hint.icon_state = "uphint0"
		mymob.up_hint.SetName("up hint")
		mymob.up_hint.screen_loc = ui_up_hint
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

	mymob.client.screen = list()
	if(length(hand_hud_objects))
		mymob.client.screen += hand_hud_objects
	if(length(swaphand_hud_objects))
		mymob.client.screen += swaphand_hud_objects
	if(length(hud_elements))
		mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons

	hide_inventory()

	hidden_inventory_update()
	persistant_inventory_update()

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

// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.

/obj/screen/food/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.nutrition_icon == src)
		switch(icon_state)
			if("nutrition0")
				to_chat(usr, SPAN_WARNING("You are completely stuffed."))
			if("nutrition1")
				to_chat(usr, SPAN_NOTICE("You are not hungry."))
			if("nutrition2")
				to_chat(usr, SPAN_NOTICE("You are a bit peckish."))
			if("nutrition3")
				to_chat(usr, SPAN_WARNING("You are quite hungry."))
			if("nutrition4")
				to_chat(usr, SPAN_DANGER("You are starving!"))

/obj/screen/drink/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.hydration_icon == src)
		switch(icon_state)
			if("hydration0")
				to_chat(usr, SPAN_WARNING("You are overhydrated."))
			if("hydration1")
				to_chat(usr, SPAN_NOTICE("You are not thirsty."))
			if("hydration2")
				to_chat(usr, SPAN_NOTICE("You are a bit thirsty."))
			if("hydration3")
				to_chat(usr, SPAN_WARNING("You are quite thirsty."))
			if("hydration4")
				to_chat(usr, SPAN_DANGER("You are dying of thirst!"))

/obj/screen/bodytemp/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.bodytemp == src)
		switch(icon_state)
			if("temp4")
				to_chat(usr, SPAN_DANGER("You are being cooked alive!"))
			if("temp3")
				to_chat(usr, SPAN_DANGER("Your body is burning up!"))
			if("temp2")
				to_chat(usr, SPAN_DANGER("You are overheating."))
			if("temp1")
				to_chat(usr, SPAN_WARNING("You are uncomfortably hot."))
			if("temp-4")
				to_chat(usr, SPAN_DANGER("You are being frozen solid!"))
			if("temp-3")
				to_chat(usr, SPAN_DANGER("You are freezing cold!"))
			if("temp-2")
				to_chat(usr, SPAN_WARNING("You are dangerously chilled!"))
			if("temp-1")
				to_chat(usr, SPAN_NOTICE("You are uncomfortably cold."))
			else
				to_chat(usr, SPAN_NOTICE("Your body is at a comfortable temperature."))

/obj/screen/pressure/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.pressure == src)
		switch(icon_state)
			if("pressure2")
				to_chat(usr, SPAN_DANGER("The air pressure here is crushing!"))
			if("pressure1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously high."))
			if("pressure-1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously low."))
			if("pressure-2")
				to_chat(usr, SPAN_DANGER("There is nearly no air pressure here!"))
			else
				to_chat(usr, SPAN_NOTICE("The local air pressure is comfortable."))

/obj/screen/toxins/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.toxin == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/obj/screen/oxygen/Click(var/location, var/control, var/params)
	if(istype(usr) && usr.oxygen == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))

/obj/screen/movement/Click(var/location, var/control, var/params)
	if(istype(usr))
		usr.set_next_usable_move_intent()