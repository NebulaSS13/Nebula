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

// If TRUE, prevent afterattack from running.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_params)
	if(!user.check_dexterity(get_required_attack_dexterity(user, A)))
		return TRUE
	if(!(item_flags & ITEM_FLAG_NO_PRINT))
		add_fingerprint(user)
	return A.attackby(src, user, click_params)

// If TRUE, prevent afterattack from running.
/atom/proc/attackby(obj/item/used_item, mob/user, var/click_params)

	if(try_handle_interactions(user, get_standard_interactions(user), user?.get_active_held_item(), check_alt_interactions = FALSE))
		return TRUE

	if(storage)
		if(isrobot(user) && (used_item == user.get_active_held_item()))
			return FALSE //Robots can't store their modules.
		if(!storage.can_be_inserted(used_item, user, click_params = click_params))
			return FALSE
		used_item.add_fingerprint(user)
		return storage.handle_item_insertion(user, used_item, click_params = click_params)

	return FALSE

/atom/movable/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(!.)
		return bash(used_item,user)

// Return TRUE if further actions (afterattack, etc) should be prevented, FALSE if they can proceed.
/atom/movable/proc/bash(obj/item/weapon, mob/user)
	if(isliving(user) && !user.check_intent(I_FLAG_HARM))
		return FALSE
	if(!weapon.user_can_attack_with(user))
		return FALSE
	if(weapon.item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE
	visible_message(SPAN_DANGER("[src] has been hit by [user] with [weapon]."))
	return TRUE

/mob/living/attackby(obj/item/used_item, mob/user)
	if(!ismob(user))
		return TRUE

	if(!QDELETED(used_item) && user.check_intent(I_FLAG_HELP))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, user.get_target_zone())
		if(length(E?.ailments))
			for(var/datum/ailment/ailment in E.ailments)
				if(ailment.treated_by_item(used_item))
					ailment.was_treated_by_item(used_item, user, src)
					return TRUE

	if(!user.check_intent(I_FLAG_HARM))
		if(can_operate(src, user) != OPERATE_DENY && used_item.do_surgery(src,user)) //Surgery
			return TRUE
		if(try_butcher_in_place(user, used_item))
			return TRUE

	if(istype(used_item, /obj/item/chems) && ATOM_IS_OPEN_CONTAINER(used_item) && has_extension(src, /datum/extension/milkable))
		var/datum/extension/milkable/milkable = get_extension(src, /datum/extension/milkable)
		if(milkable.handle_milked(used_item, user))
			return TRUE

	if(used_item.has_edge() && has_extension(src, /datum/extension/shearable))
		var/datum/extension/shearable/shearable = get_extension(src, /datum/extension/shearable)
		if(shearable.handle_sheared(used_item, user))
			return TRUE

	var/oldhealth = current_health
	. = used_item.use_on_mob(src, user)
	if(used_item.get_attack_force(user) && istype(ai) && current_health < oldhealth)
		ai.retaliate(user)

	if(!. && user == src && user.get_target_zone() == BP_MOUTH && can_devour(used_item, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
		else
			devour(used_item)
		return TRUE

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/datum/attack_result
	var/hit_zone = 0
	var/mob/living/attackee = null

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
// If this returns TRUE, the interaction has been handled and other interactions like afterattack should be skipped.
/obj/item/proc/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	// TODO: revisit if this should be a silent failure/parent call instead, for mob-level storage interactions?
	// like a horse with a saddlebag or something
	if(!user_can_attack_with(user))
		return TRUE // skip other interactions

	if(squash_item())
		return TRUE

	if(!user?.check_intent(I_FLAG_HARM) && is_edible(target) && handle_eaten_by_mob(user, target) != EATEN_INVALID)
		return TRUE

	if(item_flags & ITEM_FLAG_NO_BLUDGEON)
		return FALSE

	// If on help, possibly don't attack.
	if(user.check_intent(I_FLAG_HELP))
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

	if(target.mob_modifiers_block_attack(MM_ATTACK_TYPE_WEAPON, user, src))
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
		if(has_edge() || is_sharp())
			use_hitsound = 'sound/weapons/bladeslice.ogg'
		else
			use_hitsound = "swing_hit"
	playsound(loc, use_hitsound, 50, 1, -1)
	return target.hit_with_weapon(src, user, expend_attack_force(user), hit_zone)

/obj/item/proc/handle_reflexive_fire(var/mob/user, var/atom/aiming_at)
	return istype(user) && istype(aiming_at)
