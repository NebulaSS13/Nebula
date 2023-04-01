/atom
	/// (1 | 2) Determines if this atom is below `1` or above `2` plating. TODO: Use defines.
	var/level = 2
	/// (BITFLAG) See flags.dm
	var/atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	/// (FLOAT) The world.time that this atom last bumped another. Used mostly by mobs.
	var/last_bumped = 0
	/// (BITFLAG) See flags.dm
	var/pass_flags = 0
	/// (BOOL) If a thrown object can continue past this atom. Sometimes used for clicking as well? TODO: Rework this
	var/throwpass = 0
	/// (INTEGER) The number of germs on this atom.
	var/germ_level = GERM_LEVEL_AMBIENT
	/// (BOOL) If an atom should be interacted with by a number of systems (Atmos, Liquids, Turbolifts, Etc.)
	var/simulated = TRUE
	/// The chemical contents of this atom
	var/datum/reagents/reagents
	/// (INTEGER) The amount an explosion's power is decreased when encountering this atom
	var/explosion_resistance = 0
	/// (BOOL) If it can be spawned normally
	var/is_spawnable_type = FALSE


	/// (DICTIONARY) A lazy map. The `key` is a MD5 player name and the `value` is the blood type.
	var/list/blood_DNA
	/// (BOOL) If this atom was bloodied before.
	var/was_bloodied
	/// (COLOR) The color of the blood shown on blood overlays.
	var/blood_color
	/// (1 | 2 | 3) If it shows up under UV light. 0 doesn't, 1 does, 2 is currently glowing due to UV light. TODO: Use defines
	var/fluorescent


	/// (LIST) A list of all mobs that are climbing or currently on this atom
	var/list/climbers
	/// (FLOAT) The climbing speed multiplier for this atom
	var/climb_speed_mult = 1


	/// (FLOAT) The horizontal scaling that should be applied.
	var/icon_scale_x = 1
	/// (FLOAT) The vertical scaling that should be applied.
	var/icon_scale_y = 1
	/// (FLOAT) The angle in degrees clockwise that should be applied.
	var/icon_rotation = 0
	/// (FLOAT) If greater than zero, transform-based adjustments (scaling, rotating) will visually occur over this time.
	var/transform_animate_time = 0

	var/tmp/currently_exploding = FALSE
	var/tmp/default_pixel_x
	var/tmp/default_pixel_y
	var/tmp/default_pixel_z
	var/tmp/default_pixel_w


/**
	Adjust variables prior to Initialize() based on the map

	Called by the maploader to perform static modifications to vars set on the map.
	Intended use case: Adjust tag vars on duplicate templates (such as airlock tags).

	- `map_hash`: A unique string for a map (usually using sequential_id)
*/
/atom/proc/modify_mapped_vars(map_hash)
	SHOULD_CALL_PARENT(TRUE)

/**
	Attempt to merge a gas_mixture `giver` into this atom's gas_mixture

	- Return: `TRUE` if successful, otherwise `FALSE`
*/
/atom/proc/assume_air(datum/gas_mixture/giver)
	return FALSE

/**
	Attempt to remove `amount` moles from this atom's gas_mixture

	- Return: A `/datum/gas_mixture` containing the gas removed if successful, otherwise `null`
*/
/atom/proc/remove_air(amount)
	RETURN_TYPE(/datum/gas_mixture)
	return null

/**
	Get the air of this atom or its location's air

	- Return: The `/datum/gas_mixture` of this atom
*/
/atom/proc/return_air()
	RETURN_TYPE(/datum/gas_mixture)
	return loc?.return_air()

/**
	Get the flags that should be added to the `users` sight var.

	- Return: Sight flags, or `-1` if the view should be reset
	- TODO: Also sometimes handles resetting of view itself, probably should be more consistent.
*/
/atom/proc/check_eye(user)
	if (istype(user, /mob/living/silicon/ai)) // WHY
		return 0
	return -1

/**
	Get sight flags that this atom should provide to a user
	- See: /mob/var/sight
*/
/atom/proc/additional_sight_flags()
	SHOULD_BE_PURE(TRUE)
	return 0

