/turf/wall/disrupts_psionics()
	return ((material && material.is_psi_null()) || (reinf_material && reinf_material.is_psi_null())) ? src : ..()

/turf/wall/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(. > 0 && disrupts_psionics())
		var/cap = material.integrity
		if(reinf_material) cap += reinf_material.integrity
		var/stress_total = damage + .
		take_damage(., PSIONIC)
		. = max(0, -(cap-stress_total))

/turf/wall/nullglass
	color = "#ff6088"

/turf/wall/nullglass/Initialize(ml)
	color = null
	..(ml, MAT_NULLGLASS)
