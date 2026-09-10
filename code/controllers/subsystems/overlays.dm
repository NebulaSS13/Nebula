SUBSYSTEM_DEF(overlays)
	name = "Overlay"
	wait = 1
	priority = SS_PRIORITY_OVERLAY
	init_order = SS_INIT_OVERLAY
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/processing = list()

	var/idex = 1
	var/list/overlay_icon_state_caches = list()
	var/list/overlay_icon_cache = list()

	var/compiles = 0
	var/compiles_with_simple = 0
	var/compiles_with_groups = 0
	var/compiles_with_none = 0
	var/compiles_async = 0
	var/automangled = 0

	// If the overlay set currently being considered contains a manglable overlay.
	// This is only safe because SSoverlays can only ever consider one overlay list at a time with no interior sleeps. Professional on closed course, do not attempt.
	// Setting this to TRUE on a non-movable will explode.
	var/context_needs_automangle

/// How many items should we process before we check for yield? Increasing this increases efficiency, but also raises risk of overrun.
#define OVR_PUMP_RATIO 4
/// Initialize state required for OVR_MC_TRY_YIELD.
#define OVR_PUMP_INIT var/__yield

/// Check if we need to yield to the MC. This macro will sleep or break.
#define OVR_MC_TRY_YIELD if ((++__yield) >= OVR_PUMP_RATIO) { __yield = 0; if (no_mc_tick) { CHECK_TICK; } else if (MC_TICK_CHECK) { break; } }

/datum/controller/subsystem/overlays/stat_entry()
	var/sync = compiles - compiles_async
	var/ratio = compiles ? (sync / compiles) : 1
	var/list/entries = list(
		"Q: [processing.len - (idex - 1)]",
		"Type: { Any: [compiles] | Simple: [compiles_with_simple] | Grouped: [compiles_with_groups] | Empty: [compiles_with_none] | Mangled: [automangled] }",
		"Chrony: { Sync: [sync] | Async: [compiles_async] | SR: [round(ratio*100, 0.1)]% }",
		"Caches: { Icon: [overlay_icon_cache.len] | Text: [overlay_icon_state_caches.len] }"
	)
	..(entries.Join("\n\t"))

/datum/controller/subsystem/overlays/Initialize()
	Flush()
	. = ..()

/datum/controller/subsystem/overlays/Recover()
	overlay_icon_state_caches = SSoverlays.overlay_icon_state_caches
	overlay_icon_cache = SSoverlays.overlay_icon_cache
	processing = SSoverlays.processing

/datum/controller/subsystem/overlays/fire(resumed = FALSE, no_mc_tick = FALSE)
	OVR_PUMP_INIT

	var/list/processing = src.processing
	while(idex <= processing.len)
		var/atom/thing = processing[idex++]

		if(!QDELETED(thing) && thing.overlay_queued)	// Don't double-process if something already forced a compile.
			thing.compile_overlays()
			SSoverlays.compiles_async++

		OVR_MC_TRY_YIELD

	if (idex > 1)
		processing.Cut(1, idex)
		idex = 1

/datum/controller/subsystem/overlays/proc/Flush()
	if(processing.len)
		log_ss("overlays", "Flushing [processing.len] overlays.")
		fire(FALSE, TRUE)

/// Render the current set of overlays to the atom. If you're done adding overlays, you should probably call this to reduce visual pop-in. By default this will not recompile if the atom hasn't been marked as needing update.
/atom/proc/compile_overlays(force = FALSE)
	if (!overlay_queued && !force)
		return

	var/list/normals = simple_overlays
	var/alist/groups = grouped_overlays

	var/list/flattened_groups
	if (LAZYLEN(groups))
		flattened_groups = list()
		for (var/k,v in groups)
			flattened_groups += v

	if(flattened_groups && LAZYLEN(normals))
		overlays = normals + flattened_groups
		SSoverlays.compiles_with_simple++
		SSoverlays.compiles_with_groups++
	else if(LAZYLEN(normals))
		overlays = normals
		SSoverlays.compiles_with_simple++
	else if(flattened_groups)
		overlays = flattened_groups
		SSoverlays.compiles_with_groups++
	else
		overlays.Cut()
		SSoverlays.compiles_with_none++

	if (istype(src, /atom/movable) && (z_flags & ZMM_AUTOMANGLE))
		SSoverlays.automangled++

	SSoverlays.compiles++
	overlay_queued = FALSE