/// Get the level of invisible sight this atom should provide to a user
/atom/proc/additional_see_invisible()
	SHOULD_BE_PURE(TRUE)
	return 0

/// Handle reagents being modified
/atom/proc/on_reagent_change()
	return

/**
	Handle an atom bumping this atom

	Called by `AMs` Bump()

	- `AM`: The atom that bumped us
*/
/atom/proc/Bumped(var/atom/movable/AM)
	return

/**
	Check if an atom can exit this atom's turf.

	- `mover`: The atom trying to move
	- `target`: The turf the atom is trying to move to
	- Return: `TRUE` if it can exit, otherwise `FALSE`
*/
/atom/proc/CheckExit(atom/movable/mover, turf/target)
	SHOULD_BE_PURE(TRUE)
	return TRUE

/**
	Handle an atom entering this atom's proximity

	Called when an atom enters this atom's proximity. Both this and the other atom
	need to have the PROXMOVE flag (as it helps reduce lag).

	- `AM`: The atom entering proximity
	- Return: `TRUE` if proximity should continue to be handled, otherwise `FALSE`
	- TODO: Rename this to `handle_proximity`
*/
/atom/proc/HasProximity(atom/movable/AM)
	SHOULD_CALL_PARENT(TRUE)
	set waitfor = FALSE
	if(!istype(AM))
		PRINT_STACK_TRACE("DEBUG: HasProximity called with [AM] on [src] ([usr]).")
		return FALSE
	return TRUE

/**
	Handle an EMP affecting this atom

	- `severity`: Strength of the explosion ranging from 1 to 3. Higher is weaker
*/
/atom/proc/emp_act(severity)
	return

/**
	Set the density of this atom to `new_density`

	- Events: `density_set` (only if density actually changed)
*/
/atom/proc/set_density(new_density)
	SHOULD_CALL_PARENT(TRUE)
	if(density != new_density)
		density = !!new_density
		RAISE_EVENT(/decl/observ/density_set, src, !density, density)

/**
	Handle a projectile `P` hitting this atom

	- `P`: The `/obj/item/projectile` hitting this atom
	- `def_zone`: The zone `P` is hitting
	- Return: `0 to 100+`, representing the % damage blocked. Can also be special PROJECTILE values (misc.dm)
*/
/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	return 0

/**
	Check if this atom is in the path or atom `container`

	- `container`: The path or atom to check
	- Return: `TRUE` if `container` contains this atom, otherwise `FALSE`
*/
/atom/proc/in_contents_of(container)
	if(ispath(container))
		if(istype(src.loc, container))
			return TRUE
	else if(src in container)
		return TRUE
	return FALSE

