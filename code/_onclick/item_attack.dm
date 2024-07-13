/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc. If it (or attackby) returns true, afterattack is skipped.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's use_on_mob() proc.
item/use_on_mob() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	return (tool?.handle_physical_manipulation(user)) || FALSE

/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_params)
	if(!(item_flags & ITEM_FLAG_NO_PRINT))
		add_fingerprint(user)
	return A.attackby(src, user, click_params)

/atom/proc/attackby(obj/item/W, mob/user, var/click_params)
	if(storage)
		if(isrobot(user) && (W == user.get_active_held_item()))
			return //Robots can't store their modules.
		if(!storage.can_be_inserted(W, user))
			return
		W.add_fingerprint(user)
		return storage.handle_item_insertion(user, W)
	return FALSE

/atom/movable/attackby(obj/item/W, mob/user)
	. = ..()
	if(!.)
		return bash(W,user)

/atom/movable/proc/bash(obj/item/weapon, mob/user)
	if(isliving(user) && user.a_intent == I_HELP)
		return FALSE
	if(!weapon.user_can_wield(user))
		return FALSE
	if(weapon.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE
	visible_message(SPAN_DANGER("[src] has been hit by [user] with [weapon]."))
	return TRUE

/mob/living/attackby(obj/item/used_item, mob/user)
	if(!ismob(user))
		return TRUE
	if(user.a_intent != I_HURT)
		if(can_operate(src, user) != OPERATE_DENY && used_item.do_surgery(src,user)) //Surgery
			return TRUE
		if(try_butcher_in_place(user, used_item))
			return TRUE
	var/oldhealth = current_health
	. = used_item.use_on_mob(src, user)
	if(used_item.force && istype(ai) && current_health < oldhealth)
		ai.retaliate(user)

/mob/living/human/attackby(obj/item/I, mob/user)

	. = ..()
	if(.)
		if(user.a_intent != I_HELP)
			return
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, user.get_target_zone())
		if(!E)
			return
		for(var/datum/ailment/ailment in E.ailments)
			if(ailment.treated_by_item(I))
				ailment.was_treated_by_item(I, user, src)
				return

	else if(user == src && user.get_target_zone() == BP_MOUTH && can_devour(I, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
		else
			devour(I)
		return TRUE


// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/datum/attack_result
	var/hit_zone = 0
	var/mob/living/attackee = null

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/obj/item/proc/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	// TODO: revisit if this should be a silent failure/parent call instead, for mob-level storage interactions?
	// like a horse with a saddlebag or something
	if(!user_can_wield(user))
		return TRUE // skip other interactions

	if(squash_item())
		return TRUE

	if(user?.a_intent != I_HURT && is_edible(target) && handle_eaten_by_mob(user, target) != EATEN_INVALID)
		return TRUE

	if(item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE

	// If on help, possibly don't attack.
	if(user.a_intent == I_HELP)
		switch(user.get_preference_value(/datum/client_preference/help_intent_attack_blocking))
			if(PREF_ALWAYS)
				if(user == target)
					to_chat(user, SPAN_WARNING("You refrain from hitting yourself with \the [src] as you are on help intent."))
				else
					to_chat(user, SPAN_WARNING("You refrain from hitting \the [target] with \the [src] as you are on help intent."))
				return FALSE
			if(PREF_MYSELF)
				if(user == target)
					to_chat(user, SPAN_WARNING("You refrain from hitting yourself with \the [src] as you are on help intent."))
					return FALSE

	/////////////////////////

	if(!no_attack_log)
		admin_attack_log(user, target, "Attacked using \a [src] (DAMTYE: [uppertext(atom_damage_type)])", "Was attacked with \a [src] (DAMTYE: [uppertext(atom_damage_type)])", "used \a [src] (DAMTYE: [uppertext(atom_damage_type)]) to attack")
	/////////////////////////
	user.setClickCooldown(attack_cooldown + w_class)
	if(animate)
		user.do_attack_animation(target)
	if(!user.aura_check(AURA_TYPE_WEAPON, src, user))
		return FALSE

	var/hit_zone = target.resolve_item_attack(src, user, user.get_target_zone())

	var/datum/attack_result/AR = hit_zone
	if(istype(AR))
		if(AR.hit_zone)
			apply_hit_effect(AR.attackee || target, user, AR.hit_zone)
		return TRUE
	if(hit_zone)
		apply_hit_effect(target, user, hit_zone)
	return TRUE

//Called when a weapon is used to make a successful melee attack on a mob. Returns whether damage was dealt.
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	var/use_hitsound = hitsound
	if(!use_hitsound)
		if(edge || sharp)
			use_hitsound = 'sound/weapons/bladeslice.ogg'
		else
			use_hitsound = "swing_hit"
	playsound(loc, use_hitsound, 50, 1, -1)
	return target.hit_with_weapon(src, user, force, hit_zone)

/obj/item/proc/handle_reflexive_fire(var/mob/user, var/atom/aiming_at)
	return istype(user) && istype(aiming_at)
