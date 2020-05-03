/datum/wrapper/area
	var/area_type
	var/name
	var/turfs
	var/has_gravity
	var/apc

/datum/wrapper/area/New(var/area/A)
	if(A)
		area_type = A.type
		name = A.name
		turfs = A.get_turf_coords()
		has_gravity = A.has_gravity
		apc = A.apc

/datum/wrapper/multiz
	var/list/saved_z_levels = list() // a list of booleans on which z-levels are connected....

/datum/wrapper/multiz/proc/get_connected_zlevels()
	// var/saved_zlevels = SSmapping.saved_levels
	var/highest_zlevel = max(SSmapping.saved_levels)
	saved_z_levels = z_levels.Copy(1, highest_zlevel)


/datum/wrapper/decal
	var/icon
	var/icon_state
	var/appearance_flags
	var/color
	var/dir
	var/plane
	var/layer
	var/alpha
	var/detail_overlay
	var/detail_color
	var/x
	var/y
	var/z

/datum/wrapper/decal/New(var/image/I, var/turf/T)
	if(!I)
		return // This was a deserial
	x = T.x
	y = T.y
	z = T.z
	icon = "[I.icon]"
	icon_state = I.icon_state
	appearance_flags = I.appearance_flags
	color = I.color
	dir = I.dir
	plane = I.plane
	layer = I.layer
	alpha = I.alpha
	if(length(I.overlays) > 0)
		var/image/overlay = I.overlays[1]
		detail_color = overlay.color
		detail_overlay = overlay.icon_state

/datum/wrapper/decal/after_deserialize()
	..()
	if(!icon)
		return
	icon = file(icon)
	var/turf/T = locate(x, y, z)
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		layer = T.is_plating() ? DECAL_PLATING_LAYER : DECAL_LAYER
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[plane]-[layer]-[detail_overlay]-[detail_color]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.layer = layer
			I.appearance_flags = appearance_flags
			I.color = src.color
			I.alpha = src.alpha
			if(detail_overlay)
				var/image/B = overlay_image(icon, "[detail_overlay]", flags=RESET_COLOR)
				B.color = detail_color
				I.overlays |= B
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.overlays |= floor_decals[cache_key]

/datum/wrapper/game_data
	var/key
	var/wrapper_for

// called after object is deserialized while in the serializer. Return a reference to the game data key is pointing to.
/datum/wrapper/game_data/proc/on_deserialize()

// called during serialization for custom behaviour. Assign var/key with something that can be used to restore the game data on_deserialize(). Return nothing.
/datum/wrapper/game_data/proc/on_serialize(var/datum/object)

/datum/wrapper/game_data/material/New()
	wrapper_for = /material

/datum/wrapper/game_data/material/on_serialize(var/mat_type)
	key = "[mat_type]"

/datum/wrapper/game_data/material/on_deserialize()
	return SSmaterials.get_material_datum(text2path(key))

/datum/wrapper/game_data/species/New()
	wrapper_for = /datum/species

/datum/wrapper/game_data/species/on_serialize(var/datum/species/object)
	key = object.name

/datum/wrapper/game_data/species/on_deserialize()
	return all_species[key]
