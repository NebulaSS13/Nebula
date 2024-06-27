/datum/phenomena/movable_object
	var/object_type
	var/atom/movable/object_to_move
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /atom

/datum/phenomena/movable_object/New()
	..()
	add_object()

/datum/phenomena/movable_object/Destroy()
	events_repository.unregister(/decl/observ/destroyed, object_to_move,src)
	if(!object_to_move.loc)
		QDEL_NULL(object_to_move)
	. = ..()

/datum/phenomena/movable_object/proc/add_object()
	if(object_to_move)
		events_repository.unregister(/decl/observ/destroyed, object_to_move,src)
	object_to_move = new object_type()
	events_repository.register(/decl/observ/destroyed, object_to_move, src, PROC_REF(add_object))

/datum/phenomena/movable_object/activate(var/atom/a, var/mob/living/deity/user)
	..()
	if(object_to_move == a)
		object_to_move.forceMove(null) //Move to null space
	else
		var/turf/T = get_turf(a)
		//No dense turf/stuff
		if(T.density)
			return
		for(var/i in T)
			var/atom/A = i
			if(A.density)
				return
		object_to_move.forceMove(T)