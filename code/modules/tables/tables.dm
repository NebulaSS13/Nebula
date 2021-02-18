/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = 1
	anchored = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = TABLE_LAYER
	throwpass = 1
	mob_offset = 12
	handle_generic_blending = TRUE
	maxhealth = 10

	var/flipped = 0

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1
	var/manipulating = 0

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0

	var/list/connections = list("nw0", "ne0", "sw0", "se0")
	var/list/other_connections

/obj/structure/table/clear_connections()
	connections = null
	other_connections = null

/obj/structure/table/set_connections(dirs, other_dirs)
	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)

/obj/structure/table/Initialize()
	. = ..()
	for(var/obj/structure/table/T in loc)
		if(T != src)
			break_to_parts(full_return = 1)
			return
	if(. != INITIALIZE_HINT_QDEL)
		. = INITIALIZE_HINT_LATELOAD

// We do this because need to make sure adjacent tables init their material before we try and merge.
/obj/structure/table/LateInitialize()
	..()
	update_connections(1)
	update_icon()
	update_desc()

/obj/structure/table/get_material_health_modifier()
	. = 0.5

/obj/structure/table/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	visible_message(SPAN_DANGER("\The [src] breaks down!"))
	. = break_to_parts()

/obj/structure/table/Destroy()
	material = null
	reinf_material = null
	update_connections(1) // Update tables around us to ignore us (material=null forces no connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_icon()
	. = ..()

/obj/structure/table/attackby(obj/item/W, mob/user)

	if(reinf_material && isScrewdriver(W))
		remove_reinforced(W, user)
		if(!reinf_material)
			update_desc()
			update_icon()
			update_materials()
		return 1

	if(carpeted && isCrowbar(W))
		user.visible_message("<span class='notice'>\The [user] removes the carpet from \the [src].</span>",
		                              "<span class='notice'>You remove the carpet from \the [src].</span>")
		new /obj/item/stack/tile/carpet(loc)
		carpeted = 0
		update_icon()
		return 1

	if(!carpeted && material && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message("<span class='notice'>\The [user] adds \the [C] to \the [src].</span>",
			                              "<span class='notice'>You add \the [C] to \the [src].</span>")
			carpeted = 1
			update_icon()
			return 1
		else
			to_chat(user, "<span class='warning'>You don't have enough carpet!</span>")

	if(!reinf_material && !carpeted && material && isWrench(W) && user.a_intent == I_HURT) //robots dont have disarm so it's harm
		remove_material(W, user)
		if(!material)
			update_connections(1)
			update_icon()
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_icon()
			update_desc()
			update_materials()
		return 1

	if(!carpeted && !reinf_material && !material && isWrench(W) && user.a_intent == I_HURT)
		if(manipulating)
			return
		manipulating = TRUE
		user.visible_message(SPAN_NOTICE("\The [user] begins dismantling \the [src]."))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(!do_after(user, 20, src))
			manipulating = FALSE
			return
		user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."))
		dismantle()
		return 1

	if(!material && can_plate && istype(W, /obj/item/stack/material))
		material = common_material_add(W, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
			update_materials()
		return 1
	if(istype(W, /obj/item/hand)) //playing cards
		var/obj/item/hand/H = W
		if(H.cards && H.cards.len == 1)
			usr.visible_message("\The [user] plays \the [H.cards[1].name].")

	if(istype(W, /obj/item/deck)) //playing cards
		if(user.a_intent == I_GRAB)
			var/obj/item/deck/D = W
			if(!D.cards.len)
				to_chat(user, "There are no cards in the deck.")
				return
			D.deal_at(user, src)
			return

	return ..()

/obj/structure/table/receive_mouse_drop(atom/dropping, mob/living/user)
	. = ..()
	if(!. && can_reinforce && user.get_active_hand() == dropping)
		reinforce_table(dropping, user)
		return TRUE

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinf_material)
		to_chat(user, "<span class='warning'>\The [src] is already reinforced!</span>")
		return

	if(!can_reinforce)
		to_chat(user, "<span class='warning'>\The [src] cannot be reinforced!</span>")
		return

	if(!material)
		to_chat(user, "<span class='warning'>Plate \the [src] before reinforcing it!</span>")
		return

	if(flipped)
		to_chat(user, "<span class='warning'>Put \the [src] back in place before reinforcing it!</span>")
		return

	reinf_material = common_material_add(S, user, "reinforc")
	if(reinf_material)
		update_materials()

/obj/structure/table/proc/update_desc()
	if(material)
		name = "[material.solid_name] table"
	else
		name = "table frame"

	if(reinf_material)
		name = "reinforced [name]"
		desc = "[initial(desc)] This one seems to be reinforced with [reinf_material.solid_name]."
	else
		desc = initial(desc)

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/decl/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>")
		return null

	if(manipulating) return M
	manipulating = 1
	to_chat(user, "<span class='notice'>You begin [verb]ing \the [src] with [M.solid_name].</span>")
	if(!do_after(user, 20, src) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.solid_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, decl/material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, "<span class='warning'>You are unable to remove the [what] from this table!</span>")
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins removing the [type_holding] holding \the [src]'s [M.solid_name] [what] in place.</span>",
	                              "<span class='notice'>You begin removing the [type_holding] holding \the [src]'s [M.solid_name] [what] in place.</span>")
	if(sound)
		playsound(src.loc, sound, 50, 1)
	if(!do_after(user, 40, src))
		manipulating = 0
		return M
	user.visible_message("<span class='notice'>\The [user] removes the [M.solid_name] [what] from \the [src].</span>",
	                              "<span class='notice'>You remove the [M.solid_name] [what] from \the [src].</span>")
	M.place_sheet(src.loc)
	manipulating = 0
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/screwdriver/S, mob/user)
	reinf_material = common_material_remove(user, reinf_material, 40, "reinforcements", "screws", 'sound/items/Screwdriver.ogg')

