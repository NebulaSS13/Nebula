///////////////////////////////////////////////////////////////////////////////////
// Map Definitions
///////////////////////////////////////////////////////////////////////////////////

/obj/structure/sign/double/map
	name = "map"
	desc = "A framed map."
	icon = 'icons/obj/signs/maps.dmi'
	abstract_type = /obj/structure/sign/double/map

/obj/structure/sign/double/map/left
	icon_state = "map-left"
/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/double/map/update_description()
	var/thename = global.station_name()
	SetName("map of \the [thename]")
	desc = "A framed map of \the [thename]."
