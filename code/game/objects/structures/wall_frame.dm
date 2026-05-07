// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/structures/wall_frame.dmi'
	icon_state = "frame"
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CAN_BE_PAINTED | ATOM_FLAG_ADJACENT_EXCEPTION
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	anchored = TRUE
	density = TRUE
	throwpass = 1
	layer = TABLE_LAYER
	rad_resistance_modifier = 0.5
	material = DEFAULT_WALL_MATERIAL
	handle_generic_blending = TRUE
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	max_health = 40
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut
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

/obj/structure/wall_frame/LateInitialize()
	..()
	update_connections(1)
	update_icon()

/obj/structure/wall_frame/examine(mob/user)
	. = ..()
	if(paint_color)
		to_chat(user, SPAN_NOTICE("It has a smooth coat of paint applied."))

/obj/structure/wall_frame/get_examined_damage_string()
	if(!can_take_damage())
		return
	var/health_percent = get_percent_health()
	if(health_percent > 70)
		return SPAN_NOTICE("It's got a few dents and scratches.")
	else if(health_percent > 30)
		return SPAN_WARNING("A few pieces of panelling have fallen off.")
	else
		return SPAN_DANGER("It's nearly falling to pieces.")

/obj/structure/wall_frame/attackby(var/obj/item/W, var/mob/user)
	. = ..()
	if(!.)
		//grille placing
		if(istype(W, /obj/item/stack/material/rods))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == get_dir(src, user))
					to_chat(user, SPAN_WARNING("There is a window in the way."))
					return TRUE
			place_grille(user, loc, W)
			return TRUE

		//window placing
		if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/ST = W
			if(ST.material.opacity <= 0.7)
				place_window(user, loc, SOUTHWEST, ST)
			return TRUE

		if(istype(W, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = W
			if(!cutter.slice(user))
				return
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			visible_message(SPAN_NOTICE("\The [user] begins slicing through \the [src] with \the [W]."))
			if(do_after(user, 20,src))
				visible_message(SPAN_NOTICE("\The [user] slices \the [src] apart with \the [W]."))
				dismantle_structure(user)
			return TRUE

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1

/obj/structure/wall_frame/on_update_icon()
	..()
	var/image/I
	var/new_color = stripe_color ? stripe_color : material.color

	for(var/i = 1 to 4)
		var/conn = connections ? connections[i] : "0"
		if(other_connections && other_connections[i] != "0")
			I = image(icon, "frame_other[conn]", dir = BITFLAG(i-1))
		else
			I = image(icon, "frame[conn]", dir = BITFLAG(i-1))
		I.color = new_color
		add_overlay(I)

/obj/structure/wall_frame/proc/paint_wall_frame(var/new_paint_color)
	paint_color = new_paint_color
	update_icon()


/obj/structure/wall_frame/proc/stripe_wall_frame(var/new_paint_color)
	stripe_color = new_paint_color
	update_icon()


/obj/structure/wall_frame/hull/Initialize()
	. = ..()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in global.cardinal)
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
	take_damage(damage, Proj.atom_damage_type)
	return

/obj/structure/wall_frame/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	if(.)
		var/tforce = AM.get_thrown_attack_force() * (TT.speed/THROWFORCE_SPEED_DIVISOR)
		if (tforce < 15)
			return
		take_damage(tforce)

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_GUNMETAL

/obj/structure/wall_frame/titanium
	material = /decl/material/solid/metal/titanium

/obj/structure/wall_frame/hull
	paint_color = COLOR_HULL
	stripe_color = COLOR_HULL

/obj/structure/wall_frame/log
	name = "low log wall"
	desc = "A section of log wall with empty space for fitting a window or simply letting air in."
	icon = 'icons/obj/structures/log_wall_frame.dmi'
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC // material color is applied in on_update_icon

/obj/structure/wall_frame/log/Initialize()
	color = null // clear mapping preview color
	. = ..()

#define LOW_LOG_WALL_SUBTYPE(material_name) \
/obj/structure/wall_frame/log/##material_name { \
	material = /decl/material/solid/organic/wood/##material_name; \
	color = /decl/material/solid/organic/wood/##material_name::color; \
}

LOW_LOG_WALL_SUBTYPE(fungal)
LOW_LOG_WALL_SUBTYPE(ebony)
LOW_LOG_WALL_SUBTYPE(walnut)
LOW_LOG_WALL_SUBTYPE(maple)
LOW_LOG_WALL_SUBTYPE(mahogany)
LOW_LOG_WALL_SUBTYPE(bamboo)
LOW_LOG_WALL_SUBTYPE(yew)