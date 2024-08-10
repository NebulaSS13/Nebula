/obj/item/ability
	simulated = 1
	obj_flags = OBJ_FLAG_NO_STORAGE
	anchored = TRUE
	pickup_sound = null
	drop_sound =   null
	equip_sound =  null
	is_spawnable_type = FALSE
	abstract_type = /obj/item/ability
	var/mob/living/owner
	var/handler_type

/obj/item/ability/Initialize()
	owner = loc
	if(!istype(owner))
		return INITIALIZE_HINT_QDEL
	return ..()

/obj/item/ability/Destroy()
	var/datum/ability_handler/handler = istype(owner) && owner.get_ability_handler(handler_type, FALSE)
	if(handler)
		LAZYREMOVE(handler.ability_items, src)
	. = ..()

/obj/item/ability/dropped()
	..()
	qdel(src)

/obj/item/ability/attack_self(var/mob/user)
	user?.drop_from_inventory(src)
	return TRUE
