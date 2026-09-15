/datum/mob_controller
	/// Who are our sworn enemies? Lazylist of weakrefs.
	var/list/_enemies
	// A message to show when retaliating in retaliate()
	var/retaliate_str

// Enemy tracking - used on /aggressive
/datum/mob_controller/proc/get_enemies()
	return _enemies

/datum/mob_controller/proc/add_enemy(mob/enemy)
	if(istype(enemy))
		LAZYDISTINCTADD(_enemies, weakref(enemy))
	else
		LAZYDISTINCTADD(_enemies, enemy)

/datum/mob_controller/proc/add_enemies(list/enemies)
	for(var/thing in enemies)
		add_enemy(thing)

/datum/mob_controller/proc/remove_enemy(mob/enemy)
	if(istype(enemy))
		LAZYREMOVE(_enemies, weakref(enemy))
	else
		LAZYREMOVE(_enemies, enemy)

/datum/mob_controller/proc/set_enemies(list/new_enemies)
	_enemies = new_enemies

/datum/mob_controller/proc/is_enemy(mob/enemy)
	. = istype(enemy) && LAZYLEN(_enemies) && (("everyone" in _enemies) || (weakref(enemy) in _enemies))

/datum/mob_controller/proc/clear_enemies()
	LAZYCLEARLIST(_enemies)

/datum/mob_controller/proc/retaliate(atom/source)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(body) || body.stat == DEAD)
		return FALSE
	startle()
	source = source || get_turf(body)
	if(isliving(source))
		remove_friend(source)

	if(!(ai_flags & AI_FLAG_AGGRESSIVE))
		if(source && (ai_flags & AI_FLAG_COWARD))
			set_flee_target(source)
			set_stance(/decl/mob_controller_stance/fleeing)
		return TRUE

	if(ai_flags & AI_FLAG_ATTACKS_ENEMIES)
		var/list/allies
		var/list/around = view(body, 7)
		for(var/atom/movable/A in around)
			if(A == body || !isliving(A))
				continue
			var/mob/living/M = A
			if(is_in_faction(M))
				if(istype(M.ai))
					LAZYADD(allies, M.ai)
			else
				add_enemy(M)
		var/list/enemies = get_enemies()
		if(LAZYLEN(enemies) && LAZYLEN(allies))
			for(var/datum/mob_controller/ally as anything in allies)
				ally.add_enemies(enemies)

	if(source)
		set_target(source)
		set_stance(/decl/mob_controller_stance/attack)
		if(retaliate_str)
			body.visible_message(REPLACE_EMOTE_TOKENS(retaliate_str, body, source))
	return TRUE


