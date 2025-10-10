// A silhouette mask used to cause mobs to flash a solid colour when hit.
/obj/effect/silhouette
	icon              = 'icons/effects/32x32.dmi'
	icon_state        = "FFF"
	mouse_opacity     = MOUSE_OPACITY_UNCLICKABLE
	layer             = ABOVE_LIGHTING_LAYER
	plane             = ABOVE_LIGHTING_PLANE
	appearance_flags  = RESET_ALPHA|RESET_COLOR|KEEP_APART
	is_spawnable_type = FALSE
	alpha             = 0
	var/mob/living/owner

/obj/effect/silhouette/Initialize(mapload)
	. = ..()
	owner = loc
	if(!istype(owner))
		return INITIALIZE_HINT_QDEL
	global.events_repository.register(/decl/observ/moved, owner, src, TYPE_PROC_REF(/obj/effect/silhouette, follow_owner))
	add_filter("owner_mask", 1, list(type = "alpha", render_source = "render_\ref[owner]"))
	name = null
	verbs.Cut()
	update_transforms_from_mob(owner)

/obj/effect/silhouette/Destroy()
	if(owner)
		global.events_repository.unregister(/decl/observ/moved, owner, src)
		if(owner.silhouette == src)
			owner.silhouette = null
		owner = null
	if(is_processing)
		STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/silhouette/Process()
	..()
	update_transforms_from_mob(owner)

/obj/effect/silhouette/proc/update_transforms_from_mob(mob/donor)
	if(QDELETED(donor))
		alpha = 0
		return
	transform = donor.transform
	pixel_x = donor.pixel_x
	pixel_y = donor.pixel_y
	pixel_z = donor.pixel_z
	pixel_w = donor.pixel_w
	glide_size = donor.glide_size

/obj/effect/silhouette/proc/follow_owner()
	glide_size = owner.glide_size
	forceMove(owner.loc)
