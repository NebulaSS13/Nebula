/obj/abstract/map_data
	name = "Map Data"
	desc = "An unknown location."
	icon_state = "map_data"

	var/height = 1     ///< The number of Z-Levels in the map.

// If the height is more than 1, we mark all contained levels as connected.
// This initializes immediately because it is an auxiliary effect specifically needed pre-SSatoms init.
INITIALIZE_IMMEDIATE(/obj/abstract/map_data)
/obj/abstract/map_data/Initialize(mapload, _height)
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return INITIALIZE_HINT_QDEL
	if(_height)
		height = _height
	for(var/i = (loc.z - height + 1) to (loc.z-1))
		if (z_levels.len <i)
			z_levels.len = i
		z_levels[i] = src

	if (length(SSzcopy.zlev_maximums))
		SSzcopy.calculate_zstack_limits()
	return ..()

/obj/abstract/map_data/Destroy(forced)
	if(forced)
		new type(loc, height) // Will replace our references in z_levels
		return ..()
	return QDEL_HINT_LETMELIVE
