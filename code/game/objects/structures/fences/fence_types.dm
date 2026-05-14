/decl/fence_type
	var/name              = "chain link fence"
	var/desc              = "A chain link fence. Not as effective as a wall, but generally it keeps people out."
	var/door_name         = "fence gate"
	var/door_desc         = "Much like a regular door, but thinner."
	var/fence_icon        = 'icons/obj/structures/fences/chain.dmi'
	var/single_state      = "single"
	var/corner_state      = "corner"
	var/straight_state    = "straight"
	var/post_state        = "post"
	var/end_state         = "end"
	var/three_way_state   = "three_way"
	var/four_way_state    = "four_way"
	var/door_state_closed = "door-opened"
	var/door_state_opened = "door-closed"

/decl/fence_type/validate()
	. = ..()

	if(!fence_icon)
		. += "missing fence icon"
		return

	if(!single_state || !check_state_in_icon(single_state, fence_icon))
		. += "missing or invalid single_state '[single_state]' from '[fence_icon]'"
	if(!straight_state || !check_state_in_icon(straight_state, fence_icon))
		. += "missing or invalid straight_state '[straight_state]' from '[fence_icon]'"
	if(!corner_state || !check_state_in_icon(corner_state, fence_icon))
		. += "missing or invalid corner_state '[corner_state]' from '[fence_icon]'"
	if(!post_state || !check_state_in_icon(post_state, fence_icon))
		. += "missing or invalid post_state '[post_state]' from '[fence_icon]'"
	if(!end_state || !check_state_in_icon(end_state, fence_icon))
		. += "missing or invalid end_state '[end_state]' from '[fence_icon]'"
	if(!door_state_closed || !check_state_in_icon(door_state_closed, fence_icon))
		. += "missing or invalid door_state_closed '[door_state_closed]' from '[fence_icon]'"
	if(!door_state_opened || !check_state_in_icon(door_state_opened, fence_icon))
		. += "missing or invalid door_state_opened '[door_state_opened]' from '[fence_icon]'"
	if(!three_way_state || !check_state_in_icon(three_way_state, fence_icon))
		. += "missing or invalid three_way_state '[three_way_state]' from '[fence_icon]'"
	if(!four_way_state || !check_state_in_icon(four_way_state, fence_icon))
		. += "missing or invalid four_way_state '[four_way_state]' from '[fence_icon]'"

/decl/fence_type/brick
	name       = "brick fence"
	desc       = "A brick fence. Not as effective as a wall, but generally it keeps people out."
	fence_icon = 'icons/obj/structures/fences/brick.dmi'

/decl/fence_type/palisade
	name       = "palisade"
	desc       = "A tall and imposing palisade with sharpened points atop it."
	fence_icon = 'icons/obj/structures/fences/palisade.dmi'

/decl/fence_type/stick
	name       = "stick fence"
	desc       = "A stick fence. Not as effective as a wall, but generally it keeps people out."
	fence_icon = 'icons/obj/structures/fences/stick.dmi'

/decl/fence_type/plank
	name       = "plank fence"
	desc       = "A plank fence. Not as effective as a wall, but generally it keeps people out."
	fence_icon = 'icons/obj/structures/fences/plank.dmi'
