/obj/turbolift_map_holder/fairpoint
	depth = 2
	lift_size_x = 4
	lift_size_y = 4

// POLICE STATION
/obj/turbolift_map_holder/fairpoint/sec
	name = "Fairpoint turbolift map placeholder - Security"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/pd_ground,
		/area/turbolift/pd_top
		)

/obj/turbolift_map_holder/fairpoint/hospital
	name = "Fairpoint turbolift map placeholder - Hospital"
	dir = NORTH

	areas_to_use = list(
		/area/turbolift/hospital_sewers,
		/area/turbolift/hospital_surface,
		/area/turbolift/hospital_top
		)

// DIRECT SEWER ACCESS
/obj/turbolift_map_holder/fairpoint/cargo
	name = "Fairpoint turbolift map placeholder - Mining Access"

	areas_to_use = list(
		/area/turbolift/sewer_exit/mining,
		/area/turbolift/sewer_entrance/mining
		)

/obj/turbolift_map_holder/fairpoint/sewer1
	name = "Fairpoint turbolift map placeholder - Sewer Entrance 1"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/sewer_exit,
		/area/turbolift/sewer_entrance
		)

// METRO
/obj/turbolift_map_holder/fairpoint/metro
	name = "Fairpoint turbolift map placeholder - Metro Entrance"
	dir = WEST

	areas_to_use = list(
		/area/turbolift/metro_maintenance,
		/area/turbolift/metro_station
		)
