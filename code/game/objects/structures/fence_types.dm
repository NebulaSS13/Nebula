/decl/fence_type
	var/name              = "chain link fence"
	var/desc              = "A chain link fence. Not as effective as a wall, but generally it keeps people out."
	var/corner_state      = "corner"
	var/straight_state    = "straight"
	var/post_state        = "post"
	var/end_state         = "end"
	var/door_closed_state = "door-opened"
	var/door_open_state   = "door-closed"

/decl/fence_type/brick
	name              = "brick fence"
	desc              = "A brick fence. Not as effective as a wall, but generally it keeps people out."
	corner_state      = "corner_stone"
	straight_state    = "straight_stone"
	post_state        = "post_stone"
	end_state         = "end_stone"
	door_closed_state = "door_stone-opened"
	door_open_state   = "door_stone-closed"

/decl/fence_type/palisade
	name              = "palisade"
	desc              = "A tall and imposing palisade with sharpened points atop it."
	corner_state      = "corner_palisade"
	straight_state    = "straight_palisade"
	post_state        = "post_palisade"
	end_state         = "end_palisade"
	door_closed_state = "door_palisade-opened"
	door_open_state   = "door_palisade-closed"

/decl/fence_type/stick
	name              = "stick fence"
	desc              = "A stick fence. Not as effective as a wall, but generally it keeps people out."
	corner_state      = "corner_stick"
	straight_state    = "straight_stick"
	post_state        = "post_stick"
	end_state         = "end_stick"
	door_closed_state = "door_stick-opened"
	door_open_state   = "door_stick-closed"

/decl/fence_type/plank
	name              = "plank fence"
	desc              = "A plank fence. Not as effective as a wall, but generally it keeps people out."
	corner_state      = "corner_plank"
	straight_state    = "straight_plank"
	post_state        = "post_plank"
	end_state         = "end_plank"
	door_closed_state = "door_plank-opened"
	door_open_state   = "door_plank-closed"
