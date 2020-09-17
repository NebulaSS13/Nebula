/datum/artifact_effect/forcefield
	name = "force field"
	origin_type = EFFECT_PARTICLE

	var/list/created_field
	var/field_color

/datum/artifact_effect/forcefield/New()
	..()
	effect_range = rand(2, 14)
	field_color = get_random_colour(1)

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
	if(activated && holder)
		var/turf/T = get_turf(holder)
		var/list/circle = getcircle(T, effect_range)
		//for now, just instantly respawn the fields when they get destroyed
		while(LAZYLEN(created_field) < length(circle))
			LAZYADD(created_field, new /obj/effect/energy_field/prepared())
		for(var/i = 1 to min(length(created_field), length(circle)))
			var/obj/effect/energy_field/E = created_field[i]
			E.forceMove(circle[i])
			E.color = field_color

//Subtype with all the needed vars set, ready to block stuff
/obj/effect/energy_field/prepared
	strength = 1
	density = 1
	invisibility = 0
