/obj/item/nullrod/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return FALSE
	if(istype(A, /obj/structure/deity/altar))
		var/obj/structure/deity/altar/altar = A
		if(!altar.linked_god.silenced) //Don't want them to infinity spam it.
			altar.linked_god.silence(10)
			new /obj/effect/temporary(get_turf(altar),'icons/effects/effects.dmi',"purple_electricity_constant", 10)
			altar.visible_message("<span class='notice'>\The [altar] groans in protest as reality settles around \the [src].</span>")
		return TRUE
	if(istype(A, /turf/simulated/wall/cult))
		var/turf/simulated/wall/cult/W = A
		user.visible_message("<span class='notice'>\The [user] touches \the [A] with \the [src], and the enchantment affecting it fizzles away.</span>", "<span class='notice'>You touch \the [A] with \the [src], and the enchantment affecting it fizzles away.</span>")
		W.ChangeTurf(/turf/simulated/wall)
		return TRUE
	if(istype(A, /turf/simulated/floor/cult))
		var/turf/simulated/floor/cult/F = A
		user.visible_message("<span class='notice'>\The [user] touches \the [A] with \the [src], and the enchantment affecting it fizzles away.</span>", "<span class='notice'>You touch \the [A] with \the [src], and the enchantment affecting it fizzles away.</span>")
		F.ChangeTurf(/turf/simulated/floor)
		return TRUE
	. = ..()

/obj/item/nullrod/attack(mob/M, mob/living/user)
	if(GLOB.cult && iscultist(M) && M.a_intent == I_HELP)
		M.visible_message("<span class='notice'>\The [user] waves \the [src] over \the [M]'s head.</span>")
		GLOB.cult.offer_uncult(M)
		return
	. = ..()
	if(.)
		if(M.mind && LAZYLEN(M.mind.learned_spells))
			M.silence_spells(300) //30 seconds
			to_chat(M, "<span class='danger'>You've been silenced!</span>")
			return
