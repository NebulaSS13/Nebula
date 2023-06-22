/// Whether to draw rings on the planet's skybox image, and aknowledge anywhere else that it has rings.
/obj/effect/overmap/visitable/sector/planetoid/proc/has_rings()
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_id[planetoid_id]
	return PD.has_rings

/// Returns the name of the type of ring overlay to use for the planetary rings.
/// Basically, the icon_state for the planetoid's rings
/obj/effect/overmap/visitable/sector/planetoid/proc/get_ring_type_name()
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_id[planetoid_id]
	return PD.ring_type_name

/// Returns the color for the ring overlay
/obj/effect/overmap/visitable/sector/planetoid/proc/get_ring_color()
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_id[planetoid_id]
	return PD.ring_color

/// Get the primary surface color used for the skybox image
/obj/effect/overmap/visitable/sector/planetoid/proc/get_surface_color()
	return surface_color

/obj/effect/overmap/visitable/sector/planetoid/proc/has_atmosphere()
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_id[planetoid_id]
	var/datum/level_data/LD     = SSmapping.levels_by_id[PD.surface_level_id]
	return !isnull(LD.exterior_atmosphere)

/obj/effect/overmap/visitable/sector/planetoid/proc/get_atmosphere_color()
	var/list/colors = list()
	for(var/lvl in map_z)
		var/datum/level_data/level_data = SSmapping.levels_by_z[lvl]
		///#TODO: Check if the z-level is visible from space
		for(var/g in level_data.exterior_atmosphere?.gas)
			var/decl/material/mat = GET_DECL(g)
			colors += mat.color
	if(length(colors))
		return MixColors(colors)

/// Get cached skybox background image.
/obj/effect/overmap/visitable/sector/planetoid/get_skybox_representation()
	if(!skybox_image)
		generate_skybox_image()
	return skybox_image

/// Returns the image for the planetary surface of the skybox background image.
/obj/effect/overmap/visitable/sector/planetoid/proc/get_skybox_primary_surface()
	return overlay_image(skybox_icon, "base", get_surface_color())

/// Returns the image for the secondary planetary feature of the surface of the
/// skybox background image. Usually is the color of the oceans on the surface.
/obj/effect/overmap/visitable/sector/planetoid/proc/get_skybox_secondary_surface()
	if(!water_color)
		return
	var/image/secondary = image(skybox_icon, "water")
	secondary.color = water_color
	secondary.appearance_flags = PIXEL_SCALE
	secondary.transform = secondary.transform.Turn(rand(0,360))
	return secondary

/// Generates the raw base/surface of the planetoid skybox image.
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_planetoid_surface()
	var/image/surface   = image(skybox_icon, "")
	var/image/primary   = get_skybox_primary_surface()
	var/image/secondary = get_skybox_secondary_surface()
	surface.add_overlay(primary)
	if(secondary)
		surface.add_overlay(secondary)

	//Slap on anything added by themes to the surface
	var/datum/planetoid_data/PD = SSmapping.planetoid_data_by_id[planetoid_id]
	for(var/datum/exoplanet_theme/TH in PD.themes)
		var/img = TH.get_planet_image_extra(PD)
		if(img)
			surface.add_overlay(img)
	return surface

/// Generates the cloud cover over the planetoid.
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_planetoid_clouds()
	if(!has_atmosphere())
		return
	var/image/clouds = overlay_image(skybox_icon, "weak_clouds", get_atmosphere_color() || COLOR_WHITE)
	if(water_color) //#FIXME: This really should check if there's actually some liquid to make clouds from or something, instead of checking if there's a water overlay
		clouds.overlays += image(skybox_icon, "clouds")
	return clouds

/// Generates the halo underlay around the planetoid if there's any.
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_planetoid_halo()
	if(!has_atmosphere())
		return
	return image(skybox_icon, "atmoring")

/// Generates the planetoid's shadow and rimlight overlays
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_planetoid_shading()
	var/list/shading_overlays = list()
	var/image/shadow = image(skybox_icon, "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	shading_overlays += shadow
	shading_overlays += image(skybox_icon, "lightrim")
	return shading_overlays

/// Generate the planetoid's rings overlay if it has rings
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_planetoid_rings()
	if(!has_rings())
		return
	var/image/rings = overlay_image('icons/skybox/planet_rings.dmi', get_ring_type_name(), get_ring_color())
	//Need to offset the ring overlay because it's 512x512px, and the planet images are 256x256px
	rings.pixel_x = -128
	rings.pixel_y = -128
	return rings

/// Generates the skybox background displayed when a ship or viewer is in a sector above the planetoid
/obj/effect/overmap/visitable/sector/planetoid/proc/generate_skybox_image()
	//Everything is done in a separate proc for each layers, to allow for overriding
	// for a variety of planetoids
	skybox_image = generate_skybox_planetoid_surface()
	ASSERT(skybox_image)
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = RESET_COLOR

	skybox_image.underlays += generate_skybox_planetoid_halo()
	skybox_image.add_overlay(generate_skybox_planetoid_clouds())
	skybox_image.add_overlay(generate_skybox_planetoid_shading())
	skybox_image.add_overlay(generate_skybox_planetoid_rings())
