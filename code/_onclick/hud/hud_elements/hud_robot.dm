/datum/hud/robot
	gun_mode_toggle_type    = /obj/screen/gun/mode
	omit_hud_elements       = list(
		/decl/hud_element/health,
		/decl/hud_element/charge,
		/decl/hud_element/bodytemp,
		/decl/hud_element/oxygen,
		/decl/hud_element/toxins,
		/decl/hud_element/pressure,
		/decl/hud_element/nutrition,
		/decl/hud_element/hydration,
		/decl/hud_element/maneuver,
		/decl/hud_element/movement,
		/decl/hud_element/resist,
		/decl/hud_element/drop,
		/decl/hud_element/throw_toggle,
		/decl/hud_element/internals,
	)
	additional_hud_elements = list(
		/decl/hud_element/health/robot,
		/decl/hud_element/charge/robot,
		/decl/hud_element/oxygen/robot,
		/decl/hud_element/module_selection,
		/decl/hud_element/robot_inventory,
		/decl/hud_element/robot_radio,
		/decl/hud_element/robot_store,
		/decl/hud_element/robot_drop_grab
	)

/decl/hud_element/oxygen/robot
	elem_reference_type = /decl/hud_element/oxygen
	elem_type = /obj/screen/warning/oxygen/robot

/decl/hud_element/health/robot
	elem_reference_type = /decl/hud_element/health
	elem_type = /obj/screen/health/robot

/decl/hud_element/charge/robot
	elem_reference_type = /decl/hud_element/charge
	elem_type = /obj/screen/need/cell_charge/robot

/decl/hud_element/robot_inventory
	elem_type = /obj/screen/robot/inventory
	elem_is_auxilliary = FALSE

/decl/hud_element/module_selection
	elem_type = /obj/screen/robot/module
	elem_is_auxilliary = FALSE

/decl/hud_element/robot_radio
	elem_type = /obj/screen/robot/radio

/decl/hud_element/robot_store
	elem_type = /obj/screen/robot/store

/decl/hud_element/robot_drop_grab
	elem_type = /obj/screen/robot/drop_grab
	elem_updates_in_life = TRUE
