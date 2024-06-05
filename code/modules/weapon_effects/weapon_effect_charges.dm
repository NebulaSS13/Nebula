/decl/weapon_effect/charges
	var/effect_descriptor
	abstract_type = /decl/weapon_effect/charges

/decl/weapon_effect/charges/do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	var/charges = (LAZYACCESS(parameters, "charges") || 0)
	if(charges <= 0)
		return FALSE
	weapon.set_weapon_effect_parameter(src, WEAPON_EFFECT_RANGED, "charges", charges-1)
	return TRUE

/decl/weapon_effect/charges/examined(obj/item/weapon, mob/user)
	to_chat(user, SPAN_NOTICE("\The [weapon] has [weapon.get_weapon_effect_parameter(src, WEAPON_EFFECT_RANGED, "charges") || 0] charge\s of [effect_descriptor] left."))

// Example effect; casts a fireball n times.
/decl/weapon_effect/charges/fireball
	effect_descriptor = "fireball"
/decl/weapon_effect/charges/fireball/can_do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	return TRUE
/decl/weapon_effect/charges/fireball/do_ranged_effect(mob/user, obj/item/weapon, atom/target, list/parameters)
	. = ..()
	if(.)
		var/obj/item/projectile/spell_projectile/fireball/projectile = new(get_turf(user))
		projectile.launch_from_gun(target, user.get_target_zone(), user)
