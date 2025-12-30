/client/proc/fixatmos()
	set category = "Admin"
	set name = "Fix Atmospherics Grief"

	if(!check_rights(R_ADMIN|R_DEBUG)) return

	if(alert("WARNING: Executing this command will perform a full reset of atmosphere. All pipelines will lose any gas that may be in them, and all zones will be reset to contain air mix as on roundstart. This may require any atmos-based generators to shut down. Do not use unless the map is suffering serious atmospheric issues due to grief or bug.", "Full Atmosphere Reboot", "No", "Yes") == "No")
		return
	SSstatistics.add_field_details("admin_verb","FA")

	log_and_message_admins("Full atmosphere reset initiated by [usr].")
	to_world(SPAN_DANGER("Initiating restart of atmosphere. The server may lag a bit."))
	sleep(10)
	var/current_time = world.timeofday

	var/list/steps = decls_repository.get_decls_of_subtype_unassociated(/decl/atmos_grief_fix_step)
	steps = sortTim(steps.Copy(), /proc/cmp_decl_sort_value_asc)
	var/step_count = length(steps)
	for(var/step_index in 1 to step_count)
		var/decl/atmos_grief_fix_step/fix_step = steps[step_index]
		to_chat(usr, "\[[step_index]/[step_count]\] - [fix_step.name].")
		fix_step.act()
	to_world(SPAN_DANGER("Atmosphere restart completed in <b>[(world.timeofday - current_time)/(1 SECOND)]</b> seconds."))

/decl/atmos_grief_fix_step
	abstract_type = /decl/atmos_grief_fix_step
	var/name

/decl/atmos_grief_fix_step/proc/act()
	return

/decl/atmos_grief_fix_step/purge_pipenets
	name = "All pipenets purged of gas"
	sort_order = 1

/decl/atmos_grief_fix_step/purge_pipenets/act()
	// Remove all gases from all pipenets
	for(var/datum/pipe_network/PN as anything in SSmachines.pipenets)
		for(var/datum/gas_mixture/G in PN.gases)
			G.gas.Cut()
			G.update_values()

/decl/atmos_grief_fix_step/delete_zones
	name = "All ZAS Zones removed"
	sort_order = 2

/decl/atmos_grief_fix_step/delete_zones/act()
	// Delete all zones.
	for(var/zone/Z in SSair.zones)
		Z.c_invalidate()

/decl/atmos_grief_fix_step/reset_turfs
	name = "All turfs reset to roundstart values"
	sort_order = 3

/decl/atmos_grief_fix_step/reset_turfs/act()
	var/list/unsorted_overlays = list()
	var/list/all_gasses = decls_repository.get_decls_of_subtype(/decl/material/gas)
	for(var/id in all_gasses)
		var/decl/material/mat = all_gasses[id]
		unsorted_overlays |= mat.gas_tile_overlay

	for(var/turf/T in world)
		T.air = null
		T.zone = null

/decl/atmos_grief_fix_step/reboot_zas
	name = "ZAS Rebooted"
	sort_order = 4

/decl/atmos_grief_fix_step/reboot_zas/act()
	SSair.reboot()
