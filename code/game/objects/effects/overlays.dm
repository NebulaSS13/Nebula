/obj/effect/overlay
	name = "overlay"

/obj/effect/overlay/singularity_pull()
	return

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state= "b_beam"
	var/tmp/atom/BeamSource

/obj/effect/overlay/beam/Initialize()
	. = ..()
	QDEL_IN(src, 1 SECOND)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "subspace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	layer = SUPERMATTER_WALL_LAYER

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = TRUE
	density = TRUE
	layer = ABOVE_TILE_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/obj/effect/overlay/wallrot/Initialize()
	. = ..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/// Set and cleaned up by moving projectiles for the most part.
/obj/effect/overlay/projectile_trail
	var/obj/item/projectile/master

/obj/effect/overlay/projectile_trail/Destroy()
	if(master)
		LAZYREMOVE(master.proj_trails, src)
		master = null
	return ..()
