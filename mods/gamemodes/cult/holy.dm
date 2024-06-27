/decl/material/liquid/water/affect_holy(mob/living/M, removed, datum/reagents/holder)
	if(iscultist(M))
		if(prob(10))
			var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
			cult.offer_uncult(M)
		if(prob(2))
			var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(M.loc)
			M.visible_message(SPAN_WARNING("\The [M] coughs up \the [S]!"))
		return TRUE
	return FALSE

/obj/item/nullrod/holy_act(mob/living/target, mob/living/user)
	if(iscultist(target))
		target.visible_message(SPAN_NOTICE("\The [user] waves \the [src] over \the [target]'s head."))
		var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
		cult.offer_uncult(target)
		return TRUE
	return ..()

/turf/wall/cult/nullrod_act(mob/user, obj/item/nullrod/rod)
	user.visible_message(
		SPAN_NOTICE("\The [user] touches \the [src] with \the [rod], and the enchantment affecting it fizzles away."),
		SPAN_NOTICE("You touch \the [src] with \the [rod], and the enchantment affecting it fizzles away.")
	)
	ChangeTurf(/turf/wall)
	return TRUE

/turf/floor/cult/nullrod_act(mob/user, obj/item/nullrod/rod)
	user.visible_message(
		SPAN_NOTICE("\The [user] touches \the [src] with \the [rod], and the enchantment affecting it fizzles away."),
		SPAN_NOTICE("You touch \the [src] with \the [rod], and the enchantment affecting it fizzles away.")
	)
	ChangeTurf(/turf/floor, keep_air = TRUE)
	return TRUE