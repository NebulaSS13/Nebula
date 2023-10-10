/turf/simulated
	name = "station"
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	open_turf_type = /turf/simulated/open
	zone_membership_candidate = TRUE

	var/wet = 0
	var/image/wet_overlay = null
	var/dirt = 0
	var/timer_id

// This is not great.
/turf/simulated/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)

	if(is_flooded(absolute = TRUE))
		return

	if(get_fluid_depth() > FLUID_QDEL_POINT)
		return

	if(wet_val < wet && !overwrite)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		overlays += wet_overlay

	timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor), 8 SECONDS, (TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE))

/turf/simulated/proc/unwet_floor(var/check_very_wet = TRUE)
	if(check_very_wet && wet >= 2)
		wet--
		timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor), 8 SECONDS, (TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE))
		return
	wet = 0
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	. = ..()

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
		A.OnSimulatedTurfEntered(src, OL)

/atom/proc/OnSimulatedTurfEntered(turf/simulated/T, old_loc)
	set waitfor = FALSE
	return

/mob/living/OnSimulatedTurfEntered(turf/simulated/T, old_loc)
	T.update_dirt()

	HandleBloodTrail(T, old_loc)

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

	// Dir check to avoid slipping up and down via ladders.
	if(slip("the [floor_type] floor", slip_stun) && (dir in global.cardinal))
		for(var/i = 1 to slip_dist)
			step(src, dir)
			sleep(1)

/mob/living/proc/HandleBloodTrail(turf/simulated/T, old_loc)
	return

/mob/living/carbon/human/HandleBloodTrail(turf/simulated/T, old_loc)
	// Tracking blood
	var/obj/item/source
	var/obj/item/clothing/shoes/shoes = get_equipped_item(slot_shoes_str)
	if(istype(shoes))
		shoes.handle_movement(src, MOVING_QUICKLY(src))
		if(shoes.coating && shoes.coating.total_volume > 1)
			source = shoes
	else
		for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/stomper = GET_EXTERNAL_ORGAN(src, foot_tag)
			if(stomper && stomper.coating && stomper.coating.total_volume > 1)
				source = stomper
	if(!source)
		species.handle_trail(src, T, old_loc)
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
		if(istype(old_loc, /turf/simulated))
			var/turf/simulated/old_turf = old_loc
			old_turf.AddTracks(species.get_move_trail(src), bloodDNA, 0, dir, bloodcolor) // Going

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(M.dna?.unique_enzymes && !LAZYACCESS(B.blood_DNA, M.dna.unique_enzymes))
				LAZYSET(B.blood_DNA, M.dna.unique_enzymes, M.dna.b_type)
				LAZYSET(B.blood_data, M.dna.unique_enzymes, REAGENT_DATA(M.vessel, M.species.blood_reagent))
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

/turf/simulated/attackby(var/obj/item/thing, var/mob/user)
	if(IS_COIL(thing) && try_build_cable(thing, user))
		return TRUE
	return ..()

/turf/simulated/Initialize(var/ml)
	var/area/A = loc
	holy = istype(A) && (A.area_flags & AREA_FLAG_HOLY)
	levelupdate()
	. = ..()
