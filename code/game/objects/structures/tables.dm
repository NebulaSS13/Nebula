/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL
	reinf_material = DEFAULT_FURNITURE_MATERIAL
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = TABLE_LAYER
	throwpass = TRUE
	mob_offset = 12
	handle_generic_blending = TRUE
	maxhealth = 10
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut

	var/can_flip = TRUE
	var/is_flipped = FALSE
	var/decl/material/additional_reinf_material

	var/top_surface_noun = "tabletop"

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/felted = 0
	var/list/connections

/obj/structure/table/clear_connections()
	connections = null

/obj/structure/table/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)

/obj/structure/table/Initialize()
	if(ispath(additional_reinf_material, /decl/material))
		additional_reinf_material = GET_DECL(additional_reinf_material)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		if(!material)
			return INITIALIZE_HINT_QDEL
		if(reinf_material || additional_reinf_material || felted)
			tool_interaction_flags &= ~TOOL_INTERACTION_DECONSTRUCT

		for(var/obj/structure/table/T in loc)
			if(T != src)
				return INITIALIZE_HINT_QDEL
		. = INITIALIZE_HINT_LATELOAD

// We do this because need to make sure adjacent tables init their material before we try and merge.
/obj/structure/table/LateInitialize()
	..()
	update_connections(TRUE)
	update_icon()

/obj/structure/table/get_material_health_modifier()
	. = additional_reinf_material ? 0.75 : 0.5

/obj/structure/table/physically_destroyed(skip_qdel)
	visible_message(SPAN_DANGER("\The [src] breaks down!"))

	// Destroy some stuff before passing off to dismantle(), which will return it in sheet form instead.
	if(reinf_material && !prob(20))
		reinf_material.place_shards(loc)
		reinf_material = null
	if(material && !prob(20))
		material.place_shards(loc)
		material = null
	if(additional_reinf_material && !prob(20))
		additional_reinf_material.place_shards(loc)
		additional_reinf_material = null
	if(felted && prob(50))
		felted = FALSE

	. = ..()

/obj/structure/table/create_dismantled_products(var/turf/T)
	if(felted)
		new /obj/item/stack/tile/carpet(T)
		felted = FALSE
	if(additional_reinf_material)
		additional_reinf_material.place_dismantled_product(T)
		additional_reinf_material = null
	. = ..()

/obj/structure/table/Destroy()
	var/turf/oldloc = loc
	additional_reinf_material = null
	. = ..()
	if(istype(oldloc))
		for(var/turf/turf as anything in RANGE_TURFS(oldloc, 1))
			for(var/obj/structure/table/table in turf)
				table.update_connections(FALSE)
				table.update_icon()

/obj/structure/table/can_dismantle(mob/user)
	. = ..()
	if(.)
		var/needs_removed
		if(felted)
			needs_removed = "felting"
		else if(reinf_material)
			needs_removed = top_surface_noun
		else if(additional_reinf_material)
			needs_removed = "reinforcements"
		if(needs_removed)
			to_chat(user, SPAN_WARNING("Remove \the [needs_removed] with a screwdriver first."))
			return FALSE

/obj/structure/table/handle_default_screwdriver_attackby(mob/user, obj/item/screwdriver)

	if(!reinf_material)
		return ..()

	if(felted)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes the felting from \the [src]."),
			SPAN_NOTICE("You remove the felting from \the [src]."))
		new /obj/item/stack/tile/carpet(loc)
		felted = FALSE
		update_icon()
		return TRUE

	var/decl/material/remove_mat = reinf_material
	var/remove_noun = top_surface_noun
	var/check_reinf = TRUE
	if(additional_reinf_material)
		remove_mat = additional_reinf_material
		remove_noun = "reinforcements"
		check_reinf = FALSE

	user.visible_message(SPAN_NOTICE("\The [user] begins removing the [src]'s [remove_mat.solid_name] [remove_noun]."))
	playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
	if(do_after(user, 4 SECONDS, src))
		if(check_reinf)
			if(remove_mat != reinf_material)
				return TRUE
			reinf_material.create_object(src.loc)
			reinf_material = null
			tool_interaction_flags |= TOOL_INTERACTION_DECONSTRUCT
		else
			if(remove_mat != additional_reinf_material)
				return TRUE
			additional_reinf_material.create_object(src.loc)
			additional_reinf_material = null

		user.visible_message(SPAN_NOTICE("\The [user] removes the [remove_mat.solid_name] [remove_noun] from \the [src]."),
			SPAN_NOTICE("You remove the [remove_mat.solid_name] [remove_noun] from \the [src]."))
		update_materials()
	return TRUE

