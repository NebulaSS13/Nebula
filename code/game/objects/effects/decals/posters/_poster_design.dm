///////////////////////////////////////////////////////////////
// Poster Design
///////////////////////////////////////////////////////////////

///Contains information on what a poster displays.
/decl/poster_design
	///The display name/title of the design. Suffixed to the name of the medium displaying the design.
	var/name
	///The description of the design shown to users. This is suffixed to the description of the medium displaying this design.
	var/desc
	///Collectible serial number string, if any.
	var/serial_number
	///The icon state to use for this design. The display medium will use this to pick it's icon.
	var/icon_state

/decl/poster_design/Initialize()
	. = ..()
	generate_serial_number()

/decl/poster_design/proc/generate_serial_number()
	if(length(serial_number))
		return
	serial_number = "serial #[sequential_id(/decl/poster_design)]"
