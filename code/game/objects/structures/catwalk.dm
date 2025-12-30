/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/structures/catwalks.dmi'
	icon_state = "catwalk"
	density = FALSE
	anchored = TRUE
	layer = CATWALK_LAYER
	footstep_type = /decl/footsteps/catwalk
	obj_flags = OBJ_FLAG_NOFALL | OBJ_FLAG_MOVES_UNSUPPORTED
	handle_generic_blending = TRUE
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material = /decl/material/solid/metal/steel
	parts_type = /obj/item/stack/material/rods
	parts_amount = 2

	var/hatch_open = FALSE
	var/decl/flooring/tiling/plated_tile
	var/list/connections
	var/list/other_connections

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
		oldloc.supporting_platform = null

// Catwalks need to layer over grass and water.
/obj/structure/catwalk/update_turf_alpha_mask()
	return FALSE

/obj/structure/catwalk/clear_connections()
	connections = null
	other_connections = null

/obj/structure/catwalk/is_platform()
	return TRUE

/obj/structure/catwalk/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/catwalk/can_climb_from_below(var/mob/climber)
	return TRUE


/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in global.alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_connections()
			L.update_icon() //so siding get updated properly

/obj/structure/catwalk/on_update_icon()
	update_connections()
	..()
	icon_state = ""
	if(!hatch_open)
		for(var/i = 1 to 4)
			add_overlay(image(icon, "catwalk[connections ? connections[i] : "0"]", dir = BITFLAG(i-1)))
	if(plated_tile)
		var/image/overlay_image = image(icon, "plated")
		overlay_image.color = plated_tile.color
		add_overlay(overlay_image)

/obj/structure/catwalk/create_dismantled_products(var/turf/T)
	. = ..()
	if(plated_tile)
		var/plate_path = plated_tile.build_type
		LAZYADD(., new plate_path(T))
		plated_tile = null

/obj/structure/catwalk/explosion_act(severity)
	..()
	if(!QDELETED(src) && severity != 3)
		physically_destroyed()

/obj/structure/catwalk/grab_attack(obj/item/grab/grab, mob/user)
	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			to_chat(user, SPAN_WARNING("There's \a [occupied] in the way."))
			return TRUE
		grab.affecting.forceMove(src.loc)
		var/mob/living/victim = grab.get_affecting_mob()
		if(istype(victim))
			SET_STATUS_MAX(victim, STAT_WEAK, rand(2,5))
			visible_message(SPAN_DANGER("\The [user] puts \the [victim] on \the [src]."))
		return TRUE
	return ..()

/obj/structure/catwalk/attack_robot(var/mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/catwalk/attackby(obj/item/used_item, mob/user)

	if((. = ..()))
		return

	if(istype(used_item, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = used_item
		if(cutter.slice(user))
			dismantle_structure(user)
		return TRUE

	if(istype(used_item, /obj/item/stack/tile/mono) && !plated_tile)

		var/ladder = (locate(/obj/structure/ladder) in loc)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE

		var/obj/item/stack/tile/ST = used_item
		if(ST.in_use)
			return TRUE

		to_chat(user, SPAN_NOTICE("You begin plating \the [src] with \the [ST]."))
		ST.in_use = 1
		if (!do_after(user, 10))
			ST.in_use = 0
			return TRUE

		to_chat(user, SPAN_NOTICE("You plate \the [src]"))
		name = "plated catwalk"
		ST.in_use = 0
		if(!ST.use(1))
			return TRUE

		var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
		for(var/flooring_type in decls)
			var/decl/flooring/F = decls[flooring_type]
			if(!F.build_type)
				continue
			if(istype(used_item, F.build_type) && (!F.build_material || used_item.material?.type == F.build_material))
				plated_tile = F
				break
		update_icon()
		return TRUE

	return FALSE

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

/obj/structure/catwalk/is_z_passable()
	return !plated_tile

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/obj/structures/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = TRUE
	anchored = TRUE
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
	SHOULD_CALL_PARENT(FALSE)
	activate()
	return TRUE

/obj/effect/catwalk_plated/attack_ghost()
	activate()
	return TRUE

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/catwalk = new /obj/structure/catwalk(loc)
		catwalk.plated_tile += GET_DECL(plating_type)
		catwalk.name = "plated catwalk"
		catwalk.update_icon()
	activated = 1
	for(var/turf/T in orange(src, 1))
		for(var/obj/effect/catwalk_plated/other in T)
			if(!other.activated) other.activate()

/obj/effect/catwalk_plated/dark
	icon_state = "catwalk_plateddark"
	plating_type = /decl/flooring/tiling/mono/dark

/obj/effect/catwalk_plated/white
	icon_state = "catwalk_platedwhite"
	plating_type = /decl/flooring/tiling/mono/white
