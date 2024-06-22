/obj/aura/sifsap_salve
	name = "Sifsap Salve"
	icon = 'icons/effects/sparkles.dmi'
	icon_state = "cyan_sparkles"
	var/expiry
	var/descriptor = "glowing sap"

/obj/aura/sifsap_salve/Initialize(ml, _lifetime)
	expiry = world.time + _lifetime
	return ..()

/obj/aura/sifsap_salve/added_to(var/mob/living/L)
	..()
	to_chat(user, SPAN_NOTICE("The [descriptor] seethes and bubbles in your wounds, tingling and stinging."))

/obj/aura/sifsap_salve/removed()
	to_chat(user, SPAN_NOTICE("The last of the [descriptor] in your wounds fizzles away."))
	..()

/obj/aura/sifsap_salve/life_tick()

	if(!user || user.stat == DEAD || user.isSynthetic())
		return 0

	if(world.time >= expiry)
		if(user)
			user.remove_aura(src)
		return 0

	if(!user.has_trait(/decl/trait/sivian_biochemistry))
		user.heal_damage(BRUTE, 1, do_update_health = FALSE)
		user.heal_damage(BURN,  1, do_update_health = TRUE)
		return 1

	if(user.current_health >= user.get_max_health())
		return 0

	if(user.current_posture?.prone)
		user.heal_damage(BRUTE, 3, do_update_health = FALSE)
		user.heal_damage(BURN,  3, do_update_health = FALSE)
		user.heal_damage(TOX,   2, do_update_health = TRUE)
	else
		user.heal_damage(BRUTE, 2, do_update_health = FALSE)
		user.heal_damage(BURN,  2, do_update_health = FALSE)
		user.heal_damage(TOX,   1, do_update_health = TRUE)
	return 1