/obj/structure/table/attackby(obj/item/W, mob/user, click_params)

	if(user.a_intent == I_HURT && W.is_special_cutting_tool())
		spark_at(src.loc, amount=5)
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		user.visible_message(SPAN_DANGER("\The [src] was sliced apart by \the [user]!"))
		physically_destroyed()
		return TRUE

	if(!reinf_material)
		if(istype(W, /obj/item/stack/material/rods))
			return reinforce_table(W, user)
		if(istype(W, /obj/item/stack/material))
			return finish_table(W, user)
		return ..()

	if(!felted && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message(
				SPAN_NOTICE("\The [user] adds \the [C] to \the [src]."),
				SPAN_NOTICE("You add \the [C] to \the [src]."))
			felted = TRUE
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You don't have enough carpet to felt \the [src]."))
		return TRUE

	//playing cards
	if(istype(W, /obj/item/hand))
		var/obj/item/hand/H = W
		if(H.cards && length(H.cards) == 1)
			user.visible_message("\The [user] plays \the [H.cards[1]].")
			return TRUE

	if(istype(W, /obj/item/deck)) //playing cards
		if(user.a_intent == I_GRAB)
			var/obj/item/deck/D = W
			if(!length(D.cards))
				to_chat(user, "There are no cards in the deck.")
			else
				D.deal_at(user, src)
			return TRUE

	. = ..()

	// Finally we can put the object onto the table.
	if(!. && !isrobot(user) && W.loc == user && user.try_unequip(W, src.loc))
		auto_align(W, click_params)
		return TRUE

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)

	if(additional_reinf_material)
		to_chat(user, SPAN_WARNING("\The [src] already has reinforcements!"))
		return FALSE

	if(!S.material)
		to_chat(user, SPAN_WARNING("You cannot use \the [S] for reinforcements."))
		return FALSE

	if(is_flipped)
		to_chat(user, SPAN_WARNING("Put \the [src] back in place before reinforcing it!"))
		return FALSE

	var/decl/material/mat = S.material
	to_chat(user, SPAN_NOTICE("You begin reinforcing \the [src] with [mat.solid_name]."))
	if(do_after(user, 2 SECONDS, src) && S.use(1) && !additional_reinf_material)
		user.visible_message(SPAN_NOTICE("\The [user] finishes adding [mat.solid_name] reinforcements to \the [src]."))
		additional_reinf_material = mat
		update_materials()
	return TRUE

/obj/structure/table/proc/finish_table(obj/item/stack/material/S, mob/user)

	if(reinf_material)
		to_chat(user, SPAN_WARNING("\The [src] already has \a [top_surface_noun]!"))
		return FALSE

	if(!S.material)
		to_chat(user, SPAN_WARNING("You cannot use \the [S] for \a [top_surface_noun]."))
		return FALSE

	if(is_flipped)
		to_chat(user, SPAN_WARNING("Put \the [src] back in place before putting \a [top_surface_noun] on it!"))
		return FALSE

	var/decl/material/mat = S.material
	to_chat(user, SPAN_NOTICE("You begin furnishing \the [src] with \a [mat.solid_name] [top_surface_noun]."))
	if(do_after(user, 2 SECONDS, src) && S.use(1) && !reinf_material)
		user.visible_message(SPAN_NOTICE("\The [user] finishes adding \a [mat.solid_name] [top_surface_noun] to \the [src]."))
		reinf_material = mat
		update_materials()
		tool_interaction_flags &= ~TOOL_INTERACTION_DECONSTRUCT

	return TRUE

/obj/structure/table/examine(mob/user, distance)
	. = ..()
	if(felted || reinf_material || additional_reinf_material)
		to_chat(user, SPAN_SUBTLE("The cladding must be removed with a screwdriver prior to deconstructing \the [src]."))

/obj/structure/table/update_material_name(override_name)
	if(reinf_material)
		name = "[reinf_material.solid_name] table"
	else if(material)
		name = "[material.solid_name] table frame"
	else
		name = "table frame"

