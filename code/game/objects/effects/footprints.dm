// Effect used to render dark spot on turfs like snow/mud.
/obj/effect/footprints
	icon              = 'icons/mob/footprints/footprints.dmi'
	icon_state        = "blank"
	simulated         = FALSE
	anchored          = TRUE
	is_spawnable_type = FALSE
	blend_mode        = BLEND_SUBTRACT
	alpha             = 128
	var/list/image/footprints

/obj/effect/footprints/Initialize(mapload)
	. = ..()
	verbs.Cut()
	name = null

/obj/effect/footprints/Destroy()
	footprints.Cut() // don't qdel images
	. = ..()

/obj/effect/footprints/on_turf_height_change(new_height)
	if(simulated)
		qdel(src)
		return TRUE
	return FALSE

/obj/effect/footprints/on_update_icon()
	set_overlays(footprints?.Copy())
	compile_overlays()

/obj/effect/footprints/proc/add_footprints(mob/crosser, footprint_icon, movement_dir, use_state = "coming")
	var/image/update_footprint
	for(var/image/footprint in footprints)
		if(footprint.icon == footprint_icon && footprint.dir == movement_dir && footprint.icon_state == use_state)
			update_footprint = footprint
			break
	if(!update_footprint)
		update_footprint = image(footprint_icon, icon_state = use_state, dir = movement_dir)
		update_footprint.alpha = 20
		LAZYADD(footprints, update_footprint)
	if(update_footprint.alpha < 120)
		update_footprint.alpha += round(crosser.get_object_size() / 5)
		queue_icon_update()
	return TRUE

/mob/proc/get_footprints_icon()
	if(is_floating)
		return null
	if(buckled || current_posture?.prone)
		return 'icons/mob/footprints/footprints_trail.dmi'
	if(istype(buckled, /obj/structure/chair))
		return 'icons/mob/footprints/footprints_wheelchair.dmi'
	var/obj/item/clothing/shoes/shoes = get_equipped_item(slot_shoes_str)
	if(istype(shoes) && shoes.footprint_icon)
		return shoes.footprint_icon
	return get_bodytype()?.get_footprints_icon()
