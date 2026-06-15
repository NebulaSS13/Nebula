/obj/mimic_master
	appearance_flags = PLANE_MASTER | PASS_MOUSE
	screen_loc = "1,1"

/obj/mimic_master/slice
	var/slot
	var/root_plane = ZMIMIC_MAXIMUM_PLANE
	var/stack_size = OPENTURF_PLANES_PER_DEPTH
	var/slice_kind
	var/slice_prefix = "slice"
	var/assign_target = FALSE

/obj/mimic_master/slice/Initialize(mapload, depth)
	..(mapload)
	plane = root_plane - ZM_DEPTH_TO_OFFSET_RAW(depth, stack_size) + slot
	ASSERT(slice_kind != null)
	ASSERT(slot != null)
	name = "[slice_prefix] [slice_kind] on [depth] slot [slot] ([plane])"
	if (assign_target)	// This is used for the basic and blur slices.
		render_target = ZM_SLICE(slice_kind, depth)

/obj/mimic_master/slice/virtual
	root_plane = ZM_BASEMENT_MAX_PLANE
	stack_size = ZM_BASEMENT_PLANES_PER_DEPTH
	slice_prefix = "virtual slice"

// -- Slices --

/// Holding buffer for standard ZM render.
/obj/mimic_master/slice/basic
	appearance_flags = PLANE_MASTER | PASS_MOUSE
	slot = ZM_SLICE_SLOT_ROOT
	slice_kind = ZM_SLICE_TY_BASIC
	assign_target = TRUE

/// Contains shadower objects.
/obj/mimic_master/slice/shadower_master
	blend_mode = BLEND_MULTIPLY
	slot = ZM_SLICE_SLOT_LIGHTING
	slice_kind = ZM_SLICE_TY_LIGHTING

/obj/mimic_master/slice/shadower_master/Initialize(mapload, depth)
	..()
	filters += filter(type = "alpha", render_source = ZM_SLICE_VIRTUAL(ZM_SLICE_TY_ZSUM, depth))

/obj/mimic_master/slice/cap
	slot = ZM_SLICE_SLOT_CAP
	slice_kind = ZM_SLICE_TY_CAP

// -- Virtual slices --

/// Sums ZM appearances, excluding shadowers.
/obj/mimic_master/slice/virtual/zsum
	slot = ZM_VSLICE_SLOT_ZSUM
	slice_kind = ZM_SLICE_TY_ZSUM

/obj/mimic_master/slice/virtual/zsum/Initialize(mapload, depth)
	..()
	if (depth != OPENTURF_MAX_DEPTH)
		render_source = ZM_SLICE_VIRTUAL(ZM_SLICE_TY_ZSUM, depth + 1)
	filters = list(
		filter(type = "layer", render_source = ZM_SLICE(ZM_SLICE_TY_BASIC, depth))
	)
	render_target = ZM_SLICE_VIRTUAL(ZM_SLICE_TY_ZSUM, depth)

// -- Non-slice Z masters -

/// Contains game world.
/obj/mimic_master/plane_zero
	plane = DEFAULT_PLANE
	render_target = "plane_zero"
