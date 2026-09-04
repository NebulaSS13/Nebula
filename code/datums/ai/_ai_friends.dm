/datum/mob_controller/proc/pacify(mob/user)
	lose_target()
	add_friend(user)

// Friend tracking - used on /aggressive.
/datum/mob_controller/proc/get_friends()
	return _friends

/datum/mob_controller/proc/add_friend(mob/friend)
	if(istype(friend))
		LAZYDISTINCTADD(_friends, weakref(friend))
		return TRUE
	return FALSE

/datum/mob_controller/proc/remove_friend(mob/friend)
	LAZYREMOVE(_friends, weakref(friend))

/datum/mob_controller/proc/set_friends(list/new_friends)
	_friends = new_friends

/datum/mob_controller/proc/is_friend(mob/friend)
	. = istype(friend) && LAZYLEN(_friends) && (weakref(friend) in _friends)

/datum/mob_controller/proc/clear_friends()
	LAZYCLEARLIST(_friends)
