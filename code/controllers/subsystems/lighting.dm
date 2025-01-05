SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = LIGHTING_INTERVAL
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_LIGHTING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/total_lighting_overlays = 0
	var/total_lighting_sources = 0
	var/total_ambient_turfs = 0
	var/total_lighting_corners = 0

	/// lighting sources  queued for update.
	var/list/light_queue   = list()
	var/lq_idex = 1
	/// lighting corners  queued for update.
	var/list/corner_queue  = list()
	var/cq_idex = 1
	/// lighting overlays queued for update.
	var/list/overlay_queue = list()
	var/oq_idex = 1

	var/tmp/processed_lights = 0
	var/tmp/processed_corners = 0
	var/tmp/processed_overlays = 0

	var/total_ss_updates = 0
	var/total_instant_updates = 0

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	var/instant_ctr = 0
	var/force_queued = TRUE
	/// For admins.
	var/force_override = FALSE
#endif

/datum/controller/subsystem/lighting/stat_entry()
	var/list/out = list(
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
		"IUR: [total_ss_updates ? round(total_instant_updates/(total_instant_updates+total_ss_updates)*100, 0.1) : "NaN"]% Instant: [force_queued ? "Disabled" : "Allowed"]\n",
#endif
		"\tT: { L: [total_lighting_sources] C: [total_lighting_corners] O:[total_lighting_overlays] A: [total_ambient_turfs] }\n",
		"\tP: { L: [light_queue.len - (lq_idex - 1)] C: [corner_queue.len - (cq_idex - 1)] O: [overlay_queue.len - (oq_idex - 1)] }\n",
		"\tL: { L: [processed_lights] C: [processed_corners] O: [processed_overlays]}\n"
	)
	..(out.Join())

// If intelligent updates are off, this is just an empty stub.
/datum/controller/subsystem/lighting/proc/handle_roundstart()
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	force_queued = FALSE
	total_ss_updates = 0
	total_instant_updates = 0

/// Disable instant updates, relying entirely on the (slower, but less laggy) queued pathway. Use if changing a *lot* of lights.
/datum/controller/subsystem/lighting/proc/pause_instant()
	if (force_override)
		return

	instant_ctr += 1
	if (instant_ctr == 1)
		force_queued = TRUE

/// Resume instant updates.
/datum/controller/subsystem/lighting/proc/resume_instant()
	if (force_override)
		return

	instant_ctr = max(instant_ctr - 1, 0)

	if (!instant_ctr)
		force_queued = FALSE

#else

/datum/controller/subsystem/lighting/proc/pause_instant()

/datum/controller/subsystem/lighting/proc/resume_instant()

#endif

/datum/controller/subsystem/lighting/Initialize(timeofday)
	var/overlaycount = 0
	var/starttime = REALTIMEOFDAY

	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		var/datum/level_data/level = SSmapping.levels_by_z[zlevel]
		for (var/turf/tile as anything in block(1, 1, zlevel, level.level_max_width, level.level_max_height)) // include TRANSITIONEDGE turfs
			if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(tile))
				if(!isnull(tile.lighting_overlay))
					log_warning("Attempted to create lighting_overlay on [tile.get_log_info_line()] when it already had one.")
					continue
				new /atom/movable/lighting_overlay(tile)
				overlaycount++
			CHECK_TICK

	admin_notice(SPAN_DANGER("Created [overlaycount] lighting overlays in [(REALTIMEOFDAY - starttime)/10] seconds."), R_DEBUG)

	starttime = REALTIMEOFDAY
	// Tick once to clear most lights.
	fire(FALSE, TRUE)

	admin_notice(SPAN_DANGER("Processed [processed_lights] light sources."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_corners] light corners."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_overlays] light overlays."), R_DEBUG)
	admin_notice(SPAN_DANGER("Lighting pre-bake completed in [(REALTIMEOFDAY - starttime)/10] seconds."), R_DEBUG)

	log_ss("lighting", "NOv:[overlaycount] L:[processed_lights] C:[processed_corners] O:[processed_overlays]")

	..()

/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_lights = 0
		processed_corners = 0
		processed_overlays = 0

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_lights = light_queue
	var/list/curr_corners = corner_queue
	var/list/curr_overlays = overlay_queue

	while (lq_idex <= curr_lights.len)
		var/datum/light_source/L = curr_lights[lq_idex++]

		if (L.needs_update != LIGHTING_NO_UPDATE)
			total_ss_updates += 1
			L.update_corners()

			L.needs_update = LIGHTING_NO_UPDATE

			processed_lights++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (lq_idex > 1)
		curr_lights.Cut(1, lq_idex)
		lq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (cq_idex <= curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[cq_idex++]

		if (C.needs_update)
			C.update_overlays()

			C.needs_update = FALSE

			processed_corners++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (cq_idex > 1)
		curr_corners.Cut(1, cq_idex)
		cq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (oq_idex <= curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[oq_idex++]

		if (!QDELETED(O) && O.needs_update)
			O.update_overlay()
			O.needs_update = FALSE

			processed_overlays++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (oq_idex > 1)
		curr_overlays.Cut(1, oq_idex)
		oq_idex = 1

/datum/controller/subsystem/lighting/Recover()
	total_lighting_corners = SSlighting.total_lighting_corners
	total_lighting_overlays = SSlighting.total_lighting_overlays
	total_lighting_sources = SSlighting.total_lighting_sources

	light_queue = SSlighting.light_queue
	corner_queue = SSlighting.corner_queue
	overlay_queue = SSlighting.overlay_queue

	lq_idex = SSlighting.lq_idex
	cq_idex = SSlighting.cq_idex
	oq_idex = SSlighting.oq_idex

	if (lq_idex > 1)
		light_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (cq_idex > 1)
		corner_queue.Cut(1, cq_idex)
		cq_idex = 1

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
