SUBSYSTEM_DEF(flows)
	name = "Flows"
	wait = 1 SECOND
	flags = SS_NO_INIT

	var/tmp/list/pending_flows = list()
	var/tmp/flows_copied_yet = FALSE
	var/tmp/list/processing_flows

/datum/controller/subsystem/flows/stat_entry()
	..("Q:[pending_flows.len]")

/datum/controller/subsystem/flows/fire(resumed = 0)

	if(!resumed)
		flows_copied_yet = FALSE

	if(!flows_copied_yet)
		flows_copied_yet = TRUE
		processing_flows = pending_flows.Copy()

	// Local references for speed.
	var/turf/current_turf
	var/datum/reagents/reagent_holder

	while(processing_flows.len)
		current_turf = processing_flows[processing_flows.len]
		processing_flows.len--
		if(!istype(current_turf))
			continue
		reagent_holder = current_turf.reagents || current_turf.create_reagents(FLUID_MAX_DEPTH)
		var/pushed_something = FALSE
		if(reagent_holder.total_volume > FLUID_SHALLOW && current_turf.last_flow_strength >= 10)
			for(var/atom/movable/AM AS_ANYTHING in current_turf.get_contained_external_atoms())
				if(AM.is_fluid_pushable(current_turf.last_flow_strength))
					AM.pushed(current_turf.last_flow_dir)
					pushed_something = TRUE
		if(pushed_something && prob(1))
			playsound(current_turf, 'sound/effects/slosh.ogg', 25, 1)
		if(MC_TICK_CHECK)
			return
