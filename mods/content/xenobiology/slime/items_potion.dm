/obj/item/slime_potion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle19"
	var/slime_type = /mob/living/simple_animal/slime
	var/can_tame_adults = FALSE

/obj/item/slime_potion/attack(mob/living/slime/M, mob/user)
	if(istype(M, /mob/living/slime))
		if(M.is_adult && can_tame_adults) 
			to_chat(user, SPAN_WARNING("Only baby slimes can be tamed!"))
			return TRUE
		if(M.stat)
			to_chat(user, SPAN_WARNING("\The [M] is dead!"))
			return TRUE
		if(M.client)
			to_chat(user, SPAN_WARNING("\The [M] resists!"))
			return TRUE
		var/mob/living/simple_animal/slime/pet = new slime_type(M.loc, M.slime_type)
		to_chat(user, SPAN_NOTICE("You feed \the [pet] the potion, removing its powers and calming it."))
		pet.prompt_rename(user)
		qdel(M)
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