/**
	Recursively search this atom's contents for an atom of type `path`

	- `path`: The path of the atom to search for
	- `filter_path?`: A list of atom paths that only should be searched, or `null` to search all
	- Return: A list of atoms of type `path` found inside this atom
*/
/atom/proc/search_contents_for(path, list/filter_path=null)
	RETURN_TYPE(/list)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/**
	Display a description of this atom to a mob.

	Overrides should either return the result of ..() or `TRUE` if not calling it.
	Calls to ..() should generally not supply any arguments and instead rely on
	BYOND's automatic argument passing. There is no need to check the return
	value of ..(), this is only done by the calling `/examinate()` proc to validate
	the call chain.

	- `user`: The mob examining this atom
	- `distance`: The distance this atom is from the `user`
	- `infix`: TODO
	- `suffix`: TODO
	- Return: `TRUE` when the call chain is valid, otherwise `FALSE`
	- Events: `atom_examined`
*/
/atom/proc/examine(mob/user, distance, infix = "", suffix = "")
	SHOULD_CALL_PARENT(TRUE)
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src][infix]."
	if(blood_color && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "<font color ='[blood_color]'>stained</font> [name][infix]!"

	to_chat(user, "[html_icon(src)] That's [f_name] [suffix]")
	to_chat(user, desc)
	RAISE_EVENT(/decl/observ/atom_examined, src, user, distance)
	return TRUE


/**
	Relay movement to this atom.

	Called by mobs, such as when the mob is inside the atom, their buckled
	var is set to this, or this atom is set as their machine.

	- See: code/modules/mob/mob_movement.dm
*/
/atom/proc/relaymove()
	return

/**
	Set the direction of this atom to `new_dir`

	- `new_dir`: The new direction the atom should face.
	- Return: `TRUE` if the direction has been changed.
	- Events: `dir_set`
*/
/atom/proc/set_dir(new_dir)
	SHOULD_CALL_PARENT(TRUE)

	// This attempts to mimic BYOND's handling of diagonal directions and cardinal icon states.
	var/old_dir = dir
	if((atom_flags & ATOM_FLAG_BLOCK_DIAGONAL_FACING) && !IS_POWER_OF_TWO(new_dir))
		if(old_dir & new_dir)
			new_dir = old_dir
		else
			new_dir &= global.adjacentdirs[old_dir]

	. = new_dir != dir
	if(!.)
		return

	dir = new_dir
	if(light_source_solo)
		light_source_solo.source_atom.update_light()
	else if(light_source_multi)
		var/datum/light_source/L
		for(var/thing in light_source_multi)
			L = thing
			if(L.light_angle)
				L.source_atom.update_light()

	RAISE_EVENT(/decl/observ/dir_set, src, old_dir, new_dir)

/// Set the icon_state to `new_icon_state`
/atom/proc/set_icon_state(var/new_icon_state)
	SHOULD_CALL_PARENT(TRUE)
	if(has_extension(src, /datum/extension/base_icon_state))
		var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
		bis.base_icon_state = new_icon_state
		update_icon()
	else
		icon_state = new_icon_state

/**
	Update this atom's icon.

	- Events: `updated_icon`
*/
/atom/proc/update_icon()
	SHOULD_CALL_PARENT(TRUE)
	on_update_icon(arglist(args))
	RAISE_EVENT(/decl/observ/updated_icon, src)

/**
	Update this atom's icon.

	Usually queue_icon_update() or update_icon() should be used instead.
*/
/atom/proc/on_update_icon()
	SHOULD_CALL_PARENT(FALSE) //Don't call the stub plz
	return

/// Return a list of all simulated atoms inside this one.
/atom/proc/get_contained_external_atoms()
	for(var/atom/movable/AM in contents)
		if(!QDELETED(AM) && AM.simulated)
			LAZYADD(., AM)

/// Dump the contents of this atom onto its loc
/atom/proc/dump_contents()
	for(var/thing in get_contained_external_atoms())
		var/atom/movable/AM = thing
		AM.dropInto(loc)
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE

/**
	Handle the destruction of this atom, spilling it's contents by default

	- `skip_qdel`: If calling qdel() on this atom should be skipped.
	- Return: Unknown, feel free to change this
*/
/atom/proc/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(TRUE)
	dump_contents()
	if(!skip_qdel && !QDELETED(src))
		qdel(src)
	. = TRUE

/**
	Attempt to detonate the reagents contained in this atom

	- `severity`: Strength of the explosion ranging from 1 to 3. Higher is weaker
*/
/atom/proc/try_detonate_reagents(var/severity = 3)
	if(reagents)
		for(var/r_type in reagents.reagent_volumes)
			var/decl/material/R = GET_DECL(r_type)
			R.explosion_act(src, severity)

/**
	Handle an explosion of `severity` affecting this atom

	- `severity`: Strength of the explosion ranging from 1 to 3. Higher is weaker
	- Return: `TRUE` if severity is within range and exploding should continue, otherwise `FALSE`
*/
/atom/proc/explosion_act(var/severity)
	SHOULD_CALL_PARENT(TRUE)
	. = !currently_exploding && severity > 0 && severity <= 3
	if(.)
		currently_exploding = TRUE
		if(severity < 3)
			for(var/atom/movable/AM in get_contained_external_atoms())
				AM.explosion_act(severity + 1)
			try_detonate_reagents(severity)
		currently_exploding = FALSE

/**
	Handle a `user` attempting to emag this atom

	- `remaining_charges`: Used for nothing TODO: Fix this
	- `user`: The user attempting to emag this atom
	- `emag_source`: The source of the emag
	- Returns: 1 if successful, -1 if not, NO_EMAG_ACT if it cannot be emaged
*/
/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

/**
	Handle this atom being exposed to fire

	- `air`: The gas_mixture for this loc
	- `exposed_temperature`: The temperature of the air
	- `exposed_volume`: The volume of the air
*/
/atom/proc/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/// Handle this atom being destroyed through melting
/atom/proc/melt()
	return

/**
	Handle this atom being exposed to lava. Calls qdel() by default

	- Returns: `TRUE` if qdel() was called, otherwise `FALSE`
*/
/atom/proc/lava_act()
	visible_message(SPAN_DANGER("\The [src] sizzles and melts away, consumed by the lava!"))
	playsound(src, 'sound/effects/flare.ogg', 100, 3)
	qdel(src)
	. = TRUE

/**
	Handle this atom being hit by a thrown atom

	- `AM`: The atom hitting this atom
	- `TT`: A datum wrapper for a thrown atom, containing important info
*/
/atom/proc/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	SHOULD_CALL_PARENT(TRUE)
	if(isliving(AM))
		var/mob/living/M = AM
		M.apply_damage(TT.speed*5, BRUTE)

/**
	Attempt to add blood to this atom

	If a mob is provided, their blood will be used

	- `M?`: The mob whose blood will be used
	- Returns: TRUE if made bloody, otherwise FALSE
*/
/atom/proc/add_blood(mob/living/carbon/human/M)
	if(atom_flags & ATOM_FLAG_NO_BLOOD)
		return FALSE

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialize it.
		blood_DNA = list()

	was_bloodied = 1
	blood_color = COLOR_BLOOD_HUMAN
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna()
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_color(M)
	return TRUE

/**
	Remove any blood from this atom

	- Return: `TRUE` if blood with DNA was removed
*/
/atom/proc/clean_blood()
	SHOULD_CALL_PARENT(TRUE)
	if(!simulated)
		return
	fluorescent = 0
	germ_level = 0
	blood_color = null
	if(istype(blood_DNA, /list))
		blood_DNA = null
		var/datum/extension/forensic_evidence/forensics = get_extension(src, /datum/extension/forensic_evidence)
		if(forensics)
			forensics.remove_data(/datum/forensics/blood_dna)
			forensics.remove_data(/datum/forensics/gunshot_residue)
		return TRUE

/// Only used by Sandbox_Spacemove, which is used by nothing
/// - TODO: Remove this
/atom/proc/get_global_map_pos()
	if(!islist(global.global_map) || !length(global.global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global.global_map.len,cur_x++)
		y_arr = global.global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	log_debug("X = [cur_x]; Y = [cur_y]")

	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/**
	Check if this atom can be passed by another given the flags provided

	- `pass_flag`: The flags to check. See: flags.dm
	- Return: The flags present that allow it to pass, otherwise `0`
*/
/atom/proc/checkpass(pass_flag)
	SHOULD_BE_PURE(TRUE)
	return pass_flags & pass_flag

/**
	Show a message to all mobs and objects in sight of this atom.

	Used for atoms performing visible actions

	- `message`: The string output to any atom that can see this atom
	- `self_message?`: The string displayed to this atom if it's a mob. See: mobs.dm
	- `blind_message?`: The string blind mobs will see. Example: "You hear something!"
	- `range?`: The number of tiles away the message will be visible from. Default: world.view
	- `check_ghosts?`: Set to `TRUE` if ghosts should see the message if their preferences allow
*/
/atom/proc/visible_message(var/message, var/self_message, var/blind_message, var/range = world.view, var/check_ghosts = null)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T,range, mobs, objs, check_ghosts)

	for(var/o in objs)
		var/obj/O = o
		O.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)

	for(var/m in mobs)
		var/mob/M = m
		if(M.see_invisible >= invisibility)
			M.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
		else if(blind_message)
			M.show_message(blind_message, AUDIBLE_MESSAGE)

