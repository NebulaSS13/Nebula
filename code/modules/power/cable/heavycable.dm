// HEAVY DUTY CABLES
/obj/item/stack/cable_coil/heavyduty
	name = "heavy cable coil"
	icon = 'icons/obj/power_cond_heavy.dmi'
	stack_merge_type = /obj/item/stack/cable_coil/heavyduty
	cable_type = /obj/structure/cable/heavyduty
	color = null
	can_have_color = FALSE

/obj/structure/cable/heavyduty
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	cable_type = /obj/item/stack/cable_coil/heavyduty
	color = null
	can_have_color = FALSE

#define IS_TOOL_WITH_QUALITY(A, T, Q)     (isatom(A) && A.get_tool_quality(T) >= Q)
/obj/structure/cable/heavyduty/attackby(obj/item/used_item, mob/user)
	if(IS_WIRECUTTER(used_item))
		// Must be cut with power tools like the hydraulic clamp.
		if(IS_TOOL_WITH_QUALITY(used_item, TOOL_WIRECUTTERS, TOOL_QUALITY_GOOD))
			cut_wire(used_item, user)
		else
			to_chat(user, SPAN_WARNING("\The [used_item] isn't strong enough to cut \the [src]."))
		return TRUE
	if(istype(used_item, /obj/item/stack/cable_coil) && !istype(used_item, /obj/item/stack/cable_coil/heavyduty))
		to_chat(user, SPAN_WARNING("\The [used_item] isn't heavy enough to connect to \the [src]."))
		return TRUE
	return ..()

#undef IS_TOOL_WITH_QUALITY

// No diagonals or Z-cables for this subtype.
/obj/item/stack/cable_coil/heavyduty/put_cable(turf/F, mob/user, d1, d2)
	if((d1 & (UP|DOWN)) || (d2 & (UP|DOWN)))
		to_chat(user, SPAN_WARNING("\The [src] is too heavy to connect vertically!"))
		return FALSE
	if((d1 & (d1 - 1)) || (d2 & (d2 - 1)))
		to_chat(user, SPAN_WARNING("\The [src] can't connect at that angle!"))
		return FALSE
	return ..(F, user, d1, d2)