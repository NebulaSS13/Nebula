/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/structures/catwalks.dmi'
	icon_state = "catwalk"
	density = 0
	anchored = 1.0
	layer = CATWALK_LAYER
	footstep_type = /decl/footsteps/catwalk
	obj_flags = OBJ_FLAG_NOFALL
	handle_generic_blending = TRUE
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material = /decl/material/solid/metal/steel

	var/hatch_open = FALSE
	var/decl/flooring/tiling/plated_tile
	var/list/connections
	var/list/other_connections

/obj/structure/catwalk/clear_connections()
	connections = null
	other_connections = null

/obj/structure/catwalk/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/catwalk/Initialize()
	. = ..()
	DELETE_IF_DUPLICATE_OF(/obj/structure/catwalk)

	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	return INITIALIZE_HINT_LATELOAD

/obj/structure/catwalk/LateInitialize()
	..()
	update_connections(1)
	update_icon()

/obj/structure/catwalk/Destroy()
	var/turf/oldloc = loc
	redraw_nearby_catwalks()
	. = ..()
	if(istype(oldloc))
		for(var/atom/movable/AM in oldloc)
			AM.fall(oldloc)

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in global.alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_connections()
			L.update_icon() //so siding get updated properly

/obj/structure/catwalk/on_update_icon()
	update_connections()
	overlays.Cut()
	icon_state = ""
	var/image/I
	if(!hatch_open)
		for(var/i = 1 to 4)
			I = image(icon, "catwalk[connections ? connections[i] : "0"]", dir = 1<<(i-1))
			overlays += I
	if(plated_tile)
		I = image(icon, "plated")
		I.color = plated_tile.color
		overlays += I

/obj/structure/catwalk/create_dismantled_products(var/turf/T)
	if(material)
		material.create_object(get_turf(src), 2, /obj/item/stack/material/rods)
	if(plated_tile)
		var/plate_path = plated_tile.build_type
		new plate_path(T)

/obj/structure/catwalk/explosion_act(severity)
	..()
	if(!QDELETED(src) && severity != 3)
		physically_destroyed()

/obj/structure/catwalk/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/catwalk/attackby(obj/item/C, mob/user)
	. = ..()
	if(!.)

		if(istype(C, /obj/item/grab))
			var/obj/item/grab/G = C
			G.affecting.forceMove(get_turf(src))
			return TRUE

		if(istype(C, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = C
			if(!cutter.slice(user))
				return
			dismantle(user)
			return TRUE

		if(istype(C, /obj/item/stack/tile/mono) && !plated_tile)

			var/ladder = (locate(/obj/structure/ladder) in loc)
			if(ladder)
				to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
				return TRUE

			var/obj/item/stack/tile/floor/ST = C
			if(!ST.in_use)
				to_chat(user, "<span class='notice'>Placing tile...</span>")
				ST.in_use = 1
				if (!do_after(user, 10))
					ST.in_use = 0
					return TRUE
				to_chat(user, "<span class='notice'>You plate \the [src]</span>")
				name = "plated catwalk"
				ST.in_use = 0
				if(ST.use(1))
					var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
					for(var/flooring_type in decls)
						var/decl/flooring/F = decls[flooring_type]
						if(!F.build_type)
							continue
						if(istype(C, F.build_type) && (!F.build_material || C.material?.type == F.build_material))
							plated_tile = F
							break
					update_icon()

/obj/structure/catwalk/handle_default_crowbar_attackby(mob/user, obj/item/crowbar)
	if(plated_tile)
		hatch_open = !hatch_open
		if(hatch_open)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You pry open \the [src]'s maintenance hatch.</span>")
		else
			playsound(src, 'sound/items/Deconstruct.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You shut \the [src]'s maintenance hatch.</span>")
		update_icon()
		return TRUE
	. = ..()

/obj/structure/catwalk/hoist_act(turf/dest)
	for(var/A in loc)
		var/atom/movable/AM = A
		if (AM.simulated && !AM.anchored)
			AM.forceMove(dest)
	..()

/obj/structure/catwalk/refresh_neighbors()
	return

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/obj/structures/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = 1
	anchored = 1.0
	layer = CATWALK_LAYER
	var/activated = FALSE
	var/plating_type = /decl/flooring/tiling/mono

/obj/effect/catwalk_plated/Initialize(mapload)
	. = ..()
	var/auto_activate = mapload || (GAME_STATE < RUNLEVEL_GAME)
	if(auto_activate)
		activate()
		return INITIALIZE_HINT_QDEL

/obj/effect/catwalk_plated/CanPass()
	return 0

/obj/effect/catwalk_plated/attack_hand()
	activate()

/obj/effect/catwalk_plated/attack_ghost()
	activate()

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/C = new /obj/structure/catwalk(loc)
		C.plated_tile += GET_DECL(plating_type)
		C.name = "plated catwalk"
		C.update_icon()
	activated = 1
	for(var/turf/T in orange(src, 1))
		for(var/obj/effect/wallframe_spawn/other in T)
			if(!other.activated) other.activate()

/obj/effect/catwalk_plated/dark
	icon_state = "catwalk_plateddark"
	plating_type = /decl/flooring/tiling/mono/dark

/obj/effect/catwalk_plated/white
	icon_state = "catwalk_platedwhite"
	plating_type = /decl/flooring/tiling/mono/white
