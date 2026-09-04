//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	simulated = FALSE
	var/duration = 1 SECOND //in deciseconds

/obj/effect/temp_visual/Initialize(mapload, set_dir)
	if(set_dir)
		set_dir(set_dir)
	. = ..()
	QDEL_IN(src, duration)

/obj/effect/temp_visual/emp_burst
	icon_state = "empdisable"

/obj/effect/temp_visual/emppulse
	name = "electromagnetic pulse"
	icon_state = "emppulse"
	duration = 2 SECONDS

/obj/effect/temp_visual/bloodsplatter
	icon = 'icons/effects/bloodspatter.dmi'
	duration = 0.5 SECONDS
	layer = LYING_HUMAN_LAYER
	var/splatter_type = "splatter"

/obj/effect/temp_visual/bloodsplatter/Initialize(mapload, set_dir, _color)
	if(set_dir in global.cornerdirs)
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	. = ..()
	if (_color)
		color = _color

	var/target_pixel_x = 0
	var/target_pixel_y = 0
	if(set_dir & NORTH)
		target_pixel_y = 16
	if(set_dir & SOUTH)
		target_pixel_y = -16
		layer = ABOVE_HUMAN_LAYER
	if(set_dir & EAST)
		target_pixel_x = 16
	if(set_dir & WEST)
		target_pixel_x = -16
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)

/obj/effect/temp_visual/impact_effect
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER // So they're visible even in a shootout in maint.
	duration = 5
	icon_state = "impact_bullet"
	icon = 'icons/effects/impact_effects.dmi'

/obj/effect/temp_visual/impact_effect/Initialize(mapload, obj/item/projectile/P, _x, _y)
	default_pixel_x = _x
	default_pixel_y = _y
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	. = ..()

/obj/effect/temp_visual/impact_effect/red_laser
	icon_state = "impact_laser"
	duration = 4

/obj/effect/temp_visual/impact_effect/blue_laser
	icon_state = "impact_laser_blue"
	duration = 4

/obj/effect/temp_visual/impact_effect/green_laser
	icon_state = "impact_laser_green"
	duration = 4

/obj/effect/temp_visual/impact_effect/purple_laser
	icon_state = "impact_laser_purple"
	duration = 4

// Colors itself based on the projectile.
// Checks light_color and color.
/obj/effect/temp_visual/impact_effect/monochrome_laser
	icon_state = "impact_laser_monochrome"
	duration = 4

/obj/effect/temp_visual/impact_effect/monochrome_laser/Initialize(mapload, obj/item/projectile/P, x, y)
	if(istype(P))
		if(P.light_color)
			color = P.light_color
		else if(P.color)
			color = P.color
	return ..()

/obj/effect/temp_visual/impact_effect/ion
	icon_state = "shieldsparkles"
	duration = 6
