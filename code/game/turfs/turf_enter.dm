#define ENTER_PROXIMITY_LOOP_SANITY 100
// Splitting this into its own proc for profiling purposes.
/turf/proc/handle_proximity_update(var/atom/movable/mover)
	var/objects = 0
	if(!istype(mover) || !(mover.movable_flags & MOVABLE_FLAG_PROXMOVE))
		return
	for(var/atom/movable/neighbor in range(1))
		if(objects > ENTER_PROXIMITY_LOOP_SANITY)
			break // Don't let ore piles kill the server as well as the client.
		if(neighbor.movable_flags & MOVABLE_FLAG_PROXMOVE)
			objects++
			mover.HasProximity(neighbor)
			if(!QDELETED(neighbor) && !QDELETED(mover))
				neighbor.HasProximity(mover)

#undef ENTER_PROXIMITY_LOOP_SANITY
/turf/Entered(var/atom/movable/A, var/atom/old_loc)

	..()

	if(!istype(A))
		return

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.handle_footsteps()

	queue_temperature_atoms(A)

// If an opaque movable atom moves around we need to potentially update visibility.
	if(A?.opacity && !has_opaque_atom)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()
#ifdef AO_USE_LIGHTING_OPACITY
		// Hook for AO.
		regenerate_ao()
#endif

	//Items that are in ZAS contaminants, but not on a mob, can still be contaminated.
	if(isitem(A))
		var/obj/item/I = A
		if(vsc?.contaminant_control.CLOTH_CONTAMINATION && I.can_contaminate())
			var/datum/gas_mixture/env = return_air(1)
			if(!env)
				return
			for(var/g in env.gas)
				var/decl/material/mat = GET_DECL(g)
				if((mat.gas_flags & XGM_GAS_CONTAMINANT) && env.gas[g] > mat.gas_overlay_limit + 1)
					I.contaminate()
					break

	// Handle non-listener proximity triggers.
	handle_proximity_update(A)
