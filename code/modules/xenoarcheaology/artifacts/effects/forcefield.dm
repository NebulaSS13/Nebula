/datum/artifact_effect/forcefield
	name = "force field"
	var/list/created_field
	origin_type = EFFECT_PARTICLE
	// x-y configuration of the field, as offsets from source coordinates
	var/global/field_offsets = list(
		"-2" = list(-2, -1, 0, 1, 2), 
		"-1" = list(-2,           2), 
		"0"  = list(-2,           2), 
		"1"  = list(-2,           2), 
		"2"  = list(-2, -1, 0, 1, 2)
	)

/datum/artifact_effect/forcefield/Destroy()
	QDEL_NULL_LIST(created_field)
	. = ..()

/datum/artifact_effect/forcefield/ToggleActivate()
	..()
	if(LAZYLEN(created_field))
		QDEL_NULL_LIST(created_field)
	else if(holder)
		var/turf/T = get_turf(holder)
		if(!istype(T))
			return
		while(LAZYLEN(created_field) < 16)
			var/obj/effect/energy_field/prepared/E = new (locate(T.x,T.y,T.z))
			LAZYADD(created_field, E)
		UpdateMove()
	return 1

/datum/artifact_effect/forcefield/process()
	..()
	for(var/obj/effect/energy_field/E in created_field)
		if(E.strength < 1)
			E.Strengthen(0.15)
		else if(E.strength < 5)
			E.Strengthen(0.25)

/datum/artifact_effect/forcefield/UpdateMove()
	if(LAZYLEN(created_field) && holder)
		var/turf/T = get_turf(holder)
		//for now, just instantly respawn the fields when they get destroyed
		while(LAZYLEN(created_field) < 16)
			var/obj/effect/energy_field/prepared/E = new (locate(T.x,T.y,T))
			LAZYADD(created_field, E)

		var/field_index = 1
		for(var/x_off in field_offsets)
			for(var/y_off in field_offsets[x_off])
				var/obj/effect/energy_field/E = created_field[field_index]
				x_off = text2num(x_off)
				E.forceMove(locate(T.x + x_off, T.y + y_off, T.z))
				field_index++

//Subtype with all the needed vars set, ready to block stuff
/obj/effect/energy_field/prepared
	strength = 1
	density = 1
	invisibility = 0