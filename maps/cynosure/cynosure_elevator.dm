/obj/abstract/turbolift_spawner/cynosure
	depth = 2
	lift_size_x = 4
	lift_size_y = 4

/obj/abstract/turbolift_spawner/cynosure/west
	name = "Cynosure turbolift map placeholder - West"
	dir = EAST
	depth = 3

	areas_to_use = list(
		/area/turbolift/west_bmt,
		/area/turbolift/west_gnd,
		/area/turbolift/west_snd
		)

/obj/abstract/turbolift_spawner/cynosure/center
	name = "Cynosure turbolift map placeholder - Center"
	dir = WEST
	depth = 3
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/center_bmt,
		/area/turbolift/center_gnd,
		/area/turbolift/center_snd
		)

/obj/abstract/turbolift_spawner/cynosure/cargo
	name = "Cynosure turbolift map placeholder - Cargo"
	dir = WEST

	areas_to_use = list(
		/area/turbolift/cargo_gnd,
		/area/turbolift/cargo_snd
		)

/obj/abstract/turbolift_spawner/cynosure/engineering
	name = "Cynosure turbolift map placeholder - Engineering"
	dir = SOUTH
	depth = 3

	areas_to_use = list(
		/area/turbolift/eng_bmt,
		/area/turbolift/eng_gnd,
		/area/turbolift/eng_snd
		)

/obj/abstract/turbolift_spawner/cynosure/medbay
	name = "Cynosure turbolift map placeholder - Medbay"
	dir = EAST
	depth = 3
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/med_bmt,
		/area/turbolift/med_gnd,
		/area/turbolift/med_snd
		)

/obj/abstract/turbolift_spawner/cynosure/sci
	name = "Cynosure turbolift map placeholder - Science"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/sci_bmt,
		/area/turbolift/sci_gnd
		)

/obj/abstract/turbolift_spawner/cynosure/sec
	name = "Cynosure turbolift map placeholder - Security"
	dir = NORTH
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/sec_gnd,
		/area/turbolift/sec_snd
		)