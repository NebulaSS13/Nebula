// == Updated intent system ==
// - Use mob.get_intent() to retrieve the entire decl structure.
// - Use mob.check_intent(I_FOO) for 1:1 intent type checking.
// - Use mob.check_intent(I_FLAG_FOO) for 'close enough for government work' flag checking.
// - Use mob.set_intent(I_FOO) to set intent to a type
// - Use mob.set_intent(I_FLAG_FOO) to set intent to whatever available type has the flag.
// - Use mob.cycle_intent(INTENT_HOTKEY_LEFT) or mob.cycle_intent(INTENT_HOTKEY_RIGHT) to step up or down the mob intent list.
// - Override mob.get_available_intents() if you want to change the intents from the default four.

// TODO:
// - dynamic intent options based on equipped weapons, species, bodytype of active hand

/proc/resolve_intent(intent)
	RETURN_TYPE(/decl/intent)
	// Legacy, should not proc.
	if(istext(intent))
		intent = decls_repository.get_decl_by_id_or_var(intent, /decl/intent, "name")
	// Saves constantly calling GET_DECL(I_FOO)
	if(ispath(intent, /decl/intent))
		intent = GET_DECL(intent)
	if(istype(intent, /decl/intent))
		return intent
	return null

/decl/intent
	abstract_type    = /decl/intent
	decl_flags       = DECL_FLAG_MANDATORY_UID
	/// Replacing the old usage of I_HARM etc. in attackby() and such. Refer to /mob/proc/check_intent().
	var/intent_flags = 0
	/// Descriptive string used in status panel.
	var/name
	/// Descriptive string shown when examined.
	var/desc
	/// Icon used to draw this intent in the selector.
	var/icon = 'icons/screen/intents.dmi'
	/// State used to update intent selector.
	var/icon_state
	/// Whether or not this intent is available if you have an item in your hand.
	var/requires_empty_hand = FALSE
	/// Intents to be removed from the available list if this intent is present.
	var/list/blocks_other_intents

/decl/intent/validate()
	. = ..()
	if(!istext(name))
		. += "null or invalid name"
	if(!istext(icon_state))
		. += "null or invalid icon_state"
	if(!icon)
		. += "null icon"
	if(icon && istext(icon_state))
		if(!check_state_in_icon(icon_state, icon))
			. += "missing icon_state '[icon_state]' from icon '[icon]'"
		if(!check_state_in_icon("[icon_state]_off", icon))
			. += "missing icon_state '[icon_state]_off' from icon '[icon]'"

// Basic subtypes.
/decl/intent/harm
	name             = "harm"
	desc             = "<b>HARM INTENT</b>: you will attempt to damage, disrupt or destroy whatever you interact with."
	uid              = "intent_harm"
	intent_flags     = I_FLAG_HARM
	icon_state       = "intent_harm"
	sort_order       = 4 // Corresponding to hotkey order.

/decl/intent/grab
	name             = "grab"
	desc             = "<b>GRAB INTENT</b>: you will attempt to grab hold of any object or creature you interact with."
	uid              = "intent_grab"
	intent_flags     = I_FLAG_GRAB
	icon_state       = "intent_grab"
	sort_order       = 3 // Corresponding to hotkey order.

/decl/intent/help
	name             = "help"
	desc             = "<b>HELP INTENT</b>: you will attempt to assist, or in general void harming, whatever you interact with."
	uid              = "intent_help"
	intent_flags     = I_FLAG_HELP
	icon_state       = "intent_help"
	sort_order       = 1 // Corresponding to hotkey order.

/decl/intent/disarm
	name             = "disarm"
	desc             = "<b>DISARM INTENT</b>: you will attempt to disarm or incapacitate any creature you interact with."
	uid              = "intent_disarm"
	intent_flags     = I_FLAG_DISARM
	icon_state       = "intent_disarm"
	sort_order       = 2 // Corresponding to hotkey order.

