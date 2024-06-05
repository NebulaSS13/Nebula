/decl/weapon_effect/aura
	abstract_type = /decl/weapon_effect/aura
	var/aura_type

/decl/weapon_effect/aura/can_do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	return !!aura_type
/decl/weapon_effect/aura/do_wielded_effect(mob/user, obj/item/weapon, list/parameters)
	if(!user.has_aura(aura_type))
		user.add_aura(aura_type)
	return TRUE

/decl/weapon_effect/aura/can_do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	return !!aura_type
/decl/weapon_effect/aura/do_unwielded_effect(mob/user, obj/item/weapon, list/parameters)
	if(user.has_aura(aura_type))
		user.remove_aura(aura_type)
	return TRUE

/decl/weapon_effect/aura/examined(obj/item/weapon, mob/user)
	var/obj/aura/aura = aura_type
	to_chat(user, SPAN_NOTICE("\The [weapon] grants \a [initial(aura.name)] to the wielder."))

// Example effect; applies a regeneration aura.
/decl/weapon_effect/aura/regeneration
	aura_type = /obj/aura/regenerating/weapon

// Distinct type to avoid removing the wrong type on unwield.
/obj/aura/regenerating/weapon
