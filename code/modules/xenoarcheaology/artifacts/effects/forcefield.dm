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
	// This should probably rebuild the field as done in UpdateMove()
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
			LAZYADD(created_field, new /obj/effect/energy_field/artifact(null, src))
		for(var/i = 1 to min(length(created_field), length(circle)))
			var/obj/effect/energy_field/E = created_field[i]
			E.forceMove(circle[i])
			E.color = field_color

//Subtype with all the needed vars set, ready to block stuff
/obj/effect/energy_field/artifact
	strength = 1
	density = TRUE
	invisibility = INVISIBILITY_NONE
	is_spawnable_type = FALSE
	var/datum/artifact_effect/forcefield/owner

/obj/effect/energy_field/artifact/Initialize(var/ml, var/_owner)
	owner = _owner
	if(!istype(owner))
		PRINT_STACK_TRACE("Artifact forcefield created with [owner ? "invalid" : "null"] owning effect.")
		return INITIALIZE_HINT_QDEL
	return ..(ml)

/obj/effect/energy_field/artifact/Destroy()
	if(owner)
		LAZYREMOVE(owner.created_field, src)
		owner = null
	return ..()
