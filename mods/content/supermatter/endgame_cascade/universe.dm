/datum/universal_state/supermatter_cascade
 	name = "Supermatter Cascade"
 	desc = "Unknown harmonance affecting universal substructure, converting nearby matter to supermatter."

 	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0

/datum/universal_state/supermatter_cascade/OnTurfChange(var/turf/T)
	var/turf/space/S = T
	if(istype(S))
		S.set_color("#0066ff")
	else
		S.set_color(initial(S.color))

/datum/universal_state/supermatter_cascade/DecayTurf(var/turf/T)
	T.handle_universal_decay()

// Apply changes when entering state
/datum/universal_state/supermatter_cascade/OnEnter()
	set background = 1
	to_world("<span class='sinister' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>")
	sound_to(world, sound('sound/effects/cascade.ogg'))

	for(var/mob/M in global.player_list)
		M.flash_eyes()

	if(SSevac.evacuation_controller?.cancel_evacuation())
		priority_announcement.Announce("The evacuation has been aborted due to severe distortion of local space-time.")

	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()

	PlayerSet()
	SSskybox.change_skybox("cascade", new_use_stars = FALSE, new_use_overmap_details = FALSE)

	var/spawned_exit = FALSE
	if(length(global.endgame_exits))
		spawned_exit = new /obj/effect/wormhole_exit(pick(global.endgame_exits))

	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/universal_state/supermatter_cascade, announce_end_of_universe), spawned_exit), rand(30, 60) SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/universal_state/supermatter_cascade, finalize_end_of_universe)), 5 MINUTES)

/datum/universal_state/supermatter_cascade/proc/announce_end_of_universe(var/exit_exists)
	var/end_message = "Attn. [global.using_map.station_name]: Severe gravitational anomalies of unheard of scope have been detected in the local volume. Size and intensity of anomalies are increasing exponentially. Within the hour, a newborn black hole will have consumed everything in this sector."
	if(exit_exists)
		end_message += "\n\nCuriously, the distortion is predicted to form a traversable wormhole quite close to your current location in approximately five minutes. The terminus is unknown, but it must be better than behind a hungry singularity. Godspeed."
	end_message += "\n\nAUTOMATED ALERT: Link to [global.using_map.boss_name] lost."
	priority_announcement.Announce(end_message, "SUPERMATTER CASCADE DETECTED")

/datum/universal_state/supermatter_cascade/proc/finalize_end_of_universe()
	global.cinematic.station_explosion_cinematic(0,null) // TODO: Custom cinematic
	universe_has_ended = TRUE

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/A as anything in global.areas)
		var/invalid_area = FALSE
		for(var/check_area in global.using_map.get_universe_end_evac_areas())
			if(istype(A, check_area))
				invalid_area = TRUE
				break
		if(!invalid_area)
			A.update_icon()

// TODO: Should this be changed to use the actual ambient lights system...?
/datum/universal_state/supermatter_cascade/OverlayAndAmbientSet()
	spawn(0)
		// TODO: dear god anything but this
		for(var/datum/lighting_corner/L)
			if(isAdminLevel(L.z))
				L.update_lumcount(1,1,1)
			else
				L.update_lumcount(0.0, 0.4, 1)

			CHECK_TICK

		for(var/turf/space/T)
			OnTurfChange(T)
			CHECK_TICK

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in SSmachines.machinery)
		if (!(alm.stat & BROKEN))
			alm.explosion_act(2)

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in SSmachines.machinery)
		if (!(APC.stat & BROKEN) && !APC.is_critical)
			APC.chargemode = 0
			var/obj/item/cell/cell = APC.get_cell()
			if(cell)
				cell.charge = 0
			APC.emagged = 1
			APC.queue_icon_update()

/datum/universal_state/supermatter_cascade/proc/PlayerSet()
	for(var/datum/mind/M in global.player_list)
		if(!isliving(M.current))
			continue
		if(M.current.stat != DEAD)
			SET_STATUS_MAX(M.current, STAT_WEAK, 10)
			M.current.flash_eyes()

		clear_antag_roles(M)