/**
	Show a message to all mobs and objects in earshot of this atom

	Used for atoms performing audible actions

	- `message`: The string to show to anyone who can hear this atom
	- `dead_message?`: The string deaf mobs will see
	- `hearing_distance?`: The number of tiles away the message can be heard. Defaults to world.view
	- `check_ghosts?`: TRUE if ghosts should hear the message if their preferences allow
	- `radio_message?`: The string to send over radios
*/
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance = world.view, var/check_ghosts = null, var/radio_message)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, hearing_distance, mobs, objs, check_ghosts)

	for(var/m in mobs)
		var/mob/M = m
		M.show_message(message,2,deaf_message,1)
	for(var/o in objs)
		var/obj/O = o
		O.show_message(message,2,deaf_message,1)

/**
	Attempt to drop this atom onto the destination.

	The destination can instead return another location, recursively chaining.

	- `destination`: The atom that this atom is dropped onto.
	- Return: The result of the forceMove() at the end.
*/
/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/**
	Handle dropping an atom onto this atom.

	If the item should move into this atom, return null. Otherwise, return
	the destination atom where the item should be moved.

	- `AM`: The atom being dropped onto this atom
	- Return: A location for the atom AM to move to, or null to move it into this atom.
*/
/atom/proc/onDropInto(var/atom/movable/AM)
	RETURN_TYPE(/atom)
	return

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc

