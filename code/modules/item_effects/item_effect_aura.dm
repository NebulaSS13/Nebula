/decl/item_effect/aura
	abstract_type = /decl/item_effect/aura
	var/aura_type

/decl/item_effect/aura/can_do_wielded_effect(mob/user, obj/item/item, list/parameters)
	return !!aura_type
/decl/item_effect/aura/do_wielded_effect(mob/user, obj/item/item, list/parameters)
	if(!user.has_aura(aura_type))
		user.add_aura(aura_type)
	return TRUE

/decl/item_effect/aura/can_do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	return !!aura_type
/decl/item_effect/aura/do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	if(user.has_aura(aura_type))
		user.remove_aura(aura_type)
	return TRUE

/decl/item_effect/aura/examined(obj/item/item, mob/user)
	var/obj/aura/aura = aura_type
	to_chat(user, SPAN_NOTICE("\The [item] grants \a [initial(aura.name)] to the wielder."))

// Example effect; applies a regeneration aura.
/decl/item_effect/aura/regeneration
	aura_type = /obj/aura/regenerating/item

// Distinct type to avoid removing the wrong type on unwield.
/obj/aura/regenerating/item
