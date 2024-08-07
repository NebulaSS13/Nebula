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
	if(istype(A) && !QDELETED(A) && A.simulated)
		queue_temperature_atoms(A)
		A.update_turf_alpha_mask()

// If an opaque movable atom moves around we need to potentially update visibility.
	if(A?.opacity && !has_opaque_atom)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()
#ifdef AO_USE_LIGHTING_OPACITY
		// Hook for AO.
		regenerate_ao()
#endif

	if(isturf(old_loc) && has_gravity() && A.can_fall() && !(weakref(A) in skip_height_fall_for))
		var/turf/old_turf  = old_loc
		var/old_height     = old_turf.get_physical_height() + old_turf.reagents?.total_volume
		var/current_height = get_physical_height() + reagents?.total_volume
		var/height_difference = abs(current_height - old_height)

		if(current_height < old_height && height_difference > FLUID_SHALLOW)
			visible_message("\The [A] falls into \the [reagents?.get_primary_reagent_name() || "hole"]!")
			if(isliving(A))
				var/mob/living/mover = A
				var/decl/bodytype/body = mover.get_bodytype()
				if(body)
					playsound(src, body.bodyfall_sounds, 50, 1, 1)
				SET_STATUS_MAX(mover, STAT_WEAK, rand(3,4))
				// TODO: generalized fall damage calc
				// TODO: take into account falling into fluid from a height/surface tension
				mover.take_overall_damage(min(1, round(height_difference * 0.05)))

	// Handle non-listener proximity triggers.
	handle_proximity_update(A)

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

	if(isturf(old_loc) && ismob(A))
		var/turf/T = old_loc
		if(T.get_physical_height() != get_physical_height())
			// Delay to allow transition to the new turf and avoid layering issues.
			var/mob/M = A
			M.reset_offsets()
			if(get_physical_height() > T.get_physical_height())
				M.reset_layer()
			else
				// arbitrary timing value that feels good in practice. it sucks and is inconsistent:(
				addtimer(CALLBACK(M, TYPE_PROC_REF(/atom, reset_layer)), max(0, ceil(M.next_move - world.time)) + 1 SECOND)

	if(simulated)
		A.OnSimulatedTurfEntered(src, old_loc)

