/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()	

/mob/living/simple_animal/hostile/can_direct_mount(mob/user)
	return user?.faction == faction && ..()

/mob/living/simple_animal/hostile/retaliate/Destroy()
	LAZYCLEARLIST(enemies)
	return ..()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= weakref(L)

/mob/living/simple_animal/hostile/retaliate/ListTargets(var/dist = 7)
	if(!length(enemies))
		return
	. = ..()
	if(length(.))
		var/list/filtered_enemies = list()
		for(var/weakref/enemy in enemies) // Remove all entries that aren't in enemies
			var/M = enemy.resolve()
			if(M in .)
				filtered_enemies += M
		. = filtered_enemies

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	var/list/around = view(src, 7)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!attack_same && M.faction != faction)
				enemies |= weakref(M)

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(!attack_same && !H.attack_same && H.faction == faction)
			H.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/adjustBruteLoss(var/damage, var/do_update_health = FALSE)
	..()
	Retaliate()

/mob/living/simple_animal/hostile/retaliate/buckle_mob(mob/living/M)
	. = ..()
	Retaliate()

/mob/living/simple_animal/hostile/retaliate/try_make_grab(mob/living/user, defer_hand = FALSE)
	. = ..()
	Retaliate()