/atom/movable/compile_overlays()
	..()
	UPDATE_OO_IF_PRESENT

/turf/compile_overlays()
	..()
	if (above)
		update_above()

/proc/iconstate2appearance(icon, iconstate)
	var/static/image/stringbro = new()
	var/list/icon_states_cache = SSoverlays.overlay_icon_state_caches
	var/list/cached_icon = icon_states_cache[icon]
	if (cached_icon)
		var/cached_appearance = cached_icon["[iconstate]"]
		if (cached_appearance)
			return cached_appearance
	stringbro.icon = icon
	stringbro.icon_state = iconstate
	if (!cached_icon) //not using the macro to save an associated lookup
		cached_icon = list()
		icon_states_cache[icon] = cached_icon
	var/cached_appearance = stringbro.appearance
	cached_icon["[iconstate]"] = cached_appearance
	return cached_appearance

/proc/icon2appearance(icon)
	var/static/image/iconbro = new()
	var/list/icon_cache = SSoverlays.overlay_icon_cache
	. = icon_cache[icon]
	if (!.)
		iconbro.icon = icon
		. = iconbro.appearance
		icon_cache[icon] = .

#define APPEARANCEIFY(origin, target) \
	if (istext(origin)) { \
		target = iconstate2appearance(icon, origin); \
	} \
	else if (isicon(origin)) { \
		target = icon2appearance(origin); \
	} \
	else { \
		appearance_bro.appearance = origin; \
		if (!ispath(origin)) { \
			appearance_bro.dir = origin.dir; \
		} \
		target = appearance_bro.appearance; \
	}

// If the overlay has a planeset (e.g., emissive), mark for ZM mangle. This won't catch overlays on overlays, but the flag can just manually be set in that case.
#define ZM_AUTOMANGLE(target) if ((target):plane != FLOAT_PLANE) { SSoverlays.context_needs_automangle = TRUE; }

/// Convert a lone appearance-like or a list of appearance-likes into a lone appearance or list of appearances suitable for use in SSoverlays.
/atom/proc/build_appearance_list(atom/new_overlays)
	var/static/image/appearance_bro = new
	if (islist(new_overlays))
		var/list/overlays_list = new_overlays
		overlays_list.RemoveAll(null)
		for (var/i in 1 to length(overlays_list))
			var/image/cached_overlay = overlays_list[i]
			APPEARANCEIFY(cached_overlay, overlays_list[i])
		return overlays_list
	else
		APPEARANCEIFY(new_overlays, .)

// The same as the above, but with ZM_AUTOMANGLE.
/atom/movable/build_appearance_list(atom/new_overlays)
	if (z_flags & (ZMM_NO_AUTOMANGLE | ZMM_MANGLE_PLANES))
		return ..()	// If automangling is off (or this atom is forcing mangling), just use the original implementation.
	var/static/image/appearance_bro = new
	if (islist(new_overlays))
		var/list/overlays_list = new_overlays
		overlays_list.RemoveAll(null)
		for (var/i in 1 to length(overlays_list))
			var/image/cached_overlay = overlays_list[i]
			APPEARANCEIFY(cached_overlay, overlays_list[i])
			ZM_AUTOMANGLE(overlays_list[i])
		return overlays_list
	else
		APPEARANCEIFY(new_overlays, .)
		ZM_AUTOMANGLE(.)

#undef APPEARANCEIFY
#define NOT_QUEUED_ALREADY (!(overlay_queued))
#define QUEUE_FOR_COMPILE overlay_queued = TRUE; SSoverlays.processing += src;

/// Remove all simple overlays, or all overlays within the specified group.
/atom/proc/cut_overlays(group = null, now = FALSE)
	var/need_compile = FALSE

	if (group)
		var/alist/cached_grouped = grouped_overlays
		if (length(cached_grouped))
			cached_grouped -= group
			need_compile = TRUE
	else
		var/list/cached_simple = simple_overlays
		if (length(cached_simple))
			cached_simple.Cut()
			need_compile = TRUE

	if (need_compile)
		if (now)
			compile_overlays(TRUE)
		else if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE

