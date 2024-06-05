/decl/weapon_effect/debug/can_do_strike_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_strike_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	log_debug("[type]: [user] struck [target] with [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/can_do_parried_effect(mob/user, obj/item/weapon, parried, atom/attacker, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_parried_effect(mob/user, obj/item/weapon, parried, atom/attacker, list/parameters)
	log_debug("[type]: [user] parried [parried] from [attacker] with [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/can_do_used_effect(mob/user, obj/item/weapon, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_used_effect(mob/user, obj/item/weapon, list/parameters)
	log_debug("[type]: [user] used [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/can_do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	log_debug("[type]: [user] wielded [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/can_do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	log_debug("[type]: [user] unwielded [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/can_do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	return TRUE
/decl/weapon_effect/debug/do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	log_debug("[type]: [user] did ranged attack on [target] with [weapon] ([json_encode(args)])")

/decl/weapon_effect/debug/apply_icon_appearance_to(obj/item/weapon)
	log_debug("[type]: [weapon] updated appearance ([json_encode(args)])")

/decl/weapon_effect/debug/apply_onmob_appearance_to(obj/item/weapon, mob/user, bodytype, image/overlay, slot, bodypart)
	log_debug("[type]: [user] updated onmob appearance for [weapon] in [slot] for [bodytype]/[bodypart] ([json_encode(args)])")

/decl/weapon_effect/debug/hear_speech(obj/item/weapon, mob/user, message, decl/language/speaking)
	log_debug("[type]: [weapon] heard [user] say [message] in [speaking]")

/decl/weapon_effect/debug/examined(obj/item/weapon, mob/user)
	log_debug("[type]: [user] examined [weapon]")

/obj/item/sword/katana/debug/Initialize()
	. = ..()
	add_weapon_effect(/decl/weapon_effect/debug, list(
		WEAPON_EFFECT_VISUAL   = list("vis"         = "ual"),
		WEAPON_EFFECT_STRIKE   = list("foo"         = "bar"),
		WEAPON_EFFECT_PARRY    = list("fizz"        = "buzz"),
		WEAPON_EFFECT_USED     = list("aard"        = "vark"),
		WEAPON_EFFECT_VISIBLE  = list("ooo"         = "aaa"),
		WEAPON_EFFECT_LISTENER = list("walla walla" = "bing bong")
	))
	add_weapon_effect(/decl/weapon_effect/charges/fireball, list(
		WEAPON_EFFECT_VISIBLE,
		WEAPON_EFFECT_RANGED   = list("charges" = 5)
	))
	add_weapon_effect(/decl/weapon_effect/aura/regeneration, list(
		WEAPON_EFFECT_VISIBLE,
		WEAPON_EFFECT_WIELDED
	))
