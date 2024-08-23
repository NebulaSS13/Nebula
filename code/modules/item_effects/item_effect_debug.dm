/decl/item_effect/debug/can_do_strike_effect(mob/user, obj/item/item, atom/target, list/parameters)
	return TRUE
/decl/item_effect/debug/do_strike_effect(mob/user, obj/item/item, atom/target, list/parameters)
	log_debug("[type]: [user] struck [target] with [item] ([json_encode(args)])")

/decl/item_effect/debug/can_do_parried_effect(mob/user, obj/item/item, parried, atom/attacker, list/parameters)
	return TRUE
/decl/item_effect/debug/do_parried_effect(mob/user, obj/item/item, parried, atom/attacker, list/parameters)
	log_debug("[type]: [user] parried [parried] from [attacker] with [item] ([json_encode(args)])")

/decl/item_effect/debug/can_do_used_effect(mob/user, obj/item/item, list/parameters)
	return TRUE
/decl/item_effect/debug/do_used_effect(mob/user, obj/item/item, list/parameters)
	log_debug("[type]: [user] used [item] ([json_encode(args)])")

/decl/item_effect/debug/can_do_wielded_effect(mob/user, obj/item/item, list/parameters)
	return TRUE
/decl/item_effect/debug/do_wielded_effect(mob/user, obj/item/item, list/parameters)
	log_debug("[type]: [user] wielded [item] ([json_encode(args)])")

/decl/item_effect/debug/can_do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	return TRUE
/decl/item_effect/debug/do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	log_debug("[type]: [user] unwielded [item] ([json_encode(args)])")

/decl/item_effect/debug/can_do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	return TRUE
/decl/item_effect/debug/do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	log_debug("[type]: [user] did ranged attack on [target] with [item] ([json_encode(args)])")

/decl/item_effect/debug/apply_icon_appearance_to(obj/item/item)
	log_debug("[type]: [item] updated appearance ([json_encode(args)])")

/decl/item_effect/debug/apply_onmob_appearance_to(obj/item/item, mob/user, bodytype, image/overlay, slot, bodypart)
	log_debug("[type]: [user] updated onmob appearance for [item] in [slot] for [bodytype]/[bodypart] ([json_encode(args)])")

/decl/item_effect/debug/hear_speech(obj/item/item, mob/user, message, decl/language/speaking)
	log_debug("[type]: [item] heard [user] say [message] in [speaking] ([json_encode(args)])")

/decl/item_effect/debug/examined(obj/item/item, mob/user)
	log_debug("[type]: [user] examined [item] ([json_encode(args)])")

/decl/item_effect/debug/do_process_effect(obj/item/item, list/parameters)
	log_debug("[type]: [item] processed ([json_encode(args)])")

/obj/item/sword/katana/debug/Initialize()
	. = ..()
	add_item_effect(/decl/item_effect/debug, list(
		ITEM_EFFECT_VISUAL   = list("vis"         = "ual"),
		ITEM_EFFECT_STRIKE   = list("foo"         = "bar"),
		ITEM_EFFECT_PARRY    = list("fizz"        = "buzz"),
		ITEM_EFFECT_USED     = list("aard"        = "vark"),
		ITEM_EFFECT_VISIBLE  = list("ooo"         = "aaa"),
		ITEM_EFFECT_LISTENER = list("walla walla" = "bing bong"),
		ITEM_EFFECT_PROCESS  = list("hyonk"       = "hjonk")
	))
	add_item_effect(/decl/item_effect/charges/fireball, list(
		ITEM_EFFECT_VISIBLE,
		ITEM_EFFECT_RANGED   = list("charges" = 5)
	))
	add_item_effect(/decl/item_effect/aura/regeneration, list(
		ITEM_EFFECT_VISIBLE,
		ITEM_EFFECT_WIELDED
	))

/obj/item/staff/crystal/beacon/fireball
	name = "staff of fireball"
	material = /decl/material/solid/organic/wood/ebony
	matter = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE)

/obj/item/staff/crystal/beacon/fireball/Initialize(ml, material_key)
	. = ..()
	add_item_effect(/decl/item_effect/charges/fireball, list(
		ITEM_EFFECT_VISIBLE,
		ITEM_EFFECT_RANGED   = list("charges" = 5)
	))