#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

/atom
	var/light_power = 1 // Intensity of the light.
	var/light_range = 0 // Range in tiles of the light.
	var/light_color     // Hexadecimal RGB string representing the colour of the light.
	var/light_wedge     // The angle that the light's emission should be restricted to. null for omnidirectional.
	// These two vars let you override the default light offset detection (pixel_x/y).
	//  Useful for objects like light fixtures that aren't visually in the middle of the turf, but aren't offset either.
	var/light_offset_x
	var/light_offset_y
	/// An override for cases where the light is not facing the same direction as the object.
	var/light_dir

	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!
	var/tmp/list/light_source_multi       // Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.
	var/tmp/datum/light_source/light_source_solo    // Same as above - this is a shortcut to avoid allocating the above list if we can

// Nonsensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999

// The proc you should always use to set the light of this atom.
/atom/proc/set_light(l_range, l_power, l_color = NONSENSICAL_VALUE, angle = NONSENSICAL_VALUE, no_update = FALSE)
	if(l_range > 0 && l_range < MINIMUM_USEFUL_LIGHT_RANGE)
		l_range = MINIMUM_USEFUL_LIGHT_RANGE	//Brings the range up to 1.4
	if (l_power != null)
		light_power = l_power

	if (l_range != null)
		light_range = l_range

	if (l_color != NONSENSICAL_VALUE)
		light_color = l_color

	if (angle != NONSENSICAL_VALUE)
		light_wedge = angle

	if (no_update)
		return

	update_light()

#undef NONSENSICAL_VALUE

// Will update the light (duh).
// Creates or destroys it if needed, makes it update values, makes sure it's got the correct source turf...
/atom/proc/update_light()
	if (QDELING(src))
		return

	if (!light_power || !light_range) // We won't emit light anyways, destroy the light source.
		QDEL_NULL(light)
	else
		if (!istype(loc, /atom/movable)) // We choose what atom should be the top atom of the light here.
			. = src
		else
			. = loc

		if (light)
			light.update(.)
		else
			light = new /datum/light_source(src, .)


// Should always be used to change the opacity of an atom.
// It notifies (potentially) affected light sources so they can update (if needed).
/atom/set_opacity(var/new_opacity)
	. = ..()
	if (!.)
		return

	opacity = new_opacity
	var/turf/T = loc
	if (!isturf(T))
		return

	if (new_opacity == TRUE)
		T.has_opaque_atom = TRUE
		T.reconsider_lights()
#ifdef AO_USE_LIGHTING_OPACITY
		T.regenerate_ao()
#endif
	else
		var/old_has_opaque_atom = T.has_opaque_atom
		T.recalc_atom_opacity()
		if (old_has_opaque_atom != T.has_opaque_atom)
			T.reconsider_lights()

/atom/movable/forceMove()
	. = ..()

	if (light_source_solo)
		light_source_solo.source_atom.update_light()
	else if (light_source_multi)
		var/datum/light_source/L
		var/thing
		for (thing in light_source_multi)
			L = thing
			L.source_atom.update_light()
