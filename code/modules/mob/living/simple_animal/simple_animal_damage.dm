/mob/living/simple_animal
	var/brute_damage = 0
	var/burn_damage  = 0
	/// Set to -1 to disable gene damage for the mob.
	var/gene_damage  = 0

/mob/living/simple_animal/getFireLoss()
	return burn_damage

/mob/living/simple_animal/getBruteLoss()
	return brute_damage

/mob/living/simple_animal/getCloneLoss()
	. = max(0, gene_damage)

/mob/living/simple_animal/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	set_damage(CLONE, gene_damage + amount)
	if(do_update_health)
		update_health()

/mob/living/simple_animal/setCloneLoss(amount)
	if(gene_damage >= 0)
		var/current_max_health = get_max_health()
		gene_damage = clamp(amount, 0, current_max_health)
		if(gene_damage >= current_max_health)
			death()

/mob/living/simple_animal/get_life_damage_types()
	var/static/list/life_damage_types = list(
		BURN,
		BRUTE,
		CLONE
	)
	return life_damage_types

/mob/living/simple_animal/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	brute_damage = clamp(brute_damage + amount, 0, get_max_health())
	. = ..()

/mob/living/simple_animal/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	burn_damage = clamp(burn_damage + amount, 0, get_max_health())
	if(do_update_health)
		update_health()
	if(amount > 0 && istype(ai))
		ai.retaliate()

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message(SPAN_DANGER("\The [src] has been attacked with \the [O] by \the [user]!"))
	if(istype(ai))
		ai.retaliate(user)

	var/damage = O.get_attack_force(user)
	if(damage <= resistance)
		to_chat(user, SPAN_WARNING("This weapon is ineffective; it does no damage."))
		return 0

	if (O.atom_damage_type == PAIN)
		damage = 0
	if (O.atom_damage_type == STUN)
		damage = (damage / 8)
	if(supernatural && istype(O,/obj/item/nullrod))
		damage *= 2
		purge = 3
	take_damage(damage, O.atom_damage_type, O.damage_flags())

	return 1

/mob/living/simple_animal/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	. = ..()
	if((damage_type == BRUTE) && (damage_flags & (DAM_EDGE | DAM_SHARP | DAM_BULLET))) // damage flags that should cause bleeding
		adjustBleedTicks(damage)
