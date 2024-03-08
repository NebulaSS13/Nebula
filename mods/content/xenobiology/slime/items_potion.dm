/obj/item/slime_potion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle19"
	material = /decl/material/solid/glass
	obj_flags = OBJ_FLAG_HOLLOW
	var/slime_type = /mob/living/simple_animal/slime
	var/can_tame_adults = FALSE

/obj/item/slime_potion/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(isslime(target))
		var/mob/living/slime/slime = target
		if(slime.is_adult && can_tame_adults)
			to_chat(user, SPAN_WARNING("Only baby slimes can be tamed!"))
			return TRUE
		if(slime.stat)
			to_chat(user, SPAN_WARNING("\The [slime] is dead!"))
			return TRUE
		if(slime.client)
			to_chat(user, SPAN_WARNING("\The [slime] resists!"))
			return TRUE
		var/mob/living/simple_animal/slime/pet = new slime_type(slime.loc, slime.slime_type)
		to_chat(user, SPAN_NOTICE("You feed \the [pet] the potion, removing its powers and calming it."))
		pet.prompt_rename(user)
		qdel(slime)
		qdel(src)
		return TRUE
	. = ..()

/obj/item/slime_potion/advanced
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle19"
	slime_type = /mob/living/simple_animal/slime/adult
	can_tame_adults = TRUE
