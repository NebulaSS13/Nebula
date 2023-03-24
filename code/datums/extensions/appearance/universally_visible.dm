var/global/list/universally_visible_atom_extensions = list()

/mob/Login()
	..()
	if(client && length(global.universally_visible_atom_extensions))
		for(var/datum/extension/universally_visible/univis in global.universally_visible_atom_extensions)
			univis.show_to(client)

/mob/Move()
	. = ..()
	if(. && client && length(global.universally_visible_atom_extensions))
		for(var/datum/extension/universally_visible/univis in global.universally_visible_atom_extensions)
			univis.show_to(client)

/mob/forceMove()
	. = ..()
	if(. && client && length(global.universally_visible_atom_extensions))
		for(var/datum/extension/universally_visible/univis in global.universally_visible_atom_extensions)
			univis.show_to(client)

/datum/extension/universally_visible
	expected_type = /atom/movable
	base_type = /datum/extension/universally_visible
	var/list/last_shown_image = list()

/datum/extension/universally_visible/New(datum/holder)
	. = ..()
	global.universally_visible_atom_extensions += src

/datum/extension/universally_visible/Destroy()
	global.universally_visible_atom_extensions -= src
	return ..()

/datum/extension/universally_visible/proc/refresh()
	for(var/client/C)
		show_to(C)

/datum/extension/universally_visible/proc/show_to(var/client/C)

	if(!ismob(C?.mob) || QDELETED(C.mob))
		return

	var/weakref/mob_ref = weakref(C.mob)
	var/image/I = last_shown_image[mob_ref]
	if(I)
		C.images -= I

	var/atom/movable/visible_atom = holder
	var/turf/mob_turf = get_turf(C.mob)
	var/turf/atom_turf = visible_atom.loc
	if(!istype(atom_turf) || mob_turf.z != atom_turf.z || (visible_atom in view(max(C.last_view_x_dim, C.last_view_y_dim), mob_turf)))
		return

	I = image(null)
	I.appearance = visible_atom
	I.mouse_opacity = 0
	I.pixel_x = world.icon_size * (atom_turf.x - mob_turf.x) + visible_atom.pixel_x
	I.pixel_y = world.icon_size * (atom_turf.y - mob_turf.y) + visible_atom.pixel_y
	I.loc = get_turf(mob_turf)
	C.images += I
	last_shown_image[mob_ref] = I