/obj/structure/table/update_material_desc(override_desc)
	desc = initial(desc)
	if(reinf_material)
		desc = "[desc] This one has a frame made from [material.solid_name] and \a [top_surface_noun] made from [reinf_material.solid_name]."
	else if(material)
		desc = "[desc] This one has a frame made from [material.solid_name]."
	if(felted)
		desc = "[desc] It has been covered in felt."
	if(additional_reinf_material)
		desc = "[desc] It has been reinforced with [additional_reinf_material.solid_name]."

/obj/structure/table/on_update_icon()

	color = "#ffffff"
	alpha = 255
	..()

	icon_state = "blank"
	if(!is_flipped)
		mob_offset = initial(mob_offset)
		var/image/I
		// Base frame shape.
		for(var/i = 1 to 4)
			I = image(icon, dir = BITFLAG(i-1), icon_state = connections ? connections[i] : "0")
			I.color = material.color
			I.alpha = 255 * material.opacity
			add_overlay(I)
		// Tabletop
		if(reinf_material)
			for(var/i = 1 to 4)
				I = image(icon, "[reinf_material.table_icon_base]_[connections ? connections[i] : "0"]", dir = BITFLAG(i-1))
				I.color = reinf_material.color
				I.alpha = 255 * reinf_material.opacity
				add_overlay(I)
		if(additional_reinf_material)
			for(var/i = 1 to 4)
				I = image(icon, "[additional_reinf_material.table_icon_reinforced]_[connections ? connections[i] : "0"]", dir = BITFLAG(i-1))
				I.color = additional_reinf_material.color
				I.alpha = 255 * additional_reinf_material.opacity
				add_overlay(I)

		if(felted)
			for(var/i = 1 to 4)
				add_overlay(image(icon, "carpet_[connections ? connections[i] : "0"]", dir = BITFLAG(i-1)))
	else

		mob_offset = 0

		var/obj/structure/table/left_neighbor  = locate(/obj/structure/table) in get_step(loc, turn(dir, -90))
		var/obj/structure/table/right_neighbor = locate(/obj/structure/table) in get_step(loc, turn(dir, 90))
		var/left_neighbor_blend = istype(left_neighbor)   && blend_with(left_neighbor)  && left_neighbor.is_flipped == is_flipped  && left_neighbor.dir == dir
		var/right_neighbor_blend = istype(right_neighbor) && blend_with(right_neighbor) && right_neighbor.is_flipped == is_flipped && right_neighbor.dir == dir

		var/flip_type = 0
		var/flip_mod = ""
		if(left_neighbor_blend && right_neighbor_blend)
			flip_type = 2
			icon_state = "flip[flip_type]"
		else if(left_neighbor_blend || right_neighbor_blend)
			flip_type = 1
			flip_mod = (left_neighbor_blend ? "+" : "-")
			icon_state = "flip[flip_type][flip_mod]"

		color = material.color
		alpha = 255 * material.opacity

		var/image/I
		if(reinf_material)
			I = image(icon, "[reinf_material.table_icon_base]_flip[flip_type][flip_mod]")
			I.color = reinf_material.color
			I.alpha = 255 * reinf_material.opacity
			I.appearance_flags |= RESET_COLOR|RESET_ALPHA
			add_overlay(I)
		if(additional_reinf_material)
			I = image(icon, "[reinf_material.table_icon_reinforced]_flip[flip_type][flip_mod]")
			I.color = additional_reinf_material.color
			I.alpha = 255 * additional_reinf_material.opacity
			I.appearance_flags |= RESET_COLOR|RESET_ALPHA
			add_overlay(I)

		if(felted)
			add_overlay("carpet_flip[flip_type][flip_mod]")

