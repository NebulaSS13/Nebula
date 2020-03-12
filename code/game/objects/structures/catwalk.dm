/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk"
	density = 0
	anchored = 1.0
	layer = CATWALK_LAYER
	footstep_type = /decl/footsteps/catwalk
	obj_flags = OBJ_FLAG_NOFALL
	handle_generic_blending = TRUE
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT

	var/hatch_open = FALSE
	var/obj/item/stack/tile/mono/plated_tile
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
	if(. != INITIALIZE_HINT_QDEL)
		for(var/obj/structure/catwalk/C in get_turf(src))
			if(C != src)
				qdel(C)
		. = INITIALIZE_HINT_LATELOAD

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
	for(var/direction in GLOB.alldirs)
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
			I = image('icons/obj/catwalks.dmi', "catwalk[connections ? connections[i] : "0"]", dir = 1<<(i-1))
			overlays += I
	if(plated_tile)
		I = image('icons/obj/catwalks.dmi', "plated")
		I.color = plated_tile.color
		overlays += I

/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1)
			new /obj/item/stack/material/rods(loc)
			qdel(src)
		if(2)
			new /obj/item/stack/material/rods(loc)
			qdel(src)

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
		if(isCrowbar(C) && plated_tile)
			hatch_open = !hatch_open
			if(hatch_open)
				playsound(src, 'sound/items/Crowbar.ogg', 100, 2)
				to_chat(user, "<span class='notice'>You pry open \the [src]'s maintenance hatch.</span>")
			else
				playsound(src, 'sound/items/Deconstruct.ogg', 100, 2)
				to_chat(user, "<span class='notice'>You shut \the [src]'s maintenance hatch.</span>")
			update_icon()
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
						if(ispath(C.type, F.build_type))
							plated_tile = F
							break
					update_icon()

/obj/structure/catwalk/refresh_neighbors()
	return

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = 1
	anchored = 1.0
	var/activated = FALSE
	layer = CATWALK_LAYER
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
	attack_generic()

/obj/effect/catwalk_plated/attack_ghost()
	attack_generic()

/obj/effect/catwalk_plated/attack_generic()
	activate()

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/C = new /obj/structure/catwalk(loc)
		C.plated_tile += new plating_type
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
