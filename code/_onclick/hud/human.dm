/mob/living/carbon/human
	hud_used = /datum/hud/human

/decl/hud_element/attack_selector
	screen_object_type = /obj/screen/default_attack_selector
	hud_element_category = /decl/hud_element/attack_selector

/decl/hud_element/attack_selector/register_screen_object(var/obj/screen/elem, var/datum/hud/hud)
	var/obj/screen/default_attack_selector/attack_selector = elem
	if(istype(attack_selector) && ishuman(hud.mymob))
		attack_selector.set_owner(hud.mymob)
		attack_selector.update_icon()
	return ..()

/datum/hud/human
	health_hud_type = /decl/hud_element/health/human
	hud_elements = list(
		/decl/hud_element/health/human,
		/decl/hud_element/condition/bodytemp,
		/decl/hud_element/attack_selector,
		/decl/hud_element/zone_selector,
		/decl/hud_element/move_intent,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/pressure,
		/decl/hud_element/condition/fire,
		/decl/hud_element/condition/toxins,
		/decl/hud_element/condition/oxygen,
		/decl/hud_element/condition/nutrition,
		/decl/hud_element/condition/hydration,
		/decl/hud_element/stamina_bar,
		/decl/hud_element/drop,
		/decl/hud_element/resist,
		/decl/hud_element/throwing,
		/decl/hud_element/up_hint,
		/decl/hud_element/pain,
		/decl/hud_element/internals,
		/decl/hud_element/gun_mode,
		/decl/hud_element/gun_flag_item,
		/decl/hud_element/gun_flag_move,
		/decl/hud_element/gun_flag_radio
	)

/datum/hud/human/get_ui_style()
	var/decl/species/my_species = mymob?.get_species()
	var/datum/hud_data/hud_data = my_species?.hud || new
	if(hud_data?.icon)
		return hud_data.icon
	return ..()

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen |= hud_used.hotkey_hud_elements
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkey_hud_elements
		hud_used.hotkey_ui_hidden = 1

// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.
/obj/screen/food/Click(var/location, var/control, var/params)
	if(usr.get_hud_element(/decl/hud_element/condition/nutrition) == src)
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
	if(usr.get_hud_element(/decl/hud_element/condition/hydration) == src)
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
	if(usr.get_hud_element(/decl/hud_element/condition/bodytemp) == src)
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
	if(usr.get_hud_element(/decl/hud_element/condition/pressure) == src)
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
	if(usr.get_hud_element(/decl/hud_element/condition/toxins) == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/obj/screen/oxygen/Click(var/location, var/control, var/params)
	if(usr.get_hud_element(/decl/hud_element/condition/oxygen) == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))

/obj/screen/movement/Click(var/location, var/control, var/params)
	if(istype(usr))
		usr.set_next_usable_move_intent()