/obj/structure/table/proc/remove_material(obj/item/wrench/W, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts", 'sound/items/Ratchet.ogg')

// Returns a list of /obj/item/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	reset_mobs_offset()
	var/list/shards = list()
	var/obj/item/shard/S = null
	if(reinf_material)
		if(reinf_material.stack_type && (full_return || prob(20)))
			reinf_material.place_sheet(loc)
		else
			S = reinf_material.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/decl/material/M = GET_DECL(/decl/material/solid/metal/steel)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/table/on_update_icon()
	color = "#ffffff"
	alpha = 255
	if(!flipped)
		mob_offset = initial(mob_offset)
		icon_state = "blank"
		overlays.Cut()
		var/image/I
		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			I = image(icon, dir = 1<<(i-1), icon_state = connections ? connections[i] : "0")
			overlays += I
		// Standard table image
		if(material)
			for(var/i = 1 to 4)
				I = image(icon, "[material.table_icon_base]_[connections ? connections[i] : "0"]", dir = 1<<(i-1))
				if(material.color) I.color = material.color
				I.alpha = 255 * material.opacity
				overlays += I
		// Reinforcements
		if(reinf_material)
			for(var/i = 1 to 4)
				I = image(icon, "[reinf_material.table_reinf]_[connections ? connections[i] : "0"]", dir = 1<<(i-1))
				I.color = reinf_material.color
				I.alpha = 255 * reinf_material.opacity
				overlays += I
		if(carpeted)
			for(var/i = 1 to 4)
				I = image(icon, "carpet_[connections ? connections[i] : "0"]", dir = 1<<(i-1))
				overlays += I
	else
		mob_offset = 0
		overlays.Cut()
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && istype(material) && istype(T.material) && T.material.type == material.type)
				type++
				tabledirs |= direction
		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"
		icon_state = "flip[type]"
		if(material)
			var/image/I = image(icon, "[material.table_icon_base]_flip[type]")
			I.color = material.color
			I.alpha = 255 * material.opacity
			overlays += I
			name = "[material.solid_name] table"
		else
			name = "table frame"
		if(reinf_material)
			var/image/I = image(icon, "[reinf_material.table_reinf]_flip[type]")
			I.color = reinf_material.color
			I.alpha = 255 * reinf_material.opacity
			overlays += I
		if(carpeted)
			overlays += "carpet_flip[type]"

/obj/structure/table/proc/can_connect()
	return TRUE

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")

		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections()
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
			if(W.is_fulltile() || W.dir == GLOB.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || (W.dir & GLOB.reverse_dir[D]))
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in orange(src, 1))
		if(!T.can_connect()) continue
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(material && T.material && material.type == T.material.type && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)

#define CORNER_NONE             0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL         2
#define CORNER_CLOCKWISE        4
// Aquarium-specific corners (due to ordering requirements)
#define CORNER_EASTWEST         CORNER_COUNTERCLOCKWISE
#define CORNER_NORTHSOUTH       CORNER_CLOCKWISE

/*
	turn() is weird:
		turn(icon, angle) turns icon by angle degrees clockwise
		turn(matrix, angle) turns matrix by angle degrees clockwise
		turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

// Similar to dirs_to_corner_states(), but returns an *ordered* list, requiring (in order), dir=NORTH, SOUTH, EAST, WEST
// Note that this means this proc can be used as:

//	var/list/corner_states = dirs_to_unified_corner_states(directions)
//	for(var/index = 1 to 4)
//		var/image/I = image(icon, icon_state = corner_states[index], dir = 1 << (index - 1))
//		[...]

/proc/dirs_to_unified_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/NE = CORNER_NONE
	var/NW = CORNER_NONE
	var/SE = CORNER_NONE
	var/SW = CORNER_NONE

	if(NORTH in dirs)
		NE |= CORNER_NORTHSOUTH
		NW |= CORNER_NORTHSOUTH
	if(SOUTH in dirs)
		SW |= CORNER_NORTHSOUTH
		SE |= CORNER_NORTHSOUTH
	if(EAST in dirs)
		SE |= CORNER_EASTWEST
		NE |= CORNER_EASTWEST
	if(WEST in dirs)
		NW |= CORNER_EASTWEST
		SW |= CORNER_EASTWEST
	if(NORTHWEST in dirs)
		NW |= CORNER_DIAGONAL
	if(NORTHEAST in dirs)
		NE |= CORNER_DIAGONAL
	if(SOUTHEAST in dirs)
		SE |= CORNER_DIAGONAL
	if(SOUTHWEST in dirs)
		SW |= CORNER_DIAGONAL

	return list("[NE]", "[NW]", "[SE]", "[SW]")

#undef CORNER_NONE

#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_CLOCKWISE
#undef CORNER_EASTWEST
#undef CORNER_DIAGONAL
#undef CORNER_NORTHSOUTH