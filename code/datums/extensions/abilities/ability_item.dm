/obj/item/ability
	simulated    = FALSE
	icon         = 'icons/mob/screen/ability_inhand.dmi'
	obj_flags    = OBJ_FLAG_NO_STORAGE
	anchored     = TRUE
	pickup_sound = null
	drop_sound =   null
	equip_sound =  null
	is_spawnable_type = FALSE
	abstract_type = /obj/item/ability
	var/decl/ability/ability
	var/weakref/owner_ref
	var/handler_type

/obj/item/ability/Initialize(ml, decl/ability/_ability)
	var/mob/living/owner = loc
	var/datum/ability_handler/handler = istype(owner) && owner.get_ability_handler(handler_type, FALSE)
	if(!istype(handler))
		return INITIALIZE_HINT_QDEL
	if(_ability)
		ability = _ability
		if(!istype(ability))
			return INITIALIZE_HINT_QDEL
	owner_ref = weakref(owner)
	LAZYDISTINCTADD(handler.ability_items, src)
	. = ..()
	owner.put_in_hands(src)

/obj/item/ability/Destroy()
	var/mob/living/owner = owner_ref?.resolve()
	var/datum/ability_handler/handler = istype(owner) && owner.get_ability_handler(handler_type, FALSE)
	if(istype(handler))
		LAZYREMOVE(handler.ability_items, src)
	return ..()

/obj/item/ability/dropped()
	..()
	qdel(src)

/obj/item/ability/attack_self(var/mob/user)
	user?.drop_from_inventory(src)
	return TRUE

/obj/item/ability/use_on_mob(mob/living/target, mob/living/user, animate)
	return FALSE

/obj/item/ability/afterattack(atom/target, mob/user, proximity)
	if(QDELETED(src) || !istype(ability))
		return TRUE
	var/list/metadata = ability.get_metadata_for(user)
	if(!islist(metadata))
		return TRUE
	if(ability.projectile_type)
		// Fire a projectile if that is how this ability works.
		ability.fire_projectile_at(user, target, metadata)
	else
		// Otherwise, apply to the target. Range checking etc. will be handled in apply_effect().
		ability.apply_effect(user, target, metadata)

	// Clean up our item if needed.
	if(ability.item_end_on_cast)
		qdel(src)
