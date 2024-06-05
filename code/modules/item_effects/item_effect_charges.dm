/decl/item_effect/charges
	var/effect_descriptor
	abstract_type = /decl/item_effect/charges

/decl/item_effect/charges/do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	var/charges = (LAZYACCESS(parameters, "charges") || 0)
	if(charges <= 0)
		return FALSE
	item.set_item_effect_parameter(src, ITEM_EFFECT_RANGED, "charges", charges-1)
	return TRUE

/decl/item_effect/charges/examined(obj/item/item, mob/user)
	to_chat(user, SPAN_NOTICE("\The [item] has [item.get_item_effect_parameter(src, ITEM_EFFECT_RANGED, "charges") || 0] charge\s of [effect_descriptor] left."))

// Example effect; casts a fireball n times.
/decl/item_effect/charges/fireball
	effect_descriptor = "fireball"
/decl/item_effect/charges/fireball/can_do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	return TRUE
/decl/item_effect/charges/fireball/do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	. = ..()
	if(.)
		var/obj/item/projectile/spell_projectile/fireball/projectile = new(get_turf(user))
		projectile.launch_from_gun(target, user.get_target_zone(), user)
