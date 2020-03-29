/obj/item/disrupts_psionics()
	. = (material && material.is_psi_null()) ? src : FALSE

/obj/item/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(health >= 0 && . > 0 && disrupts_psionics())
		health -= .
		. = max(0, -(health))
		check_health(consumed = TRUE)
