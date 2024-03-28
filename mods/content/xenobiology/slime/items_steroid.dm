/obj/item/slime_steroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle16"
	material = /decl/material/solid/glass
	obj_flags = OBJ_FLAG_HOLLOW
	var/grant_cores = 3

/obj/item/slime_steroid/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(!isslime(target))
		return ..()

	var/mob/living/slime/slime = target
	if(slime.is_adult)
		to_chat(user, SPAN_WARNING("Only baby slimes can use \the [src]!"))
		return TRUE
	if(slime.stat == DEAD)
		to_chat(user, SPAN_WARNING("\The [slime] is dead!"))
		return TRUE
	if(slime.cores >= grant_cores)
		to_chat(user, SPAN_WARNING("\The [slime] already has the maximum amount of cores!"))
		return TRUE

	to_chat(user, SPAN_NOTICE("You feed \the [src] to \the [slime] and it suddenly grows two extra cores."))
	slime.cores = grant_cores
	qdel(src)
	return TRUE
