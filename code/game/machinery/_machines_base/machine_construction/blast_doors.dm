//Uses default states except with a door board needed.
// Cannot use airlock states, because blast doors do not weld or act the same way as airlocks
/decl/machine_construction/default/panel_closed/blast_door
	needs_board = "door"
	down_state = /decl/machine_construction/default/panel_open/blast_door

/decl/machine_construction/default/panel_open/blast_door
	needs_board = "door"
	up_state = /decl/machine_construction/default/panel_closed/blast_door

