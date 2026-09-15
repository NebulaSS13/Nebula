/datum/mob_controller
	/// Who are we friends with? Lazylist of weakrefs.
	var/list/_friends
	/// What special role are we friendly with?
	var/decl/special_role/friendly_to_role = null

/datum/mob_controller/proc/pacify(mob/user)
	lose_target()
	add_friend(user)
	ai_flags &= ~AI_FLAG_ATTACKS_FACTION
	friendly_to_role = null

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

/datum/mob_controller/proc/handle_friendly_proximity(mob/living/friend, friend_is_hurt)
	return

/datum/mob_controller/proc/is_in_faction(mob/friend)
	// Cannibalistic mobs don't care at all.
	if(ai_flags & AI_FLAG_ATTACKS_FACTION)
		return FALSE
	// Special role check overrides faction check.
	if(istype(friendly_to_role) && friend.mind && friendly_to_role.is_antagonist(friend.mind))
		return TRUE
	return (friend.faction == body.faction)
