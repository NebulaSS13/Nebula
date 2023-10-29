///////////////////////////////////////////////////////////////
// Poster Design
///////////////////////////////////////////////////////////////

///Contains information on what a poster displays.
/decl/poster_design
	abstract_type = /decl/poster_design
	///The display name/title of the design. Suffixed to the name of the medium displaying the design.
	var/name
	///The description of the design shown to users. This is suffixed to the description of the medium displaying this design.
	var/desc
	///Collectible serial number string, if any.
	var/serial_number
	///The icon to use for this design.
	var/icon = 'icons/obj/items/posters.dmi'
	///The icon state to use for this design. The display medium will use this to pick it's icon state.
	var/icon_state

/decl/poster_design/Initialize()
	. = ..()
	generate_serial_number()

/decl/poster_design/proc/generate_serial_number()
	if(length(serial_number))
		return
	serial_number = "serial #[sequential_id(/decl/poster_design)]"

/decl/poster_design/validate()
	. = ..()
	if(!icon_state)
		. += "no icon_state set"
	if(!icon)
		. += "no icon set"
	if(icon && icon_state && !check_state_in_icon(icon_state, icon))
		. += "icon state [icon_state] not present in [icon]"