/obj/structure/table/proc/blend_with(var/obj/structure/table/other)
	if(!istype(other) || !istype(material) || !istype(other.material) || material.type != other.material.type)
		return FALSE
	if(istype(reinf_material) && (!istype(other.reinf_material) || reinf_material.type != other.reinf_material.type))
		return FALSE
	if(istype(additional_reinf_material) && (!istype(other.additional_reinf_material) || additional_reinf_material.type != other.additional_reinf_material.type))
		return FALSE
	return TRUE

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/update_connections(propagate = FALSE)
	if(!material)
		connections = list("0", "0", "0", "0")
		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections(FALSE)
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == global.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || (W.dir & global.reverse_dir[D]))
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()
	for(var/obj/structure/table/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs)
			continue
		if(blend_with(T) && is_flipped == T.is_flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections(FALSE)
				T.update_icon()
	connections = dirs_to_corner_states(connection_dirs)

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if (is_flipped)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	var/obj/structure/table/T = (locate() in get_turf(mover))
	return (T && !T.is_flipped)

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(is_flipped)
		cover = get_turf(src)
	else
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 20
	if(ismob(P.original) && get_turf(P.original) == cover)
		var/mob/M = P.original
		if (M.lying)
			chance += 20				//Lying down lets you catch less bullets
	if(is_flipped)
		if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
			chance += 30
		else
			return 1					//But only from one side

	if(prob(chance))
		return 0 //blocked
	return 1

/obj/structure/table/CheckExit(atom/movable/O, target)
	if(istype(O) && O.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(is_flipped)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return TRUE
	return TRUE

/obj/structure/table/receive_mouse_drop(atom/dropping, mob/user)
	. = ..()
	if(!. && !isrobot(user) && isitem(dropping) && user.get_active_hand() == dropping && user.try_unequip(dropping))
		var/obj/item/I = dropping
		I.dropInto(get_turf(src))
		return TRUE

/obj/structure/table/proc/can_flip()
	return can_flip && !additional_reinf_material && !is_flipped

/obj/structure/table/proc/recursive_flip_check(var/direction, var/list/checked)

	LAZYDISTINCTADD(checked, src)

	if(!can_flip())
		return FALSE

	// Is the table directly in the direction of flipping part of us?
	var/obj/structure/table/T = locate() in get_step(src.loc, direction)
	if(istype(T) && blend_with(T) && is_flipped == T.is_flipped)
		return FALSE

	// How about the table directly behind?
	T = locate() in get_step(src.loc, turn(direction, 180))
	if(istype(T) && blend_with(T) && is_flipped == T.is_flipped)
		return FALSE

	// Are we part of a single straight table or not?
	for(var/angle in list(-90, 90))
		T = locate() in get_step(src.loc,turn(direction,angle))
		if(istype(T) && !(T in checked) && T.is_flipped == is_flipped && blend_with(T) && !T.recursive_flip_check(direction, checked))
			return FALSE

	return TRUE

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if (!usr.can_touch(src) || ismouse(usr))
		return

	if(!flip(get_cardinal_dir(usr,src), TRUE))
		to_chat(usr, SPAN_WARNING("It won't budge."))
		return

	usr.visible_message(SPAN_WARNING("\The [usr] flips \the [src]!"))

	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		object_shaken()

/obj/structure/table/proc/unflipping_check(var/direction)

	for(var/mob/M in oview(src,0))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(usr, SPAN_WARNING("There's \a [occupied] in the way."))
		return 0

	var/list/L = list()
	if(direction)
		L.Add(direction)
	else
		L.Add(turn(src.dir,-90))
		L.Add(turn(src.dir,90))
	for(var/new_dir in L)
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(blend_with(T) && T.is_flipped && T.dir == dir && !T.unflipping_check(new_dir))
			return FALSE
	return TRUE

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts an upended table back in place."
	set category = "Object"
	set src in oview(1)

	if (!usr.can_touch(src))
		return

	if (!unflipping_check())
		to_chat(usr, SPAN_WARNING("It won't budge."))
		return
	unflip(TRUE)

/obj/structure/table/proc/flip(var/direction, var/first_flip = FALSE)

	if(!recursive_flip_check(direction))
		return FALSE

	if(first_flip && !do_after(usr, 1 SECOND, src))
		return FALSE

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	set_dir(direction)
	if(dir != NORTH)
		layer = ABOVE_HUMAN_LAYER
	atom_flags &= ~ATOM_FLAG_CLIMBABLE //flipping tables allows them to be used as makeshift barriers
	is_flipped = 1
	atom_flags |= ATOM_FLAG_CHECKS_BORDER

	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/T = locate() in get_step(src, D)
		if(blend_with(T) && !T.is_flipped)
			T.flip(direction)

	var/list/targets = list(get_step(src, direction), get_step(src,turn(direction, 45)), get_step(src, turn(direction, -45)))
	for(var/atom/movable/A in get_turf(src))
		if(!A.anchored)
			var/turf/target = pick(targets)
			if(istype(target))
				A.throw_at(target, 1, 1)

	take_damage(rand(5, 10))
	update_connections(TRUE)
	update_icon()

	return TRUE

/obj/structure/table/proc/unflip(var/first_unflip)

	if(first_unflip && !do_after(usr, 1 SECOND, src))
		return FALSE

	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	reset_plane_and_layer()
	atom_flags |= ATOM_FLAG_CLIMBABLE
	is_flipped = FALSE
	atom_flags &= ~ATOM_FLAG_CHECKS_BORDER
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/T = locate() in get_step(src.loc,D)
		if(blend_with(T) && T.is_flipped && T.dir == src.dir)
			T.unflip()

	update_connections(TRUE)
	update_icon()

	return TRUE

/obj/structure/table/CtrlClick()
	if(usr && usr.Adjacent(src))
		if(!is_flipped)
			do_flip()
		else
			do_put()
		return TRUE
	return FALSE

/obj/structure/table/handle_default_wrench_attackby(var/mob/user, var/obj/item/wrench)
	return !reinf_material && ..()

/obj/structure/table/handle_default_welder_attackby(var/mob/user, var/obj/item/weldingtool/welder)
	return !reinf_material && ..()

/obj/structure/table/handle_default_crowbar_attackby(var/mob/user, var/obj/item/crowbar)
	return !reinf_material && ..()

// Table presets.
/obj/structure/table/frame
	icon_state = "frame"
	reinf_material = null

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	reinf_material = /decl/material/solid/stone/marble

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	additional_reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material =                  /decl/material/solid/metal/steel
	reinf_material =            /decl/material/solid/metal/steel
	additional_reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	felted = TRUE
	material =       /decl/material/solid/wood/walnut
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77
	reinf_material = /decl/material/solid/glass

/obj/structure/table/glass/pglass
	color = "#8f29a3"
	reinf_material = /decl/material/solid/glass/borosilicate

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE
	material = /decl/material/solid/metal/aluminium/holographic
	reinf_material = /decl/material/solid/metal/aluminium/holographic

/obj/structure/table/holo_plastictable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE
	material = /decl/material/solid/plastic/holographic
	reinf_material = /decl/material/solid/plastic/holographic

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"

/obj/structure/table/holo_woodentable/Initialize()
	material = /decl/material/solid/wood/holographic
	reinf_material = /decl/material/solid/wood/holographic
	. = ..()

//wood wood wood
/obj/structure/table/woodentable
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/wood
	reinf_material = /decl/material/solid/wood

/obj/structure/table/woodentable/mahogany
	color = WOOD_COLOR_RICH
	material =       /decl/material/solid/wood/mahogany
	reinf_material = /decl/material/solid/wood/mahogany

/obj/structure/table/woodentable/maple
	color = WOOD_COLOR_PALE
	material =       /decl/material/solid/wood/maple
	reinf_material = /decl/material/solid/wood/maple

/obj/structure/table/woodentable/ebony
	color = WOOD_COLOR_BLACK
	material =       /decl/material/solid/wood/ebony
	reinf_material = /decl/material/solid/wood/ebony

/obj/structure/table/woodentable/walnut
	color = WOOD_COLOR_CHOCOLATE
	material =       /decl/material/solid/wood/walnut
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced
	icon_state = "reinf_preview"
	color = WOOD_COLOR_GENERIC
	material =                  /decl/material/solid/wood
	reinf_material =            /decl/material/solid/wood
	additional_reinf_material = /decl/material/solid/wood

/obj/structure/table/woodentable_reinforced/walnut
	color = WOOD_COLOR_CHOCOLATE
	material =                  /decl/material/solid/wood/walnut
	reinf_material =            /decl/material/solid/wood/walnut
	additional_reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced/walnut/maple
	additional_reinf_material = /decl/material/solid/wood/maple

/obj/structure/table/woodentable_reinforced/mahogany
	color = WOOD_COLOR_RICH
	material =                  /decl/material/solid/wood/mahogany
	reinf_material =            /decl/material/solid/wood/mahogany
	additional_reinf_material = /decl/material/solid/wood/mahogany

/obj/structure/table/woodentable_reinforced/mahogany/walnut
	additional_reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced/ebony
	color = WOOD_COLOR_BLACK
	material =                  /decl/material/solid/wood/ebony
	reinf_material =            /decl/material/solid/wood/ebony
	additional_reinf_material = /decl/material/solid/wood/ebony

/obj/structure/table/woodentable_reinforced/ebony/walnut
	additional_reinf_material = /decl/material/solid/wood/walnut
