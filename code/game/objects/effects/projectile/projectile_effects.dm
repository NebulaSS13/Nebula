/obj/effect/projectile
	name = "pew"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "nothing"
	plane = ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER //Muzzle flashes would be above the lighting plane anyways.
	anchored = TRUE
	unacidable = TRUE
	light_color = "#00ffff"
	light_range = 2
	light_power = 1
	mouse_opacity = 0
	appearance_flags = 0
	var/overlay_state
	var/overlay_color

/obj/effect/projectile/invislight
	alpha = 0
	invisibility = INVISIBILITY_MAXIMUM

/obj/effect/projectile/invislight/proc/copy_from(var/obj/effect/projectile/owner)
	light_range = initial(owner.light_range)
	light_power = initial(owner.light_power)
	light_color = initial(owner.light_color)
	light_wedge = initial(owner.light_wedge)

	set_light(light_range, light_power, light_color, light_wedge)

/obj/effect/projectile/on_update_icon()
	cut_overlays()
	if(overlay_state)
		var/image/I = image(icon, "[icon_state][overlay_state]")
		I.color = overlay_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
		// Projectile effects only exist for a tick or two, need to call
		// this to ensure they show their overlays before expiring.
		compile_overlays()

/obj/effect/projectile/singularity_pull()
	return

/obj/effect/projectile/singularity_act()
	return 0

/obj/effect/projectile/proc/scale_to(nx,ny,override=TRUE)
	var/matrix/M
	if(override)
		M = new
	else
		M = transform
	M.Scale(nx,ny)
	transform = M

/obj/effect/projectile/proc/turn_to(angle,override=TRUE)
	var/matrix/M
	if(override)
		M = new
	else
		M = transform
	M.Turn(angle)
	transform = M

/obj/effect/projectile/Initialize(mapload, angle_override, p_x, p_y, color_override, scaling = 1)
	if(angle_override && p_x && p_y && color_override && scaling)
		apply_vars(angle_override, p_x, p_y, color_override, scaling)
	. = ..()
	if(overlay_state)
		update_icon()

/obj/effect/projectile/proc/apply_vars(angle_override, p_x = 0, p_y = 0, color_override, scaling = 1, new_loc, increment = 0)
	var/mutable_appearance/look = new(src)
	look.pixel_x = p_x
	look.pixel_y = p_y
	if(color_override)
		look.color = color_override
	appearance = look
	scale_to(1,scaling, FALSE)
	turn_to(angle_override, FALSE)
	if(!isnull(new_loc))	//If you want to null it just delete it...
		forceMove(new_loc)
	for(var/i in 1 to increment)
		pixel_x += round((sin(angle_override)+16*sin(angle_override)*2), 1)
		pixel_y += round((cos(angle_override)+16*cos(angle_override)*2), 1)
