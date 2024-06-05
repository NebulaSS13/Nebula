/obj/item
	var/list/_weapon_effects

/obj/item/proc/add_weapon_effect(effect_type, list/effect_parameters)
	if(!effect_type || !length(effect_parameters))
		return FALSE
	var/decl/weapon_effect/effect = ispath(effect_type) ? GET_DECL(effect_type) : effect_type
	if(!istype(effect))
		return FALSE
	LAZYINITLIST(_weapon_effects)
	for(var/effect_category in effect_parameters)
		LAZYSET(_weapon_effects[effect_category], effect, (effect_parameters[effect_category] || TRUE))
		. = TRUE

	if(.)
		if(WEAPON_EFFECT_LISTENER in effect_parameters)
			global.listening_objects |= src
		if(WEAPON_EFFECT_PROCESS in effect_parameters)
			SSweapon_effects.queued_weapons |= src

/obj/item/proc/remove_weapon_effect(decl/weapon_effect/effect)
	if(!effect || !length(_weapon_effects))
		return FALSE
	var/list/removed_effect_categories = list()
	for(var/effect_category in _weapon_effects)
		if(LAZYISIN(_weapon_effects[effect_category], effect))
			_weapon_effects[effect_category] -= effect
			if(!length(_weapon_effects[effect_category]))
				removed_effect_categories |= effect_category
				LAZYREMOVE(_weapon_effects, effect_category)
			. = TRUE
	if(.)
		if(WEAPON_EFFECT_LISTENER in removed_effect_categories)
			global.listening_objects -= src
		if(WEAPON_EFFECT_PROCESS in removed_effect_categories)
			SSweapon_effects.queued_weapons -= src

/obj/item/proc/get_weapon_effect_parameter(decl/weapon_effect/effect, effect_category, parameter_name)
	if(!effect || !length(_weapon_effects) || !effect_category || !parameter_name)
		return null
	var/list/effects = LAZYACCESS(_weapon_effects, effect_category)
	if(!LAZYISIN(effects, effect))
		return null
	return LAZYACCESS(effects[effect], parameter_name)

/obj/item/proc/set_weapon_effect_parameter(decl/weapon_effect/effect, effect_category, parameter_name, parameter_value)
	if(!effect || !length(_weapon_effects) || !effect_category || !parameter_name)
		return FALSE
	var/list/effects = LAZYACCESS(_weapon_effects, effect_category)
	if(!LAZYISIN(effects, effect))
		return FALSE
	LAZYSET(effects[effect], parameter_name, parameter_value)
	return TRUE

/obj/item/proc/get_weapon_effects(effect_category)
	return length(_weapon_effects) ? LAZYACCESS(_weapon_effects, effect_category) : null

// STRIKE effects
/obj/item/resolve_attackby(atom/A, mob/user, var/click_params)
	if(!(. = ..()))
		return
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_STRIKE)
	if(!length(weapon_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/weapon_effect/strike_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[strike_effect]
		if(strike_effect.can_do_strike_effect(user, src, A, parameters))
			strike_effect.do_strike_effect(user, src, A, parameters)

// PARRY effects
/obj/item/on_parry(mob/user, damage_source, mob/attacker)
	. = ..()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_PARRY)
	if(!length(weapon_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/weapon_effect/parry_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[parry_effect]
		if(parry_effect.can_do_parried_effect(user, src, damage_source, attacker, parameters))
			parry_effect.do_parried_effect(user, src, damage_source, attacker, parameters)
			. = TRUE

// VISUAL effects (world icon)
/obj/item/on_update_icon()
	. = ..()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_VISUAL)
	if(!length(weapon_effects))
		return
	for(var/decl/weapon_effect/used_effect as anything in weapon_effects)
		used_effect.apply_icon_appearance_to(src, weapon_effects[used_effect])

// VISUAL effects (onmob)
/obj/item/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	// TODO: this might need work to handle items that do a state or appearance update in the parent call.
	if(overlay)
		var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_VISUAL)
		if(length(weapon_effects))
			for(var/decl/weapon_effect/used_effect as anything in weapon_effects)
				used_effect.apply_onmob_appearance_to(src, user_mob, bodytype, overlay, slot, bodypart, weapon_effects[used_effect])
	. = ..()

// USED effects
/obj/item/attack_self(mob/user)
	if((. = ..()))
		return
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_USED)
	if(!length(weapon_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/weapon_effect/used_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[used_effect]
		if(used_effect.can_do_used_effect(user, src, parameters))
			used_effect.do_used_effect(user, src, parameters)
			. = TRUE

// WIELD effects (unwielded)
/obj/item/dropped(mob/user)
	. = ..()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_WIELDED)
	if(!length(weapon_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src))
		return
	for(var/decl/weapon_effect/wield_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[wield_effect]
		if(wield_effect.can_do_unwielded_effect(user, src, parameters))
			wield_effect.do_unwielded_effect(user, src, parameters)

// WIELD effects (wielded)
/obj/item/equipped(mob/user, slot)
	. = ..()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_WIELDED)
	if(!length(weapon_effects))
		return
	if(!istype(user) || QDELETED(user) || QDELETED(src) || loc != user || !(slot in user.get_held_item_slots()))
		return
	for(var/decl/weapon_effect/wield_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[wield_effect]
		if(wield_effect.can_do_wielded_effect(user, src, parameters))
			wield_effect.do_wielded_effect(user, src, parameters)

// LISTENING effects
/obj/item/hear_talk(mob/M, text, verb, decl/language/speaking)
	. = ..()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_LISTENER)
	if(!length(weapon_effects))
		return
	for(var/decl/weapon_effect/listening_effect as anything in weapon_effects)
		listening_effect.hear_speech(src, M, text, speaking)

// VISIBLE effects
/obj/item/examine(mob/user, distance)
	. = ..()
	if(!user)
		return
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_VISIBLE)
	if(!length(weapon_effects))
		return
	for(var/decl/weapon_effect/examine_effect as anything in weapon_effects)
		examine_effect.examined(src, user, distance, weapon_effects[examine_effect])

// RANGED effects
/obj/item/afterattack(turf/floor/target, mob/user, proximity)
	if((. = ..()) || proximity)
		return
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_RANGED)
	if(!length(weapon_effects))
		return
	for(var/decl/weapon_effect/ranged_effect as anything in weapon_effects)
		var/list/parameters = weapon_effects[ranged_effect]
		if(ranged_effect.can_do_ranged_effect(user, src, target, parameters))
			ranged_effect.do_ranged_effect(user, src, target, parameters)

// PROCESS effects
/obj/item/proc/process_weapon_effects()
	var/list/weapon_effects = get_weapon_effects(WEAPON_EFFECT_PROCESS)
	if(length(weapon_effects))
		for(var/decl/weapon_effect/process_effect as anything in weapon_effects)
			process_effect.do_process_effect(src, weapon_effects[process_effect])
