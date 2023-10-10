/obj/screen/scan_radius
	name = null
	plane = HUD_PLANE
	layer = UNDER_HUD_LAYER
	mouse_opacity = 0
	screen_loc = "CENTER,CENTER"
	icon = 'icons/screen/scanner.dmi'
	icon_state = "blank"
	alpha = 180
	var/scan_range
	var/image/holder_image

/obj/screen/scan_radius/proc/set_radius(var/new_range)
	if(new_range != scan_range)
		scan_range = max(1, new_range)
		update_icon()

/obj/screen/scan_radius/proc/fade_out(var/mob/user, var/fade_time)
	set waitfor = FALSE
	animate(src, alpha = 0, time = fade_time)
	if(fade_time > 0)
		sleep(fade_time)
	if(user?.client && holder_image)
		user.client.images -= holder_image

/obj/screen/scan_radius/Destroy()
	if(holder_image)
		holder_image.vis_contents.Cut()
		QDEL_NULL(holder_image)
	return ..()

/obj/screen/scan_radius/on_update_icon()
	cut_overlays()
	if(scan_range <= 1)
		add_overlay("single")
	else
		var/pixel_bound = (world.icon_size * scan_range)

		var/image/I = image(icon, "bottomleft")
		I.pixel_x = -(pixel_bound)
		I.pixel_y = -(pixel_bound)
		add_overlay(I)

		I = image(icon, "bottomright")
		I.pixel_x = pixel_bound
		I.pixel_y = -(pixel_bound)
		add_overlay(I)

		I = image(icon, "topleft")
		I.pixel_x = -(pixel_bound)
		I.pixel_y = pixel_bound
		add_overlay(I)

		I = image(icon, "topright")
		I.pixel_x = pixel_bound
		I.pixel_y = pixel_bound
		add_overlay(I)

		var/offset_scan_range = scan_range-1
		for(var/i = -(offset_scan_range) to offset_scan_range)
			I = image(icon, "left")
			I.pixel_x = -(pixel_bound)
			I.pixel_y = world.icon_size * i
			add_overlay(I)

			I = image(icon, "right")
			I.pixel_x = pixel_bound
			I.pixel_y = world.icon_size * i
			add_overlay(I)

			I = image(icon, "bottom")
			I.pixel_x = world.icon_size * i
			I.pixel_y = -(pixel_bound)
			add_overlay(I)

			I = image(icon, "top")
			I.pixel_x = world.icon_size * i
			I.pixel_y = pixel_bound
			add_overlay(I)

	compile_overlays()

/obj/item/cataloguer
	name = "cataloguer"
	desc = "A hand-held device used for compiling information about an object by scanning it, and then uploading it to the local codex. Alt-click to highlight scannable objects around you."
	color = COLOR_GUNMETAL
	icon = 'icons/obj/items/device/cataloguer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'materials':2, 'programming':3,'magnets':3}"
	force = 0
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)

	/// Color of the glow effect when scanning.
	var/glow_colour = COLOR_LIME
	/// Multiplier for the base scan delay.
	var/scan_speed_modifier = 1
	/// How many tiles away it can scan. Changing this also changes the box size.
	var/scan_range = 3
	/// If another person is within this radius, they will also be credited with a successful scan.
	var/credit_sharing_range = 14
	/// How much to make the next scan shorter.
	var/tmp/partial_scan_time = 0
	/// Weakref of the thing that was last scanned if inturrupted. Used to allow for partial scans to be resumed.
	var/tmp/weakref/partial_scanned
	/// Set to a user mob when scanning, to stop multiple scans.
	var/weakref/scanning
	/// Dummy object for holding the scanning effect.
	var/obj/screen/scan_radius/scan_radius_overlay
	/// Holder for the currently scanning beam effect.
	var/datum/beam/scan_beam
	/// Currently loaded survey disk for storing Good Boy Points.
	var/obj/item/disk/survey/loaded_disk

/obj/item/cataloguer/Initialize(ml, material_key)
	. = ..()
	update_icon()
	set_scan_radius(scan_range, TRUE)

/obj/item/cataloguer/Destroy()
	QDEL_NULL(loaded_disk)
	QDEL_NULL(scan_beam)
	stop_scan()
	scanning = null
	QDEL_NULL(scan_radius_overlay)
	return ..()

/obj/item/cataloguer/physically_destroyed(skip_qdel)
	if(loaded_disk)
		loaded_disk.dropInto(loc)
		loaded_disk = null
	return ..()

/obj/item/cataloguer/mapped/Initialize(ml, material_key)
	. = ..()
	loaded_disk = new(src)

/obj/item/cataloguer/proc/set_scan_radius(var/new_range, var/forced)
	if(!forced && new_range == scan_range)
		return FALSE

	scan_range = new_range
	QDEL_NULL(scan_radius_overlay)
	scan_radius_overlay = new
	scan_radius_overlay.color = glow_colour
	scan_radius_overlay.set_radius(new_range)
	return TRUE

