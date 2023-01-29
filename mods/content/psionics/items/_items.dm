/obj/item/disrupts_psionics()
	. = (material && material.is_psi_null()) ? src : FALSE

/obj/item/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(health >= 0 && . > 0 && disrupts_psionics())
		health -= .
		. = max(0, -(health))
		check_health(consumed = TRUE)

/obj/item/chems/disrupts_psionics()
	. = ..()
	if(!. && reagents.disrupts_psionics())
		return src

/obj/item/chems/withstand_psi_stress(var/stress, var/atom/source)
	if(reagents.disrupts_psionics())
		for(var/reagent_type in reagents.reagent_volumes)
			var/decl/material/R = GET_DECL(reagent_type)
			. += R.on_psionic_stress(reagents, stress, source)
	if(. > 0)
		. = ..(stress, source)