/**
	Handle this atom being hit by a grab.

	Called by resolve_attackby()

	- `G`: The grab hitting this atom
	- Return: `TRUE` to skip attackby() and afterattack() or `FALSE`
*/
/atom/proc/grab_attack(var/obj/item/grab/G)
	return FALSE

/atom/proc/climb_on()

	set name = "Climb"
	set desc = "Climbs onto an object."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/**
	Check if a user can climb this atom.

	- `user`: The mob to check
	- `post_climb_check?`: If we should check if the user can continue climbing
	- Return: `TRUE` if they can climb, otherwise `FALSE`
*/
/atom/proc/can_climb(var/mob/living/user, post_climb_check=0)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !user.can_touch(src) || (!post_climb_check && climbers && (user in climbers)))
		return FALSE

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return FALSE

	var/obj/occupied = turf_is_crowded(user)
	if(occupied)
		to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
		return FALSE
	return TRUE

/**
	Check if this atom's turf is blocked.

	This doesn't handle border structures and should be preceded by an Adjacent() check.
	- `ignore?`: An atom that should be ignored by the check.
	- Return: The first atom blocking this atom's turf.
*/
/atom/proc/turf_is_crowded(var/atom/ignore)
	RETURN_TYPE(/atom)
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/atom/A in T.contents)
		if(ignore && ignore == A)
			continue
		if(A.atom_flags & ATOM_FLAG_CLIMBABLE)
			continue
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return A
	return 0

/**
	Handle `user` climbing onto this atom.

	- `user`: The mob climbing onto this atom.
	- Return: `TRUE` if the user successfully climbs onto this atom, otherwise `FALSE`.
*/
/atom/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return FALSE

	add_fingerprint(user)
	user.visible_message("<span class='warning'>\The [user] starts climbing onto \the [src]!</span>")
	LAZYDISTINCTADD(climbers,user)

	if(!do_after(user,(issmall(user) ? MOB_CLIMB_TIME_SMALL : MOB_CLIMB_TIME_MEDIUM) * climb_speed_mult, src))
		LAZYREMOVE(climbers,user)
		return FALSE

	if(!can_climb(user, post_climb_check=1))
		LAZYREMOVE(climbers,user)
		return FALSE

	var/target_turf = get_turf(src)

	//climbing over border objects like railings
	if((atom_flags & ATOM_FLAG_CHECKS_BORDER) && get_turf(user) == target_turf)
		target_turf = get_step(src, dir)

	user.forceMove(target_turf)

	if (get_turf(user) == target_turf)
		user.visible_message("<span class='warning'>\The [user] climbs onto \the [src]!</span>")
	LAZYREMOVE(climbers,user)
	return TRUE

