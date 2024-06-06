/obj/aura/sifsap_salve
	name = "Sifsap Salve"
	icon = 'icons/effects/sparkles.dmi'
	icon_state = "cyan_sparkles"
	var/expiry

/obj/aura/sifsap_salve/Initialize(ml, _lifetime)
	expiry = world.time + _lifetime
	return ..()

/obj/aura/sifsap_salve/added_to(var/mob/living/L)
	..()
	to_chat(user, SPAN_NOTICE("The glowing sap seethes and bubbles in your wounds, tingling and stinging."))

/obj/aura/sifsap_salve/removed()
	to_chat(user, SPAN_NOTICE("The last of the sap in your wounds fizzles away."))
	..()

/obj/aura/sifsap_salve/life_tick()

	if(!user || user.stat == DEAD || user.isSynthetic())
		return 0

	if(world.time >= expiry)
		if(user)
			user.remove_aura(src)
		return 0

	if(!user.HasTrait(/decl/trait/sivian_biochemistry))
		user.heal_damage(1,       do_update_health = FALSE)
		user.heal_damage(1, BURN, do_update_health = TRUE)
		return 1

	if(user.current_health >= user.get_max_health())
		return 0

	if(user.current_posture?.prone)
		user.heal_damage(3,       do_update_health = FALSE)
		user.heal_damage(3, BURN, do_update_health = FALSE)
		user.heal_damage(2, TOX,  do_update_health = TRUE)
	else
		user.heal_damage(2,       do_update_health = FALSE)
		user.heal_damage(2, BURN, do_update_health = FALSE)
		user.heal_damage(1, TOX,  do_update_health = TRUE)
	return 1
