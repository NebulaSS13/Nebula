/decl/item_effect
	abstract_type = /decl/item_effect

/decl/item_effect/proc/do_process_effect(obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_strike_effect(mob/user, obj/item/item, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_strike_effect(mob/user, obj/item/item, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_parried_effect(mob/user, obj/item/item, parried, atom/attacker, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_parried_effect(mob/user, obj/item/item, parried, atom/attacker, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_used_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_used_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_wielded_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_wielded_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/can_do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/apply_icon_appearance_to(obj/item/item)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/apply_onmob_appearance_to(obj/item/item, mob/user, bodytype, image/overlay, slot, bodypart)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/hear_speech(obj/item/item, mob/user, message, decl/language/speaking)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/on_examined(obj/item/item, mob/user, distance, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/item_effect/proc/modify_attack_damage(base_damage, obj/item/used_item, mob/user, dry_run, list/parameters)
	return base_damage

/decl/item_effect/proc/expend_attack_use(obj/item/used_item, mob/user, dry_run, list/parameters)
	return
