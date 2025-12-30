// Enemy tracking - used on /aggressive
/datum/mob_controller/proc/get_enemies()
	return _enemies

/datum/mob_controller/proc/add_enemy(mob/enemy)
	if(istype(enemy))
		LAZYDISTINCTADD(_enemies, weakref(enemy))

/datum/mob_controller/proc/add_enemies(list/enemies)
	for(var/thing in enemies)
		if(ismob(thing))
			add_friend(thing)
		else if(istype(thing, /weakref))
			LAZYDISTINCTADD(_enemies, thing)

/datum/mob_controller/proc/remove_enemy(mob/enemy)
	LAZYREMOVE(_enemies, weakref(enemy))

/datum/mob_controller/proc/set_enemies(list/new_enemies)
	_enemies = new_enemies

/datum/mob_controller/proc/is_enemy(mob/enemy)
	. = istype(enemy) && LAZYLEN(_enemies) && (weakref(enemy) in _enemies)

/datum/mob_controller/proc/clear_enemies()
	LAZYCLEARLIST(_enemies)

/datum/mob_controller/proc/retaliate(atom/source)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(body) || body.stat == DEAD)
		return FALSE
	startle()
	if(isliving(source))
		remove_friend(source)
	return TRUE
