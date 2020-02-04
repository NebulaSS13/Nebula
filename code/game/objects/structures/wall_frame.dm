// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	anchored = 1
	density = 1
	throwpass = 1
	layer = TABLE_LAYER
	rad_resistance_modifier = 0.5
	material = DEFAULT_WALL_MATERIAL
	handle_generic_blending = TRUE

	var/health = 100
	var/paint_color
	var/stripe_color
	var/list/connections
	var/list/other_connections
	
/obj/structure/wall_frame/clear_connections()
	connections = null
	other_connections = null

/obj/structure/wall_frame/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/wall_frame/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/wall_frame/update_materials(var/keep_health)
	if(!keep_health)
		health = material.integrity

/obj/structure/wall_frame/LateInitialize()
	..()
	update_connections(1)
	update_icon()

/obj/structure/wall_frame/examine(mob/user)
	. = ..()

	if(health == material.integrity)
		to_chat(user, "<span class='notice'>It seems to be in fine condition.</span>")
	else
		var/dam = health / material.integrity
		if(dam <= 0.3)
			to_chat(user, "<span class='notice'>It's got a few dents and scratches.</span>")
		else if(dam <= 0.7)
			to_chat(user, "<span class='warning'>A few pieces of panelling have fallen off.</span>")
		else
			to_chat(user, "<span class='danger'>It's nearly falling to pieces.</span>")
	if(paint_color)
		to_chat(user, "<span class='notice'>It has a smooth coat of paint applied.</span>")

/obj/structure/wall_frame/attackby(var/obj/item/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing
	if(istype(W, /obj/item/stack/material/rods))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		place_grille(user, loc, W)
		return

	//window placing
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(ST.material.opacity > 0.7)
			return 0
		place_window(user, loc, SOUTHWEST, ST)

	if(isWrench(W))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, "<span class='notice'>There is still a window on the low wall!</span>")
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, "<span class='notice'>There is still a grille on the low wall!</span>")
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the low wall...</span>")
		if(do_after(user, 40,src))
			to_chat(user, "<span class='notice'>You dissasembled the low wall!</span>")
			dismantle()

	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = W
		if(!cutter.slice(user))
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now slicing through the low wall...</span>")
		if(do_after(user, 20,src))
			to_chat(user, "<span class='warning'>You have sliced through the low wall!</span>")
			dismantle()
	return ..()

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1

// icon related

/obj/structure/wall_frame/on_update_icon()
	overlays.Cut()
	var/image/I

	var/new_color = (paint_color ? paint_color : material.icon_colour)
	color = new_color

	for(var/i = 1 to 4)
		var/conn = connections ? connections[i] : "0"
		if(other_connections && other_connections[i] != "0")
			I = image('icons/obj/wall_frame.dmi', "frame_other[conn]", dir = 1<<(i-1))
		else
			I = image('icons/obj/wall_frame.dmi', "frame[conn]", dir = 1<<(i-1))
		overlays += I

	if(stripe_color)
		for(var/i = 1 to 4)
			var/conn = connections ? connections[i] : "0"
			if(other_connections && other_connections[i] != "0")
				I = image('icons/obj/wall_frame.dmi', "stripe_other[conn]", dir = 1<<(i-1))
			else
				I = image('icons/obj/wall_frame.dmi', "stripe[conn]", dir = 1<<(i-1))
			I.color = stripe_color
			overlays += I

/obj/structure/wall_frame/hull/Initialize()
	. = ..()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
		update_icon()

/obj/structure/wall_frame/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	var/damage = min(proj_damage, 100)
	take_damage(damage)
	return

/obj/structure/wall_frame/hitby(AM as mob|obj, var/datum/thrownthing/TT)
	..()
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	else
		var/obj/O = AM
		tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return
	take_damage(tforce)

/obj/structure/wall_frame/take_damage(damage)
	health -= damage
	if(health <= 0)
		dismantle()

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_WALL_GUNMETAL

/obj/structure/wall_frame/titanium
	material = MAT_TITANIUM

/obj/structure/wall_frame/hull
	paint_color = COLOR_HULL