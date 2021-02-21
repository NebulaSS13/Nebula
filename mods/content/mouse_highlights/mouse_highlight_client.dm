
/client
	var/datum/callback/mouseover_callback   // Cached callback, see /client/New()
	var/obj/mouseover_highlight_dummy       // Dummy atom to hold the appearance of our highlighted atom, see comments in /client/proc/refresh_mouseover_highlight.
	var/weakref/current_highlight_atom      // Current weakref to highlighted atom, used for checking if we're mousing over the same atom repeatedly.
	var/image/current_highlight             // Current dummy image holding our highlight.

	var/mouseover_refresh_timer             // Holds an ID to the timer used to update the mouseover highlight.
	var/last_mouseover_params               // Stores mouse/keyboard params as of last mouseover, to check for shift being held. 
	var/last_mouseover_highlight_time       // Stores last world.time we mouseover'd, to prevent it happening more than once per world.tick_lag.

/client/New()
	// Cache our callback as we will potentially be using it (10 / ticklag) times per second,
	mouseover_callback = CALLBACK(src, .proc/refresh_mouseover_highlight_timer)
	. = ..()

// This proc iterates constantly whenever something is being mouseover'd, so that it
// can update appearance to match any changes in the base icon. I considered using
// some kind of hook in update_icon() and set_dir() but this seemed much more robust.
/client/proc/refresh_mouseover_highlight_timer()
	if(!current_highlight_atom || !refresh_mouseover_highlight(current_highlight_atom?.resolve(), last_mouseover_params))
		// If refresh_mouseover_highlight() returns false we need to end our iteration and kill the highlight.
		if(current_highlight)
			images -= current_highlight
			qdel(current_highlight)
			current_highlight = null
		current_highlight_atom = null
		deltimer(mouseover_refresh_timer)
		mouseover_refresh_timer = null

// Main body of work happens in this proc.
/client/proc/refresh_mouseover_highlight(object, params, check_adjacency = FALSE)

	// Verify if we should be showing a highlight at all.
	if(!istype(object, /atom/movable) || (check_adjacency && !mob.Adjacent(object)))
		return FALSE
	var/list/modifiers = params2list(params)
	var/highlight_pref = get_preference_value(/datum/client_preference/show_mouseover_highlights)
	if(highlight_pref != GLOB.PREF_SHOW && (highlight_pref != GLOB.PREF_SHOW_HOLD_SHIFT || !modifiers["shift"]))
		return FALSE
	var/atom/movable/AM = object
	if(!AM.show_client_mouseover_highlight || get_dist(mob, object) > 1)
		return FALSE

	// Generate our dummy objects if they got nulled/discarded.
	if(!current_highlight)
		current_highlight = new /image
		current_highlight.appearance_flags |= (KEEP_TOGETHER|RESET_COLOR)
		images += current_highlight
	if(!mouseover_highlight_dummy)
		mouseover_highlight_dummy = new

	// Copy over the atom's appearance to our holder object.
	// client.images does not respect pixel offsets for images, but vis_contents does,
	// and images have vis_contents - so we throw a null image into client.images, then
	// throw a holder object with the appearance of the mouse-overed atom into its vis_contents. 
	mouseover_highlight_dummy.appearance =        AM
	mouseover_highlight_dummy.dir =               AM.dir
	mouseover_highlight_dummy.transform =         AM.transform

	// For some reason you need to explicitly zero the pixel offsets of the holder object
	// or anything with a pixel offset will not line up with the highlight. Thanks DM.
	mouseover_highlight_dummy.pixel_x =           0
	mouseover_highlight_dummy.pixel_y =           0
	mouseover_highlight_dummy.pixel_w =           0
	mouseover_highlight_dummy.pixel_z =           0

	// Replane to be over the UI, make sure it can't block clicks, and set its outline.
	mouseover_highlight_dummy.mouse_opacity =     0
	mouseover_highlight_dummy.layer =             HUD_PLANE
	mouseover_highlight_dummy.plane =             HUD_ABOVE_ITEM_LAYER
	mouseover_highlight_dummy.alpha =             prefs?.UI_mouseover_alpha || 255
	mouseover_highlight_dummy.appearance_flags |= (KEEP_TOGETHER|RESET_COLOR)
	mouseover_highlight_dummy.filters =           filter(type="drop_shadow", color = (prefs?.UI_mouseover_color || COLOR_AMBER) + "F0", size = 1, offset = 1, x = 0, y = 0)

	// Replanes the overlays to avoid explicit plane/layer setting (such as 
	// computer overlays) interfering with the ordering of the highlight.
	if(length(mouseover_highlight_dummy.overlays))
		var/list/replaned_overlays
		for(var/thing in mouseover_highlight_dummy.overlays)
			var/mutable_appearance/MA = new(thing)
			MA.plane = FLOAT_PLANE
			MA.layer = FLOAT_LAYER
			LAZYADD(replaned_overlays, MA)
		mouseover_highlight_dummy.overlays = replaned_overlays
	if(length(mouseover_highlight_dummy.underlays))
		var/list/replaned_underlays
		for(var/thing in mouseover_highlight_dummy.underlays)
			var/mutable_appearance/MA = new(thing)
			MA.plane = FLOAT_PLANE
			MA.layer = FLOAT_LAYER
			LAZYADD(replaned_underlays, MA)
		mouseover_highlight_dummy.underlays = replaned_underlays

	// Finally update our highlight's vis_contents and location .
	current_highlight.vis_contents.Cut()
	current_highlight.vis_contents += mouseover_highlight_dummy
	current_highlight.loc = object
	current_highlight_atom = weakref(AM)

	// Keep track our params so the update ticker knows if we were holding shift or not.
	last_mouseover_params = params

	return TRUE

// Simple hooks to catch the client mouseover/mouseleave events and start our highlight timer as needed.
/client/MouseEntered(object,location,control,params)
	if(world.time > last_mouseover_highlight_time && mouseover_callback && refresh_mouseover_highlight(object, params, check_adjacency = TRUE) && !mouseover_refresh_timer)
		last_mouseover_highlight_time = world.time
		mouseover_refresh_timer = addtimer(mouseover_callback, 1, (TIMER_UNIQUE | TIMER_LOOP | TIMER_STOPPABLE))
	. = ..()
/client/MouseExited(object, location, control, params)
	if(current_highlight_atom?.resolve() == object)
		current_highlight_atom = null
		refresh_mouseover_highlight_timer()
	. = ..()
