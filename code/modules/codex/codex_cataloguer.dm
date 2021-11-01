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
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

	var/glow_colour = COLOR_LIME    // Color of the glow effect when scanning.
	var/scan_speed_modifier = 1     // Multiplier for the base scan delay.
	var/scan_range = 3              // How many tiles away it can scan. Changing this also changes the box size.
	var/credit_sharing_range = 14   // If another person is within this radius, they will also be credited with a successful scan.
	var/tmp/points_stored = 0       // Amount of 'exploration points' this device holds.
	var/tmp/scanning = FALSE        // Set to true when scanning, to stop multiple scans.
	var/tmp/partial_scan_time = 0   // How much to make the next scan shorter.
	var/tmp/weakref/partial_scanned // Weakref of the thing that was last scanned if inturrupted. Used to allow for partial scans to be resumed.

/obj/item/cataloguer/Initialize(ml, material_key)
	. = ..()
	update_icon()

/obj/item/cataloguer/Destroy()
	stop_scan()
	. = ..()

/obj/item/cataloguer/on_update_icon()
	icon_state = get_world_inventory_state()
	cut_overlays()
	if(scanning && check_state_in_icon("[icon_state]-glow", icon))
		var/image/I = emissive_overlay(icon, "[icon_state]-glow")
		I.appearance_flags |= RESET_COLOR
		I.color = glow_colour
		add_overlay(I)

/obj/item/cataloguer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(scanning)
		to_chat(user, SPAN_WARNING("\The [src] is already scanning something."))
		return
	start_scan(target, user)

/obj/item/cataloguer/proc/stop_scan(var/interrupted = TRUE)
	if(!scanning)
		return
	scanning = FALSE
	if(interrupted)
		playsound(src, 'sound/machines/buzz-two.ogg', 50)
		// set the box color to red
	// fade the scan box out
	update_icon()

/obj/item/cataloguer/proc/start_scan(var/atom/target, var/mob/user)

	set waitfor = FALSE

	if(scanning)
		return

	var/datum/extension/scannable/scannable = get_extension(target, /datum/extension/scannable)
	if(!scannable?.is_scannable())
		to_chat(user, SPAN_WARNING("\The [src] can tell you nothing new about \the [target]."))
		return

	if(get_dist(target, user) > scan_range)
		to_chat(user, SPAN_WARNING("You are too far away from \the [target] to catalogue it. Get closer."))
		return

	var/scan_delay = scannable.scan_delay * scan_speed_modifier
	if(partial_scanned)
		if(partial_scanned.resolve() == target)
			scan_delay -= partial_scan_time
			to_chat(user, SPAN_NOTICE("Resuming previous scan."))
		else
			to_chat(user, SPAN_NOTICE("Scanning new target. Previous scan buffer cleared."))
	partial_scanned = weakref(target)

	scanning = TRUE
	update_icon()
	playsound(src, 'sound/machines/twobeep.ogg', 50)

	// Draw the box overlay and beam from the scanner

	if(!do_after(user, scan_delay, target, can_move = TRUE, max_distance = scan_range))
		stop_scan(interrupted = TRUE)
		return

	if(scannable?.is_scannable())
		var/datum/codex_entry/scannable/scan_result = scannable.scanned()
		if(scan_result)
			points_stored += scan_result.worth_points
			to_chat(user, SPAN_NOTICE("You complete the scan of \the [target], earning [scan_result.worth_points] Good Explorer Points."))
	stop_scan(interrupted = FALSE)
