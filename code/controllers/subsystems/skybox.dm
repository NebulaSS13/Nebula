
//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/skybox/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/background_icon = "dyable"
	var/use_stars = TRUE
	var/use_overmap_details = TRUE
	var/stars_icon = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"

	var/static/list/skybox_cache = list()

	var/static/mutable_appearance/normal_space
	var/static/list/dust_cache = list()
	var/static/list/speedspace_cache = list()
	var/static/list/mapedge_cache = list()

	var/static/list/phase_shift_by_x = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
	var/static/list/phase_shift_by_y = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)

/datum/controller/subsystem/skybox/PreInit()
	phase_shift_by_x = shuffle(phase_shift_by_x)
	phase_shift_by_y = shuffle(phase_shift_by_y)
	build_space_appearances()

/datum/controller/subsystem/skybox/Initialize()
	. = ..()
	if(isnull(background_color))
		background_color = RANDOM_RGB

/datum/controller/subsystem/skybox/Recover()
	background_color = SSskybox.background_color
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/build_space_appearances()
	//Create our 'normal' space appearance
	normal_space = new /mutable_appearance(/turf/space)
	normal_space.appearance_flags = TILE_BOUND|DEFAULT_APPEARANCE_FLAGS|KEEP_TOGETHER
	normal_space.plane = SKYBOX_PLANE
	normal_space.icon_state = "white"

	//Static
	for (var/i in 0 to 25)
		var/mutable_appearance/MA = new(normal_space)
		var/image/im = image('icons/turf/space_dust.dmi', "[i]")
		im.plane = DUST_PLANE
		im.alpha = 128
		im.blend_mode = BLEND_ADD

		MA.overlays = list(im)

		dust_cache["[i]"] = MA

	//Moving
	for (var/i in 0 to 14)
		// NORTH/SOUTH
		var/mutable_appearance/MA = new(normal_space)
		var/image/im = image('icons/turf/space_dust_transit.dmi', "speedspace_ns_[i]")
		im.plane = DUST_PLANE
		im.blend_mode = BLEND_ADD

		MA.overlays = list(im)

		speedspace_cache["NS_[i]"] = MA

		// EAST/WEST
		MA = new(normal_space)
		im = image('icons/turf/space_dust_transit.dmi', "speedspace_ew_[i]")
		im.plane = DUST_PLANE
		im.blend_mode = BLEND_ADD

		MA.overlays = list(im)

		speedspace_cache["EW_[i]"] = MA

		//Over-the-edge images
	for (var/dir in global.alldirs)
		var/mutable_appearance/MA = new(normal_space)
		var/matrix/M = matrix()
		var/horizontal = (dir & (WEST|EAST))
		var/vertical = (dir & (NORTH|SOUTH))
		M.Scale(horizontal ? 8 : 1, vertical ? 8 : 1)
		MA.transform = M
		MA.appearance_flags = KEEP_APART | TILE_BOUND
		MA.plane = SPACE_PLANE
		MA.layer = 0

		if(dir & NORTH)
			MA.pixel_y = 112
		else if(dir & SOUTH)
			MA.pixel_y = -112

		if(dir & EAST)
			MA.pixel_x = 112
		else if(dir & WEST)
			MA.pixel_x = -112

		mapedge_cache["[dir]"] = MA

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!skybox_cache[num2text(z)])
		skybox_cache[num2text(z)] = generate_skybox(z)
		var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
		if(istype(O))
			for(var/zlevel in O.map_z)
				skybox_cache["[zlevel]"] = skybox_cache[num2text(z)]
	return skybox_cache[num2text(z)]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/image/res = image(skybox_icon)
	res.appearance_flags |= KEEP_TOGETHER

	var/image/base = overlay_image(skybox_icon, background_icon, background_color, DEFAULT_APPEARANCE_FLAGS)

	if(use_stars)
		var/image/stars = overlay_image(stars_icon, star_state, flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR)
		base.overlays += stars

	res.overlays += base

	if(use_overmap_details)
		var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
		if(istype(O))
			var/image/overmap = image(skybox_icon)
			overmap.overlays += O.generate_skybox()
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags |= RESET_COLOR
			res.overlays += overmap

	for(var/datum/event/E in SSevent.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			res.overlays += E.get_skybox_image()

	return res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache[num2text(z)] = generate_skybox(z)

	for(var/client/C)
		C.update_skybox(1)

//Update skyboxes. Called by universes, for now.
/datum/controller/subsystem/skybox/proc/change_skybox(new_state, new_color, new_use_stars, new_use_overmap_details)
	var/need_rebuild = FALSE
	if(new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE

	if(new_color != background_color)
		background_color = new_color
		need_rebuild = TRUE

	if(new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE

	if(new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE

	if(need_rebuild)
		skybox_cache.Cut()

		for(var/client/C)
			C.update_skybox(1)
