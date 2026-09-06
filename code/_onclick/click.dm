/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(var/location, var/control, var/params) // This is their reaction to being clicked on (standard proc)
	var/list/L = params2list(params)
	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return

	var/datum/click_handler/click_handler = usr.GetClickHandler()
	click_handler.OnClick(src, params)

/atom/DblClick(var/location, var/control, var/params)
	var/datum/click_handler/click_handler = usr.GetClickHandler()
	click_handler.OnDblClick(src, params)

/atom/proc/allow_click_through(var/atom/A, var/params, var/mob/user)
	return FALSE

/turf/allow_click_through(var/atom/A, var/params, var/mob/user)
	return TRUE

/*
	Standard mob ClickOn()
	Handles exceptions: middle click, modified clicks, exosuit actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is receiving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(used_item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(var/atom/A, var/params)

	if(world.time <= next_click) // Hard check, before anything else, to avoid crashing
		return

	next_click = world.time + 1

	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		RightClickOn(A)
		return 1
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return 1
	if(modifiers["ctrl"] && modifiers["alt"])
		CtrlAltClickOn(A)
		return 1
	if(modifiers["middle"] && modifiers["alt"])
		AltMiddleClickOn(A)
		return 1
	if(modifiers["middle"])
		MiddleClickOn(A)
		return 1
	if(modifiers["shift"])
		ShiftClickOn(A)
		return 0
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return 1
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return 1

	if(incapacitated(INCAPACITATION_KNOCKOUT))
		return

	// Do not allow player facing change in fixed chairs
	if(!istype(buckled) || buckled.buckle_movable || buckled.buckle_allow_rotation)
		face_atom(A) // change direction to face what you clicked on

	if(!canClick()) // in the year 2000...
		return

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode)
		if(isturf(A) || isturf(A.loc))
			mob_throw_item(A)
			trigger_aiming(TARGET_CAN_CLICK)
			return 1
		toggle_throw_mode(FALSE)

	var/obj/item/holding = get_active_held_item()

	if(holding == A) // Handle attack_self
		holding.attack_self(src)
		trigger_aiming(TARGET_CAN_CLICK)
		update_inhand_overlays(FALSE)
		return 1

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(holding)
			var/resolved = holding.resolve_attackby(A, src, params)
			if(!resolved && A && holding)
				holding.afterattack(A, src, 1, params) // 1 indicates adjacency
			setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			UnarmedAttack(A, TRUE)

		trigger_aiming(TARGET_CAN_CLICK)
		return 1

	if(!loc.allow_click_through(A, params, src)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(holding)

				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = holding.resolve_attackby(A, src, params)
				if(!resolved && A && holding)
					holding.afterattack(A, src, 1, params) // 1: clicking something Adjacent
				setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_QUICK_COOLDOWN)
				UnarmedAttack(A, TRUE)

			trigger_aiming(TARGET_CAN_CLICK)
			return
		else // non-adjacent click
			if(holding)
				holding.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				RangedAttack(A, params)

			trigger_aiming(TARGET_CAN_CLICK)
	return 1

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(get_config_value(/decl/config/toggle/no_click_cooldown) || next_move <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(var/atom/A, var/params)
	if(get_preference_value(/datum/client_preference/show_turf_contents) == PREF_DOUBLE_CLICK)
		. = A.show_atom_list_for_turf(src, get_turf(A))

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.

	Returns TRUE if no further processing is desired, FALSE otherwise.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/// Handles per-mob unarmed attack functionality after shared checks, e.g. maneuvers and abilities.
/mob/living/proc/ResolveUnarmedAttack(var/atom/A)
	return A.attack_hand(src)

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(src, "You cannot attack people before the game has started.")
		return TRUE

	if(stat || try_maneuver(A) || !proximity_flag)
		return TRUE

	// Handle any prepared ability/spell/power invocations.
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(abilities?.do_melee_invocation(A))
		return TRUE

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = get_equipped_item(slot_gloves_str)
	if(istype(G) && G.Touch(A, proximity_flag))
		return TRUE

	return ResolveUnarmedAttack(A)

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	return FALSE

/mob/living/RangedAttack(var/atom/A, var/params)
	if(try_maneuver(A))
		return TRUE

	// Handle any prepared ability/spell/power invocations.
	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	if(abilities?.do_ranged_invocation(A))
		return TRUE

	if(A.attack_hand_ranged(src))
		return TRUE

	return FALSE

/*
	Restrained ClickOn

	Used when you are cuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	swap_hand()

/mob/proc/AltMiddleClickOn(var/atom/A)
	pointed(A)

// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		user.examine_verb(src)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	return A.CtrlClick(src)

/atom/proc/CtrlClick(var/mob/user)
	if(get_recursive_loc_of_type(/mob) == user)
		var/decl/interaction_handler/handler = get_quick_interaction_handler(user)
		if(handler)
			var/using_item = user.get_active_held_item()
			if(handler.is_possible(src, user, using_item))
				return handler.invoked(src, user, using_item)
	return FALSE

/atom/movable/CtrlClick(var/mob/living/user)
	if(!(. = ..()) && loc != user)
		return try_make_grab(user, defer_hand = TRUE) || ..()

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)

/atom/proc/AltClick(var/mob/user)
	if(try_handle_interactions(user, get_alt_interactions(user), user?.get_active_held_item(), check_alt_interactions = TRUE))
		return TRUE
	if(user?.get_preference_value(/datum/client_preference/show_turf_contents) == PREF_ALT_CLICK)
		. = show_atom_list_for_turf(user, get_turf(src))

/atom/proc/show_atom_list_for_turf(var/mob/user, var/turf/T)
	if(T && user.TurfAdjacent(T))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = "Turf"
	. = TRUE

/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/mob/observer/ghost/TurfAdjacent(var/turf/T)
	if(!isturf(loc) || !client)
		return FALSE
	return z == T.z && (get_dist(loc, T) <= get_effective_view(client))

/mob/proc/RightClickOn(atom/A)
	A.RightClick(src)
	return

/atom/proc/RightClick(mob/user)
	return

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/*
	Control+Alt click
*/
/mob/proc/CtrlAltClickOn(var/atom/A)
	A.CtrlAltClick(src)
	return

/atom/proc/CtrlAltClick(var/mob/user)
	return

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		if(facing_dir)
			facing_dir = direction
		facedir(direction)
