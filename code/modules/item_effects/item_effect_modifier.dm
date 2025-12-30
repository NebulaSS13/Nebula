/decl/item_effect/mob_modifier
	abstract_type = /decl/item_effect/mob_modifier
	var/modifier_archetype

/decl/item_effect/mob_modifier/can_do_wielded_effect(mob/user, obj/item/item, list/parameters)
	return !!modifier_archetype

/decl/item_effect/mob_modifier/do_wielded_effect(mob/user, obj/item/item, list/parameters)
	if(!user.has_mob_modifier(modifier_archetype, source = src))
		user.add_mob_modifier(modifier_archetype, source = item)
	return TRUE

/decl/item_effect/mob_modifier/can_do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	return !!modifier_archetype

/decl/item_effect/mob_modifier/do_unwielded_effect(mob/user, obj/item/item, list/parameters)
	if(user.has_mob_modifier(modifier_archetype, source = src))
		user.remove_mob_modifier(modifier_archetype, source = src)
	return TRUE

/decl/item_effect/mob_modifier/on_examined(obj/item/item, mob/user)
	var/decl/mob_modifier/archetype = GET_DECL(modifier_archetype)
	to_chat(user, SPAN_NOTICE("\The [item] grants \a [archetype] to the wielder."))

// Example effect; applies a regeneration modifier.
/decl/item_effect/mob_modifier/regeneration
	modifier_archetype = /decl/mob_modifier/regeneration/item
