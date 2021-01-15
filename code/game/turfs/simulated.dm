/turf/simulated
	name = "station"
	initial_gas = list(/decl/material/gas/oxygen = MOLES_O2STANDARD, /decl/material/gas/nitrogen = MOLES_N2STANDARD)
	var/wet = 0
	var/image/wet_overlay = null
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0
	var/timer_id

// This is not great.
/turf/simulated/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)
	if(wet_val < wet && !overwrite)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		overlays += wet_overlay

	timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor),8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)

/turf/simulated/proc/unwet_floor(var/check_very_wet = TRUE)
	if(check_very_wet && wet >= 2)
		wet--
		timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor), 8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)
		return

	wet = 0
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/Initialize()
	. = ..()
	if(istype(loc, /area/chapel))
		holy = 1
	levelupdate()

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor=COLOR_BLOOD_HUMAN)
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+0.5, 101)
	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/remove_cleanables()
	dirt = 0
	. = ..()

/turf/simulated/Entered(atom/A, atom/OL)
	. = ..()
	if (istype(A))
		A.OnSimulatedTurfEntered(src)

/atom/proc/OnSimulatedTurfEntered(turf/simulated/T)
	set waitfor = FALSE
	return

/mob/living/OnSimulatedTurfEntered(turf/simulated/T)
	T.update_dirt()

	HandleBloodTrail(T)

	if(lying || !T.wet)
		return

	if(buckled || (MOVING_DELIBERATELY(src) && prob(min(100, 100/(T.wet/10)))))
		return

	// skillcheck for slipping
	if(!prob(min(100, skill_fail_chance(SKILL_HAULING, 100, SKILL_MAX+1)/(3/T.wet))))
		return

	var/slip_dist = 1
	var/slip_stun = 6
	var/floor_type = "wet"

	if(2 <= T.wet) // Lube
		floor_type = "slippery"
		slip_dist = 4
		slip_stun = 10

	if(slip("the [floor_type] floor", slip_stun))
		for(var/i = 1 to slip_dist)
			step(src, dir)
			sleep(1)

/mob/living/proc/HandleBloodTrail(turf/simulated/T)
	return

/mob/living/carbon/human/HandleBloodTrail(turf/simulated/T)
	// Tracking blood
	var/obj/item/source
	if(shoes)
		var/obj/item/clothing/shoes/S = shoes
		if(istype(S))
			S.handle_movement(src, MOVING_QUICKLY(src))
			if(S.coating && S.coating.total_volume > 1)
				source = S
	else
		for(var/bp in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/stomper = get_organ(bp)
			if(istype(stomper) && !stomper.is_stump() && stomper.coating && stomper.coating.total_volume > 1)
				source = stomper
	if(!source)
		return

	var/list/bloodDNA
	var/bloodcolor
	var/list/blood_data = REAGENT_DATA(source.coating, /decl/material/liquid/blood)
	if(blood_data)
		bloodDNA = list(blood_data["blood_DNA"] = blood_data["blood_type"])
	else
		bloodDNA = list()
	bloodcolor = source.coating.get_color()
	source.remove_coating(1)
	update_inv_shoes(1)

	if(species.get_move_trail(src))
		T.AddTracks(species.get_move_trail(src),bloodDNA, dir, 0, bloodcolor) // Coming
		var/turf/simulated/from = get_step(src, GLOB.reverse_dir[dir])
		if(istype(from))
			from.AddTracks(species.get_move_trail(src), bloodDNA, 0, dir, bloodcolor) // Going

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.blood_data[M.dna.unique_enzymes] = REAGENT_DATA(M.vessel, M.species.blood_reagent)
				var/datum/extension/forensic_evidence/forensics = get_or_create_extension(B, /datum/extension/forensic_evidence)
				forensics.add_data(/datum/forensics/blood_dna, M.dna.unique_enzymes)
			return 1 //we bloodied the floor
		blood_splatter(src, M, 1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/simulated/attackby(var/obj/item/thing, var/mob/user)
	if(isCoil(thing) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.turf_place(src, user)
		return TRUE
	return ..()

/turf/simulated/Initialize()
	if(GAME_STATE >= RUNLEVEL_GAME)
		fluid_update()
	. = ..()

/turf/simulated/Destroy()
	if (zone)
		if (can_safely_remove_from_zone())
			c_copy_air()
			zone.remove(src)
		else
			zone.rebuild()
	. = ..() 