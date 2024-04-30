/decl/bodytype
	// This will generally not be used, except when a posture is not present in available_mob_postures.
	var/list/basic_posture_map = list(
		/decl/posture/standing         = /decl/posture/standing,
		/decl/posture/lying            = /decl/posture/lying,
		/decl/posture/lying/deliberate = /decl/posture/lying/deliberate
	)
	var/list/available_mob_postures = list(
		/decl/posture/standing,
		/decl/posture/lying,
		/decl/posture/lying/deliberate
	)

/decl/bodytype/validate()
	. = ..()
	var/static/list/mandatory_postures = list(
		/decl/posture/standing,
		/decl/posture/lying,
		/decl/posture/lying/deliberate
	)
	for(var/mandatory_posture in mandatory_postures)
		if(!basic_posture_map[mandatory_posture])
			. += "basic posture map missing [mandatory_posture]"

/decl/bodytype/proc/get_equivalent_posture_type(posture_type)
	return basic_posture_map[posture_type]