/obj/item/cataloguer/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(scanning && check_state_in_icon("[icon_state]_glow", icon))
		var/image/I
		if(plane == HUD_PLANE)
			I = image(icon, "[icon_state]_glow")
		else
			I = emissive_overlay(icon, "[icon_state]_glow")
		I.appearance_flags |= RESET_COLOR
		I.color = glow_colour
		add_overlay(I)

/obj/item/cataloguer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(scanning)
		to_chat(user, SPAN_WARNING("\The [src] is already scanning something."))
		return
	start_scan(target, user)

/obj/item/cataloguer/attack_self(mob/user)
	if(loaded_disk)
		to_chat(user, SPAN_NOTICE("You pop \the [loaded_disk] out of \the [src]."))
		loaded_disk.dropInto(loc)
		user.put_in_hands(loaded_disk)
		loaded_disk = null
		playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
		return TRUE
	return ..()

/obj/item/cataloguer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/disk/survey))
		if(loaded_disk)
			to_chat(user, SPAN_WARNING("\The [src] already has a disk loaded."))
		else if(user.try_unequip(W, src))
			loaded_disk = W
			playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]."))
		return TRUE
	return ..()

/obj/item/cataloguer/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(loaded_disk)
		to_chat(user, "It has \a [loaded_disk] slotted into the storage port. The display indicates it currently holds [loaded_disk.data] Good Explorer Point\s.")

/obj/item/cataloguer/proc/stop_scan(var/interrupted = TRUE, var/mob/user, var/fade_out = 0)

	if(!scanning)
		return

	if(scan_beam)
		QDEL_NULL(scan_beam)

	var/atom/movable/thing = partial_scanned?.resolve()
	if(istype(thing))
		thing.remove_filter("cataloguer_glow")

	if(interrupted)
		playsound(src, 'sound/machines/buzz-two.ogg', 50)
		scan_radius_overlay.color = COLOR_RED

	scan_radius_overlay.fade_out(user, fade_out)
	scanning = null
	update_icon()

/obj/item/cataloguer/proc/start_scan(var/atom/target, var/mob/user)

	set waitfor = FALSE

	if(scanning)
		return

	if(!loaded_disk)
		playsound(user.loc, 'sound/weapons/empty.ogg', 60, 1)
		to_chat(user, SPAN_WARNING("\The [src] has no disk loaded and cannot store scan results."))
		return

	var/datum/extension/scannable/scannable = get_extension(target, /datum/extension/scannable)
	if(!scannable?.is_scannable())
		to_chat(user, SPAN_WARNING("\The [src] can tell you nothing new about \the [target]."))
		return

	if(get_dist(target, user) > scan_range)
		to_chat(user, SPAN_WARNING("You are too far away from \the [target] to catalogue it. Get closer."))
		return

	var/scan_delay = scannable.scan_delay * scan_speed_modifier
	if(partial_scanned && partial_scanned.resolve() == target)
		scan_delay -= partial_scan_time
		to_chat(user, SPAN_NOTICE("Resuming previous scan."))
	else
		to_chat(user, SPAN_NOTICE("Scanning new target. Previous scan buffer cleared."))
		partial_scanned = weakref(target)
		partial_scan_time = 0

	scanning = weakref(user)

	update_icon()

	playsound(src, 'sound/machines/twobeep.ogg', 50)

	// Reset visual properties of the overlay.
	scan_radius_overlay.alpha = 0
	scan_radius_overlay.color = glow_colour

	// Add the scan overlay to the client.
	if(scan_radius_overlay.holder_image)
		scan_radius_overlay.holder_image.vis_contents.Cut()
	scan_radius_overlay.holder_image = new
	scan_radius_overlay.holder_image.vis_contents += scan_radius_overlay
	scan_radius_overlay.holder_image.loc = target

	// Center the scan range overlay on the atom's actual turf.
	scan_radius_overlay.holder_image.pixel_x = -(target.pixel_x)
	scan_radius_overlay.holder_image.pixel_y = -(target.pixel_y)

	// Now make it visible.
	if(user.client)
		user.client.images += scan_radius_overlay.holder_image
	animate(scan_radius_overlay, alpha = initial(scan_radius_overlay.alpha), time = 5)

	// Draw glow filter over target.
	if(ismovable(target))
		var/atom/movable/thing = target
		thing.add_filter("cataloguer_glow", 1, list("drop_shadow", color = glow_colour, size = 4, offset = 1, x = 0, y = 0))

	scan_beam = user.Beam(target, "scanner", time = scan_delay, maxdistance = scan_range+1, beam_color = glow_colour)

	var/started_scan = world.time
	var/interrupted = !do_after(user, scan_delay, target, can_move = TRUE, max_distance = scan_range, check_in_view = TRUE) || !loaded_disk
	partial_scan_time += world.time - started_scan

	stop_scan(interrupted, user, fade_out = 5)
	if(!interrupted && scannable?.is_scannable())
		playsound(src, 'sound/machines/ping.ogg', 50)
		var/datum/codex_entry/scannable/scan_result = scannable.scanned()
		if(scan_result)
			loaded_disk.data += scan_result.worth_points
			to_chat(user, SPAN_NOTICE("You complete the scan of \the [target], earning [scan_result.worth_points] Good Explorer Point\s."))
