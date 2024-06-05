#define WEAPON_EFFECT_STRIKE   "weff_strike"
#define WEAPON_EFFECT_PARRY    "weff_parry"
#define WEAPON_EFFECT_USED     "weff_used"
#define WEAPON_EFFECT_WIELDED  "weff_wield"
#define WEAPON_EFFECT_VISUAL   "weff_visual"
#define WEAPON_EFFECT_LISTENER "weff_listener"
#define WEAPON_EFFECT_VISIBLE  "weff_visible"
#define WEAPON_EFFECT_RANGED   "weff_ranged"

/decl/weapon_effect
	abstract_type = /decl/weapon_effect

/decl/weapon_effect/proc/can_do_strike_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_strike_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/can_do_parried_effect(mob/user, obj/item/weapon, parried, atom/attacker, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_parried_effect(mob/user, obj/item/weapon, parried, atom/attacker, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/can_do_used_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_used_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/can_do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/can_do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/can_do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/apply_icon_appearance_to(obj/item/weapon)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/apply_onmob_appearance_to(obj/item/weapon, mob/user, bodytype, image/overlay, slot, bodypart)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/hear_speech(obj/item/weapon, mob/user, message, decl/language/speaking)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/decl/weapon_effect/proc/examined(obj/item/weapon, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE
