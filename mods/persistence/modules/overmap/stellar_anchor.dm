#define BASE_TURF_UPKEEP_COST 50

/obj/machinery/network/stellar_anchor
	name = "stellar anchor"
	main_template = "stellar_anchor.tmpl"

	var/list/anchored_areas = list()

/obj/machinery/network/stellar_anchor/Initialize()
	. = ..()
	GLOB.world_saving_event.register(SSpersistence, src, /obj/machinery/network/stellar_anchor/proc/on_world_saving)

/obj/machinery/network/stellar_anchor/Destroy()
	. = ..()
	GLOB.world_saving_event.unregister(SSpersistence, src)

/obj/machinery/network/stellar_anchor/proc/on_world_saving()
	if(is_paid())
		refresh_anchored_areas()
		for(var/A in anchored_areas)
			SSpersistence.AddSavedArea(A)

// returns whether or not the place the stellar_anchor is, is a viable place to actually anchor/persist something.
/obj/machinery/network/stellar_anchor/proc/is_valid_location(var/produce_error = TRUE)
	var/turf/T = get_turf(src)
	if(T.z in SSpersistence.saved_levels)
		if(produce_error)
			error = "This location is already stabilized."
		return FALSE

	var/area/A = get_area(T)
	for(var/obj/machinery/network/stellar_anchor/other_anchor in world)
		if(other_anchor == src)
			continue
		if(A in other_anchor.anchored_areas)
			if(produce_error)
				error = "This area is already stabilized by another stellar anchor."
			return FALSE

	var/obj/effect/overmap/visitable/sector/sector = map_sectors["[T.z]"]
	if(istype(sector, /obj/effect/overmap/visitable/sector/exoplanet) || !(sector.sector_flags & OVERMAP_SECTOR_IN_SPACE))
		if(produce_error)
			error = "Cannot anchor a stellar body this large."
		return FALSE
	return TRUE

/obj/machinery/network/stellar_anchor/proc/get_anchored_turf_count()
	. = 0
	for(var/area/A in anchored_areas)
		.+= length(A)

// The amount in moneys to upkeep this every week.
/obj/machinery/network/stellar_anchor/proc/get_upkeep()
	return get_anchored_turf_count() * BASE_TURF_UPKEEP_COST

// The amount in moneys to found this stellar anchor.
/obj/machinery/network/stellar_anchor/proc/get_founding_cost()
	return get_upkeep() * 1.5

/obj/machinery/network/stellar_anchor/proc/is_paid()
	return TRUE

/obj/machinery/network/stellar_anchor/after_save()
	. = ..()
	if(is_paid())
		for(var/A in anchored_areas)
			SSpersistence.RemoveSavedArea(A)

// Refreshes the anchored_areas list if necessary.
/obj/machinery/network/stellar_anchor/proc/refresh_anchored_areas()


// Ship core for shuttles specifically.
/obj/machinery/network/stellar_anchor/ship_core
	name = "ship core"
	var/datum/shuttle/parent_shuttle
	var/is_landable = TRUE

/obj/machinery/network/stellar_anchor/ship_core/after_save()
	. = ..()
	
	if(istype(parent_shuttle) && length(anchored_areas) && SSpersistence.in_loaded_world)
		// Landmark it
		var/obj/effect/shuttle_landmark/ship/landmark = new()
		landmark.shuttle_name = parent_shuttle.name
		landmark.loc = loc

		// Rebuild shuttle effect.
		var/obj/effect/overmap/visitable/ship/landable/ship = new()
		ship.name = parent_shuttle.name
		ship.loc = loc
		ship.shuttle = parent_shuttle
		ship.landmark = landmark

/obj/machinery/network/stellar_anchor/ship_core/refresh_anchored_areas()
	anchored_areas.Cut(1)

	if(!istype(parent_shuttle))
		return

	for(var/A in parent_shuttle.shuttle_area)
		anchored_areas |= A

// Landmark override
/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(!shuttle_name && src.shuttle_name)
		return ..(mapload, src.shuttle_name)
	return ..()