/mob
	/// Decl for current 'intent' of mob; hurt, harm, etc. Initialized by get_intent().
	VAR_PRIVATE/decl/intent/_a_intent
	VAR_PRIVATE/list/_available_intents

/mob/proc/check_intent(checking_intent)
	var/decl/intent/intent = get_intent() // Ensures intent has been initalised.
	. = (intent == checking_intent)
	if(!.)
		if(isnum(checking_intent))
			return (intent.intent_flags & checking_intent)
		else if(istext(checking_intent) || ispath(checking_intent, /decl/intent))
			return (intent == resolve_intent(checking_intent))

/mob/proc/set_intent(decl/intent/new_intent)

	if(!isnum(new_intent))
		new_intent = resolve_intent(new_intent)
	else // Retrieve intent decl based on flag.
		for(var/decl/intent/intent as anything in get_available_intents(skip_update = TRUE))
			if(intent.intent_flags & new_intent)
				new_intent = intent
				break

	if(istype(new_intent) && get_intent() != new_intent)
		_a_intent = new_intent
		if(istype(hud_used))
			hud_used.refresh_element(HUD_INTENT)
		return TRUE

	return FALSE

/mob/proc/get_intent()
	RETURN_TYPE(/decl/intent)
	var/list/available_intents = get_available_intents()
	if(length(available_intents) && (!_a_intent || !(_a_intent in available_intents)))
		var/new_intent
		if(_a_intent)
			for(var/decl/intent/intent in available_intents)
				if(_a_intent.intent_flags & intent.intent_flags)
					new_intent = intent
					break
		_a_intent = new_intent || available_intents[1]
	if(!_a_intent)
		_a_intent = get_default_intent()
	return _a_intent

/mob/proc/get_default_intent()
	return GET_DECL(/decl/intent/help)

/mob/proc/get_default_intents()
	var/static/list/default_intents
	if(!default_intents)
		default_intents = list(
			GET_DECL(/decl/intent/help),
			GET_DECL(/decl/intent/disarm),
			GET_DECL(/decl/intent/grab),
			GET_DECL(/decl/intent/harm)
		)
	return default_intents

/mob/proc/clear_available_intents(skip_update, skip_sleep)
	set waitfor = FALSE
	if(!skip_sleep)
		sleep(0)
		if(QDELETED(src))
			return
	_available_intents = null
	if(!skip_update)
		refresh_hud_element(HUD_INTENT)

/mob/proc/get_available_intents(skip_update, force)
	var/obj/item/held = get_active_held_item()
	if(!held)
		_available_intents = get_default_intents()
	else if(force || !_available_intents)
		// Grab all relevant intents.
		_available_intents = list()
		for(var/decl/intent/intent as anything in get_default_intents())
			if(intent.requires_empty_hand)
				continue
			_available_intents += intent
		// Add inhand intents.
		var/list/held_intents = held.get_provided_intents(src)
		if(length(held_intents))
			_available_intents |= held_intents
		// Trim blocked intents.
		for(var/decl/intent/intent as anything in _available_intents)
			_available_intents -= intent.blocks_other_intents
		// Sort by hotkey order.
		_available_intents = sortTim(_available_intents, /proc/cmp_decl_sort_value_asc)
		// Update our HUD immediately.
		if(!skip_update)
			refresh_hud_element(HUD_INTENT)
	return _available_intents

/mob/proc/cycle_intent(input)
	set name = "a-intent"
	set hidden = TRUE
	switch(input)
		if(INTENT_HOTKEY_RIGHT)
			return set_intent(next_in_list(get_intent(), get_available_intents(skip_update = TRUE)))
		if(INTENT_HOTKEY_LEFT)
			return set_intent(previous_in_list(get_intent(), get_available_intents(skip_update = TRUE)))
		else // Fallback, should just use set_intent() directly
			return set_intent(input)
