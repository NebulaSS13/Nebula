/obj/item
	/// world.time when the wielder started clicking and holding with this item active.
	VAR_PRIVATE/_charge_started_charging
	/// "x","y" assoc list indicating a turf offset from the user when they started clicking and holding.
	VAR_PRIVATE/list/_charge_started_charging_relative_position
	/// First non-origin turf encountered while charging.
	VAR_PRIVATE/list/_charge_first_offset_turf_position

	var/const/ATTACK_NOT_CHARGING = 0
	var/const/ATTACK_CHARGING     = 1
	var/const/ATTACK_CHARGED      = 2

/obj/item/proc/get_melee_attack_profiles(mob/user)
	return null

/obj/item/proc/is_charging_attack()
	if(isnull(_charge_started_charging))
		return ATTACK_NOT_CHARGING
	if(world.time >= (_charge_started_charging + 1 SECOND))
		return ATTACK_CHARGED
	return ATTACK_CHARGING

/obj/item/proc/get_melee_direction_indicator_turf()
	if(!_charge_first_offset_turf_position)
		return null
	var/turf/holder_loc = get_turf(src)
	return locate(
		holder_loc.x + _charge_first_offset_turf_position["x"],
		holder_loc.y + _charge_first_offset_turf_position["y"],
		holder_loc.z
	)

// Called on initial mouse down event from wielding mob. Return TRUE to begin processing every 1ds.
/obj/item/proc/wielder_mouse_drag_down(mob/user, object, location, control, params)

	if(object && user && user.check_intent(I_FLAG_HARM) && length(get_melee_attack_profiles()))
		_charge_started_charging = world.time
		var/turf/holder_loc = get_turf(src)
		var/turf/drag_loc   = get_turf(object)
		if(istype(holder_loc) && istype(drag_loc))
			_charge_started_charging_relative_position = list(
				"x" = drag_loc.x - holder_loc.x,
				"y" = drag_loc.y - holder_loc.y
			)
			return TRUE
	_charge_started_charging                   = null
	_charge_started_charging_relative_position = null
	_charge_first_offset_turf_position         = null
	return FALSE

// Called every 1ds while mouse is down with an item that returned TRUE to wielder_mouse_drag_down(). Return FALSE to end processing.
/obj/item/proc/wielder_mouse_drag_held(mob/user, atom/target)

	if(!target || !user || !user.check_intent(I_FLAG_HARM) || !length(get_melee_attack_profiles(user)))
		_charge_started_charging                   = null
		_charge_first_offset_turf_position         = null
		_charge_started_charging_relative_position = null
		return FALSE

	if(isnull(_charge_started_charging) || !isturf(user.loc) || (!isturf(target) && !isturf(target.loc)))
		return FALSE

	// This block of nonsense is for determining the direction of the strike in
	// general terms, largely for use in deciding which way a sweep should flow.
	var/turf/over_loc = get_turf(target)
	if(isnull(_charge_first_offset_turf_position) && _charge_started_charging_relative_position)
		var/turf/holder_loc = get_turf(user)
		var/offset_x = over_loc.x - holder_loc.x
		var/offset_y = over_loc.y - holder_loc.y
		if(offset_x != _charge_started_charging_relative_position["x"] || offset_y != _charge_started_charging_relative_position["y"])
			_charge_first_offset_turf_position = list(
				"x" = offset_x,
				"y" = offset_y
			)
	user.set_dir(get_dir(user.loc, over_loc))
	return TRUE

// Called on mouse up event from wielding mob.
/obj/item/proc/wielder_mouse_drag_up(mob/user, atom/target)
	. = FALSE
	if(target && user && user.check_intent(I_FLAG_HARM) && _charge_started_charging_relative_position)
		var/turf/holder_loc = get_turf(src)
		if(istype(holder_loc))
			var/list/attack_profiles = get_melee_attack_profiles(user)
			if(length(attack_profiles))
				var/turf/origin_loc = locate(holder_loc.x + _charge_started_charging_relative_position["x"], holder_loc.y + _charge_started_charging_relative_position["y"], holder_loc.z)
				var/turf/target_loc = get_turf(target)
				if(istype(origin_loc) && istype(target_loc))
					for(var/decl/melee_attack_profile/attack as anything in attack_profiles)
						if(attack.perform_attack(user, src, origin_loc, target_loc))
							. = TRUE
							break
	_charge_started_charging                   = null
	_charge_first_offset_turf_position         = null
	_charge_started_charging_relative_position = null
