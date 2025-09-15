// This file contains blob_act overrides.
// blob_act is called when a blob attacks or tries to expand into a tile.
// blob_act overrides therefore handle atoms being damaged by blobs.

/// Handles blobs attacking/expanding into this atom.
/// Return TRUE to stop the blob from doing further attacks on this tile.
/atom/proc/blob_act(obj/effect/blob/blob)
	return

/turf/blob_act(obj/effect/blob/blob)
	if(!simulated) return FALSE
	for(var/atom/movable/movable in contents)
		if((. = movable.blob_act())) // stop if one returns TRUE
			return

/turf/space/blob_act(obj/effect/blob/blob)
	return // blobs don't attack things in space, for some reason

/turf/wall/blob_act(obj/effect/blob/blob)
	take_damage(80)
	return TRUE

/obj/structure/girder/blob_act(obj/effect/blob/blob)
	if(prob(40))
		dismantle_structure()
	return TRUE // block further attacks even if we aren't destroyed

/obj/structure/window/blob_act(obj/effect/blob/blob)
	shatter()
	return TRUE

/obj/structure/grille/blob_act(obj/effect/blob/blob)
	physically_destroyed()
	return TRUE

/obj/structure/door/blob_act(obj/effect/blob/blob)
	if(!density)
		return FALSE
	explosion_act(2)
	return TRUE

/obj/structure/foamedmetal/blob_act(obj/effect/blob/blob)
	physically_destroyed()
	return TRUE

/obj/structure/inflatable/blob_act(obj/effect/blob/blob)
	deflate(violent = TRUE)
	return TRUE

/obj/vehicle/blob_act(obj/effect/blob/blob)
	explosion_act(2)
	return TRUE

/obj/machinery/camera/blob_act(obj/effect/blob/blob)
	take_damage(30)
	return TRUE

/mob/living/blob_act(obj/effect/blob/blob)
	if(stat == DEAD)
		return FALSE
	blob.attack_living(src)