/// Remove one or more overlays from simple overlays, or from the specified group. Returns TRUE if any overlays were removed.
/atom/proc/cut_overlay(list/overlays, group, now = FALSE)
	if(!overlays)
		return FALSE

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)

	var/list/cached_simple = simple_overlays
	var/alist/cached_grouped = grouped_overlays
	var/init_s_len = length(cached_simple)
	var/group_dirty = FALSE
	if (group)
		var/list/overlay_group = cached_grouped[group]
		if (islist(overlay_group))
			var/init_g_len = length(overlay_group)
			if (init_g_len)
				overlay_group -= overlays
			var/new_g_len = length(overlay_group)
			if (new_g_len != init_g_len)
				group_dirty = TRUE
			if (!new_g_len)
				cached_grouped -= group
		else
			if (overlay_group)
				if (islist(overlays))
					if (overlay_group in overlays)
						overlay_group = null
						group_dirty = TRUE
				else
					if (overlay_group == overlays)
						overlay_group = null
						group_dirty = TRUE
	else
		LAZYREMOVE(cached_simple, overlays)

	var/needs_compile = ((init_s_len != LAZYLEN(cached_simple)) || group_dirty)

	if (needs_compile)
		if (now && !istype(src, /atom/movable))	// If we're a movable, the movable level override of this proc needs to handle this.
			compile_overlays(TRUE)
		else if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE

		return TRUE
	return FALSE

// This one also gets to be done sanely because it shouldn't be too hot.
/atom/movable/cut_overlay(list/overlays, group, now = FALSE)
	. = ..()
	// If we removed an automangle-eligible overlay and have automangle enabled, reevaluate automangling.
	if (!SSoverlays.context_needs_automangle || !(z_flags & ZMM_AUTOMANGLE))
		return

	var/list/cached_simple = simple_overlays
	var/list/cached_grouped = grouped_overlays

	// If we cut some non-priority overlays but some are still left, we need to scan for AUTOMANGLE_NRML.
	if (!group && LAZYLEN(cached_simple))
		var/found = FALSE
		for (var/v in cached_simple)
			var/image/I = v
			if (I.plane != FLOAT_PLANE)
				found = TRUE
				break

		if (!found)
			z_flags &= ~ZMM_AUTOMANGLE_NRML

	// Likewise, but now for groups and AUTOMANGLE_GRP.
	else if (group && LAZYLEN(cached_grouped))
		var/found = FALSE
		top:	// Did you know that according to BYOND this colon is optional (and technically invalid), but the lang server requires it?
			for (var/k,v in grouped_overlays)
				if (islist(v))
					for (var/kk in v)
						var/image/I = kk
						if (I.plane != FLOAT_PLANE)
							found = TRUE
							break top
				else
					var/image/I = v
					if (I.plane != FLOAT_PLANE)
						found = TRUE
						break top

		if (!found)
			z_flags &= ~ZMM_AUTOMANGLE_GRP

	// None left, just unset the bit.
	else
		z_flags &= ~(group ? ~ZMM_AUTOMANGLE_GRP : ~ZMM_AUTOMANGLE_NRML)

	// for ordering reasons (compile_overlays triggers a ZM update), we need to do this up here -- as-is ZM does the update asynchronously, but better to avoid future surprises
	if (now && .)
		compile_overlays(TRUE)

