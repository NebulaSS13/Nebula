/obj/abstract
	name =          ""
	icon =          'icons/effects/landmarks.dmi'
	icon_state =    "x2"
	simulated =     FALSE
	density =       FALSE
	anchored =      TRUE
	abstract_type = /obj/abstract
	max_health =    OBJ_HEALTH_NO_DAMAGE

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()
	//Let mappers see the damn thing by just making them invisible here
	opacity       =  FALSE
	alpha         =  0
	mouse_opacity = 0
	invisibility  =  INVISIBILITY_MAXIMUM+1

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/abstract/bullet_act(obj/item/projectile/P, def_zone)
	return PROJECTILE_CONTINUE

/obj/abstract/fluid_act(datum/reagents/fluids)
	return

/obj/abstract/lava_act()
	return

/obj/abstract/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/abstract/acid_act()
	return

/obj/abstract/take_damage(damage, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)
	return 0

/obj/abstract/heal(amount)
	return 0