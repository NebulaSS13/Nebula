/obj/item/disrupts_psionics()
	. = (material && material.is_psi_null()) ? src : FALSE

/obj/item/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(health >= 0 && . > 0 && disrupts_psionics())
		. = max(0, -(health - .))
		take_damage(., PSIONIC, 0, source, 0)

/obj/item/check_health(lastdamage, lastdamtype, lastdamflags)
	if(health > 0 || !can_take_damage())
		return //If invincible, or if we're not dead yet, skip

	if(lastdamtype == PSIONIC)
		shatter(TRUE)
	else 
		. = ..()
	