/// Add one or more overlays to simple overlays, or to the specified group.
/atom/proc/add_overlay(list/overlays, group = null, now = FALSE)
	if(!overlays)
		return

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)

	if (SSoverlays.context_needs_automangle)	// this will only ever be true on movables
		src.z_flags |= group ? ZMM_AUTOMANGLE_GRP : ZMM_AUTOMANGLE_NRML

	if (!overlays || (islist(overlays) && !overlays.len))
		// No point trying to compile if we don't have any overlays.
		return

	if (group)
		var/alist/cached_grouped = grouped_overlays
		if (cached_grouped)
			var/subgroup = cached_grouped[group]
			if (islist(subgroup))
				subgroup += overlays
			else if (subgroup)
				cached_grouped[group] = list(subgroup) + overlays
			else
				cached_grouped[group] = overlays
		else
			grouped_overlays = alist((group) = overlays)
	else
		LAZYADD(simple_overlays, overlays)

	if (now)
		compile_overlays(TRUE)
	else if(NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/// Replace all simple overlays (or the specified group) with zero or more overlays. This is equivalent to `cut_overlays() + add_overlays()`, but has less overhead.
/atom/proc/set_overlays(list/overlays, group = null, now = FALSE)
	if (!overlays)
		cut_overlays(group, now)
		return

	SSoverlays.context_needs_automangle = FALSE
	overlays = build_appearance_list(overlays)

	if (SSoverlays.context_needs_automangle)	// this will only ever be true on movables
		src.z_flags |= group ? ZMM_AUTOMANGLE_GRP : ZMM_AUTOMANGLE_NRML
	else if (istype(src, /atom/movable))
		src.z_flags &= ~(group ? ZMM_AUTOMANGLE_GRP : ZMM_AUTOMANGLE_NRML)

	if (group)
		var/alist/cached_grouped = grouped_overlays
		if (cached_grouped)
			cached_grouped[group] = overlays
		else if (overlays)
			grouped_overlays = alist((group) = overlays)
		else
			grouped_overlays -= group
	else
		if (simple_overlays)	// this is not LAZYCLEARLIST to avoid deallocating the list when we're about to use it
			simple_overlays.Cut()
		if (overlays)
			LAZYADD(simple_overlays, overlays)
		if (!length(simple_overlays))
			simple_overlays = null

	if (now)
		compile_overlays(TRUE)
	else if (NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/// Copy overlays from another atom. If `also_grouped` is set, also copy grouped overlays. This is synchronous by default.
/atom/proc/copy_overlays(atom/other, also_grouped = FALSE, now = TRUE)
	ASSERT(other != null)

	z_flags |= other.z_flags & ZMM_AUTOMANGLE

	if (other.simple_overlays)
		LAZYINITLIST(simple_overlays)
		simple_overlays += other.simple_overlays

	if (also_grouped && other.grouped_overlays)
		LAZYINITALIST(grouped_overlays)
		for (var/k,v in other.grouped_overlays)
			var/local_v = grouped_overlays[k]
			if (islist(local_v))
				grouped_overlays[k] += v	// valid for both non-list and list entries
			else if (local_v)
				grouped_overlays[k] = list(local_v) + v
			else if (islist(v))
				grouped_overlays[k] = v:Copy()
			else
				grouped_overlays[k] = v

	if (now)
		compile_overlays(TRUE)
	else if(NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/// Copy overlays from another atom, overwriting our overlays. This is synchronous by default.
/atom/proc/replace_overlays(atom/other, also_grouped = FALSE, now = TRUE, exclude_groups = null)
	z_flags |= other.z_flags & ZMM_AUTOMANGLE
	var/remove_flags = 0

	simple_overlays = other.simple_overlays
	if (!length(simple_overlays))
		remove_flags |= ZMM_AUTOMANGLE_NRML

	if (also_grouped)
		if (other.grouped_overlays)
			var/alist/new_grouped = other.grouped_overlays.Copy()
			if (exclude_groups)
				new_grouped -= exclude_groups
			for (var/k,v in new_grouped)
				if (islist(v))
					new_grouped[k] = v:Copy()
		else
			grouped_overlays = null
			remove_flags |= ZMM_AUTOMANGLE_GRP

	z_flags &= ~remove_flags

	if (now)
		compile_overlays(TRUE)
	else if(NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

#undef NOT_QUEUED_ALREADY
#undef QUEUE_FOR_COMPILE

//TODO: Better solution for these?
/image/proc/add_overlay(x)
	overlays += x

/image/proc/cut_overlay(x)
	overlays -= x

/image/proc/cut_overlays(x)
	overlays.Cut()

/atom
	var/tmp/list/simple_overlays	//! Our traditional grab-bag of overlays, comparable to normal `overlays` operations. Use SSoverlay functions to manipulate.
	var/tmp/alist/grouped_overlays	//! Named groups of overlays, comparable to the old priority overlays. Values can be a single entry or a flat list. Lists of lists are forbidden.
	var/tmp/overlay_queued