/// Shake this atom and all it's climbers.
/atom/proc/object_shaken()
	for(var/mob/living/M in climbers)
		SET_STATUS_MAX(M, STAT_WEAK, 1)
		to_chat(M, "<span class='danger'>You topple as you are shaken off \the [src]!</span>")
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		SET_STATUS_MAX(M, STAT_WEAK, 3)
		to_chat(M, "<span class='danger'>You topple as \the [src] moves under you!</span>")

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting = pick(H.get_external_organs())
			if(affecting)
				to_chat(M, "<span class='danger'>You land heavily on your [affecting.name]!</span>")
				affecting.take_external_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/// Get the current color of this atom.
/atom/proc/get_color()
	return color

/// Set the color of this atom to `new_color`.
/atom/proc/set_color(new_color)
	color = new_color

/// Get any power cell associated with this atom.
/atom/proc/get_cell()
	RETURN_TYPE(/obj/item/cell)
	return

/**
	Get any radio associated with this atom.

	Used for handle_message_mode or other radio-based logic.
	- `message_mode?`: Used to determine what subset of radio should be returned (ie. intercoms or ear radios)
	- Return: A radio appropriate for `message_mode`.
*/
/atom/proc/get_radio(var/message_mode)
	RETURN_TYPE(/obj/item/radio)
	return

/**
	Get the material cost of this atom.

	- Return: An dictionary where key is the material and value is the amount.
*/
/atom/proc/building_cost()
	RETURN_TYPE(/list)
	. = list()

/atom/Topic(href, href_list)
	var/mob/user = usr
	if(href_list["look_at_me"] && istype(user))
		var/turf/T = get_turf(src)
		if(T.CanUseTopic(user, global.view_topic_state) != STATUS_CLOSE)
			user.examinate(src)
			return TOPIC_HANDLED
	. = ..()

/// Get the temperature of this atom's heat source
/atom/proc/get_heat()
	. = temperature

/// Check if this atom is a source of fire
/atom/proc/isflamesource()
	. = FALSE

// === Transform setters. ===

/**
	Set the rotation of this atom's transform

	- `new_rotation`: The angle in degrees the transform will be rotated clockwise
*/
/atom/proc/set_rotation(new_rotation)
	icon_rotation = new_rotation
	update_transform()

/**
	Set the scale of this atom's transform.

	- `new_scale_x`: The multiplier to apply to the X axis
	- `new_scale_y`: The multiplier to apply to the Y axis
*/
/atom/proc/set_scale(new_scale_x, new_scale_y)
	if(isnull(new_scale_y))
		new_scale_y = new_scale_x
	if(new_scale_x != 0)
		icon_scale_x = new_scale_x
	if(new_scale_y != 0)
		icon_scale_y = new_scale_y
	update_transform()

/**
	Update this atom's transform from stored values.

	Applies icon_scale and icon_rotation. When transform_animate_time is set,
	the transform is animated over the specified duration. Otherwise, it is
	applied instantly.

	- Return: The transform `/matrix` after updates are applied
*/
/atom/proc/update_transform()
	RETURN_TYPE(/matrix)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	if(transform_animate_time)
		animate(src, transform = M, transform_animate_time)
	else
		transform = M
	return transform

/// Get the first loc of the specified `loc_type` from walking up the loc tree of this atom.
/atom/get_recursive_loc_of_type(var/loc_type)
	RETURN_TYPE(/atom)
	var/atom/check_loc = loc
	while(check_loc)
		if(istype(check_loc, loc_type))
			return check_loc
		check_loc = check_loc.loc

/**
	Get a list of alt interactions for a user from this atom.

	- `user`: The mob that these alt interactions are for
	- Return: A list containing the alt interactions
*/
/atom/proc/get_alt_interactions(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	return list()

/atom/proc/can_climb_from_below(var/mob/climber)
	return FALSE

/atom/proc/singularity_act()
	return 0

/atom/proc/singularity_pull(S, current_size)
	return

/atom/proc/on_defilement()
	return
