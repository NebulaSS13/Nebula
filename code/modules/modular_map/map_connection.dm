// Connection data for use by the modular map generator and templates
/datum/mm_connection
	/// Outgoing/facing direction of this connection.
	var/direction_string
	// Incoming/reverse facing direction of this connection.
	var/reverse_direction_string
	/// x-offset within the overall map structure (0 is hard left)
	var/offset_x
	/// y-offset within the overall map structure (0 is hard bottom).
	var/offset_y
	/// x-offset for the cell this connection would connect to.
	var/target_x = 0
	/// y-offset for the cell this connection would connect to.
	var/target_y = 0
	/// A list of valid connection constants for sections joining with this connection.
	var/connection_flags
	/// Reference to our owning template to simplify connection compatibility checking.
	var/datum/map_template/modular/template

/datum/mm_connection/proc/can_connect_to(datum/mm_connection/other)

	// Connections are not aligned; no dice.
	if(direction_string != other.reverse_direction_string)
		return FALSE

	// Null connections just need to be facing another null connection, they don't care about template compat.
	var/self_dummy  = !!(connection_flags & MCF_BLOCKER)
	var/other_dummy = !!(other.connection_flags & MCF_BLOCKER)
	if(self_dummy || other_dummy)
		return self_dummy == other_dummy

	// Connection type is not permitted from this template; still no dice.
	if(!(other.connection_flags & template.connection_flag))
		return FALSE

	// Connection type is not permitted to that template; still no dice.
	if(!(connection_flags & other.template.connection_flag))
		return FALSE

	return TRUE

/datum/mm_connection/New(_dir, _x, _y, _connect)

	offset_x = _x
	offset_y = _y

	direction_string = _dir
	switch(direction_string)
		if("NORTH")
			reverse_direction_string = "SOUTH"
			target_y = 1
		if("SOUTH")
			reverse_direction_string = "NORTH"
			target_y = -1
		if("EAST")
			reverse_direction_string = "WEST"
			target_x = 1
		if("WEST")
			reverse_direction_string = "EAST"
			target_x = -1

	connection_flags = _connect

/datum/mm_connection/closed // just making a stub type for ease of debugging
