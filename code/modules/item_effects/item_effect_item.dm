/obj/item
	var/list/_item_effects

/obj/item/proc/add_item_effect(effect_type, list/effect_parameters)
	if(!effect_type || !length(effect_parameters))
		return FALSE
	var/decl/item_effect/effect = ispath(effect_type) ? GET_DECL(effect_type) : effect_type
	if(!istype(effect))
		return FALSE
	LAZYINITLIST(_item_effects)
	for(var/effect_category in effect_parameters)
		LAZYSET(_item_effects[effect_category], effect, (effect_parameters[effect_category] || TRUE))
		. = TRUE

	if(.)
		if(ITEM_EFFECT_LISTENER in effect_parameters)
			global.listening_objects |= src
		if(ITEM_EFFECT_PROCESS in effect_parameters)
			SSitem_effects.queued_items |= src

/obj/item/proc/remove_item_effect(decl/item_effect/effect)
	if(!effect || !length(_item_effects))
		return FALSE
	var/list/removed_effect_categories = list()
	for(var/effect_category in _item_effects)
		if(LAZYISIN(_item_effects[effect_category], effect))
			_item_effects[effect_category] -= effect
			if(!length(_item_effects[effect_category]))
				removed_effect_categories |= effect_category
				LAZYREMOVE(_item_effects, effect_category)
			. = TRUE
	if(.)
		if(ITEM_EFFECT_LISTENER in removed_effect_categories)
			global.listening_objects -= src
		if(ITEM_EFFECT_PROCESS in removed_effect_categories)
			SSitem_effects.queued_items -= src

/obj/item/proc/get_item_effect_parameter(decl/item_effect/effect, effect_category, parameter_name)
	if(!effect || !length(_item_effects) || !effect_category || !parameter_name)
		return null
	var/list/effects = LAZYACCESS(_item_effects, effect_category)
	if(!LAZYISIN(effects, effect))
		return null
	return LAZYACCESS(effects[effect], parameter_name)

/obj/item/proc/set_item_effect_parameter(decl/item_effect/effect, effect_category, parameter_name, parameter_value)
	if(!effect || !length(_item_effects) || !effect_category || !parameter_name)
		return FALSE
	var/list/effects = LAZYACCESS(_item_effects, effect_category)
	if(!LAZYISIN(effects, effect))
		return FALSE
	LAZYSET(effects[effect], parameter_name, parameter_value)
	return TRUE

/obj/item/proc/get_item_effects(effect_category)
	return length(_item_effects) ? LAZYACCESS(_item_effects, effect_category) : null

// STRIKE effects
/obj/item/resolve_attackby(atom/A, mob/user, var/click_params)
	if(!(. = ..()))
		return
	var/list/item_effects = get_item_effects(ITEM_EFFECT_STRIKE)
	if(!length(item_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/item_effect/strike_effect as anything in item_effects)
		var/list/parameters = item_effects[strike_effect]
		if(strike_effect.can_do_strike_effect(user, src, A, parameters))
			strike_effect.do_strike_effect(user, src, A, parameters)

// PARRY effects
/obj/item/on_parry(mob/user, damage_source, mob/attacker)
	. = ..()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_PARRY)
	if(!length(item_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/item_effect/parry_effect as anything in item_effects)
		var/list/parameters = item_effects[parry_effect]
		if(parry_effect.can_do_parried_effect(user, src, damage_source, attacker, parameters))
			parry_effect.do_parried_effect(user, src, damage_source, attacker, parameters)
			. = TRUE

// VISUAL effects (world icon)
/obj/item/on_update_icon()
	. = ..()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_VISUAL)
	if(!length(item_effects))
		return
	for(var/decl/item_effect/used_effect as anything in item_effects)
		used_effect.apply_icon_appearance_to(src, item_effects[used_effect])

// VISUAL effects (onmob)
/obj/item/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	// TODO: this might need work to handle items that do a state or appearance update in the parent call.
	if(overlay)
		var/list/item_effects = get_item_effects(ITEM_EFFECT_VISUAL)
		if(length(item_effects))
			for(var/decl/item_effect/used_effect as anything in item_effects)
				used_effect.apply_onmob_appearance_to(src, user_mob, bodytype, overlay, slot, bodypart, item_effects[used_effect])
	. = ..()

// USED effects
/obj/item/attack_self(mob/user)
	if((. = ..()))
		return
	var/list/item_effects = get_item_effects(ITEM_EFFECT_USED)
	if(!length(item_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/item_effect/used_effect as anything in item_effects)
		var/list/parameters = item_effects[used_effect]
		if(used_effect.can_do_used_effect(user, src, parameters))
			used_effect.do_used_effect(user, src, parameters)
			. = TRUE

// WIELD effects (unwielded)
/obj/item/dropped(mob/user)
	. = ..()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_WIELDED)
	if(!length(item_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/item_effect/wield_effect as anything in item_effects)
		var/list/parameters = item_effects[wield_effect]
		if(wield_effect.can_do_unwielded_effect(user, src, parameters))
			wield_effect.do_unwielded_effect(user, src, parameters)

// WIELD effects (wielded)
/obj/item/equipped(mob/user, slot)
	. = ..()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_WIELDED)
	if(!length(item_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src) || loc != user || !(slot in user.get_held_item_slots()))
		return
	for(var/decl/item_effect/wield_effect as anything in item_effects)
		var/list/parameters = item_effects[wield_effect]
		if(wield_effect.can_do_wielded_effect(user, src, parameters))
			wield_effect.do_wielded_effect(user, src, parameters)

// LISTENING effects
/obj/item/hear_talk(mob/M, text, verb, decl/language/speaking)
	. = ..()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_LISTENER)
	if(!length(item_effects))
		return
	for(var/decl/item_effect/listening_effect as anything in item_effects)
		listening_effect.hear_speech(src, M, text, speaking)

// VISIBLE effects
/obj/item/examine(mob/user, distance)
	. = ..()
	if(!user)
		return
	var/list/item_effects = get_item_effects(ITEM_EFFECT_VISIBLE)
	if(!length(item_effects))
		return
	for(var/decl/item_effect/examine_effect as anything in item_effects)
		examine_effect.examined(src, user, distance, item_effects[examine_effect])

// RANGED effects
/obj/item/afterattack(turf/floor/target, mob/user, proximity)
	if((. = ..()) || proximity)
		return
	var/list/item_effects = get_item_effects(ITEM_EFFECT_RANGED)
	if(!length(item_effects))
		return
	for(var/decl/item_effect/ranged_effect as anything in item_effects)
		var/list/parameters = item_effects[ranged_effect]
		if(ranged_effect.can_do_ranged_effect(user, src, target, parameters))
			ranged_effect.do_ranged_effect(user, src, target, parameters)

// PROCESS effects
/obj/item/proc/process_item_effects()
	var/list/item_effects = get_item_effects(ITEM_EFFECT_PROCESS)
	if(length(item_effects))
		for(var/decl/item_effect/process_effect as anything in item_effects)
			process_effect.do_process_effect(src, item_effects[process_effect])
