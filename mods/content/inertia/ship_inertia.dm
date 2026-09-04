/obj/effect/overmap/visitable/ship
	/// Whether or not this ship throws mobs on acceleration if dampers are inactive.
	var/needs_dampers = FALSE
	/// A list of inertial damping controller datums associated with this ship.
	var/list/datum/ship_inertial_damper/inertial_dampers = list()
	/// The current damping strength from all inertial dampers, recalculated every tick in the ship's Process().
	var/tmp/damping_strength = null

/obj/effect/overmap/visitable/ship/populate_sector_objects()
	..()
	for(var/datum/ship_inertial_damper/damper_datum in global.ship_inertial_dampers)
		if(check_ownership(damper_datum.holder))
			inertial_dampers |= damper_datum

// Theoretically there's no need to recalculate this every tick,
// instead it should be recalculated any time damping strength changes
// based only on the damper that changed.
/obj/effect/overmap/visitable/ship/Process(wait, tick)
	. = ..()
	damping_strength = 0
	for(var/datum/ship_inertial_damper/damper_datum in inertial_dampers)
		damping_strength += damper_datum.get_damping_strength(TRUE)

/obj/effect/overmap/visitable/ship/adjust_speed(n_x, n_y)
	. = ..()
	var/magnitude = norm(n_x, n_y)
	var/inertia_dir = magnitude >= 0 ? turn(fore_dir, 180) : fore_dir
	var/inertia_strength = magnitude * 1e3
	if(needs_dampers && damping_strength < inertia_strength)
		var/list/areas_by_name = area_repository.get_areas_by_z_level()
		for(var/area_name in areas_by_name)
			var/area/the_area = areas_by_name[area_name]
			if(area_belongs_to_zlevels(the_area, map_z))
				the_area.throw_unbuckled_occupants(inertia_strength+2, inertia_strength, inertia_dir)

// Add additional data to the engine console.
/obj/machinery/computer/ship/engines/modify_ship_ui_data(list/ui_data)
	var/damping_strength = 0
	for(var/datum/ship_inertial_damper/inertia_controller in linked.inertial_dampers)
		damping_strength += inertia_controller.holder.get_damping_strength(FALSE) // get only the level it's set to, not the actual level
	ui_data["damping_strength"] = damping_strength
	ui_data["needs_dampers"] = linked.needs_dampers