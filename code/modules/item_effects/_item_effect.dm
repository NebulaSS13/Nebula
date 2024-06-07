#define ITEM_EFFECT_STRIKE   "weff_strike"
#define ITEM_EFFECT_PARRY    "weff_parry"
#define ITEM_EFFECT_USED     "weff_used"
#define ITEM_EFFECT_WIELDED  "weff_wield"
#define ITEM_EFFECT_VISUAL   "weff_visual"
#define ITEM_EFFECT_LISTENER "weff_listener"
#define ITEM_EFFECT_VISIBLE  "weff_visible"
#define ITEM_EFFECT_RANGED   "weff_ranged"
#define ITEM_EFFECT_PROCESS  "weff_process"

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

/decl/item_effect/proc/examined(obj/item/item, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE
