/obj/item/slime_steroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle16"
	var/grant_cores = 3

/obj/item/slime_steroid/attack(mob/living/slime/M, mob/user)
	if(!istype(M, /mob/living/slime))
		return ..()
	if(M.is_adult)
		to_chat(user, SPAN_WARNING("Only baby slimes can use \the [src]!"))
		return TRUE
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [M] is dead!"))
		return TRUE
	if(M.cores >= grant_cores)
		to_chat(user, SPAN_WARNING("\The [M] already has the maximum amount of cores!"))
		return TRUE

	to_chat(user, SPAN_NOTICE("You feed \the [src] to \the [M] and it suddenly grows two extra cores."))
	M.cores = grant_cores
	qdel(src)
	return TRUE
