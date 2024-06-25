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

/obj/item/projectile/fireball
	name = "fireball"
	icon_state = "fireball"
	fire_sound = 'sound/effects/bamf.ogg'
	damage = 20
	atom_damage_type = BURN
	damage_flags = DAM_DISPERSED // burn all over
	var/fire_lifetime = 2 SECONDS
	var/fire_temperature = (288 CELSIUS) / 0.9 + 1 // hot enough to ignite wood! divided by 0.9 and plus one to ensure we can light firepits

/obj/effect/fake_fire/variable
	name = "fire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	firelevel = 1
	pressure = ONE_ATMOSPHERE

/obj/effect/fake_fire/variable/Initialize(ml, new_temperature, new_lifetime)
	lifetime = new_lifetime
	last_temperature = new_temperature
	return ..()

// we deal our damage via fire_act, not via direct burn damage. our burn damage is specifically for mobs
/obj/item/projectile/fireball/get_structure_damage()
	return 0

/obj/item/projectile/fireball/on_impact(var/atom/A)
	. = ..()
	var/obj/effect/fake_fire/fire = new /obj/effect/fake_fire/variable(get_turf(A), fire_temperature, fire_lifetime)
	fire.Process() // process at least once!
	qdel_self()

/obj/item/projectile/fireball/after_move()
	. = ..()
	if(!loc)
		return
	for(var/mob/living/victim in loc)
		if(!victim.simulated)
			continue
		victim.FireBurn(1, fire_temperature, ONE_ATMOSPHERE)
	loc.fire_act(1, fire_temperature, ONE_ATMOSPHERE)
	for(var/atom/burned in loc)
		if(!burned.simulated || burned == src)
			continue
		burned.fire_act(1, fire_temperature, ONE_ATMOSPHERE)

// Example effect; casts a fireball n times.
/decl/item_effect/charges/fireball
	effect_descriptor = "fireball"
/decl/item_effect/charges/fireball/can_do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	return TRUE
/decl/item_effect/charges/fireball/do_ranged_effect(mob/user, obj/item/item, atom/target, list/parameters)
	. = ..()
	if(.)
		var/obj/item/projectile/fireball/projectile = new(get_turf(user))
		projectile.launch_from_gun(target, user.get_target_zone(), user)
