/decl/maneuver/leap/spider
	stamina_cost = 0
	cooldown = 3 MINUTES

/decl/maneuver/leap/spider/ai_should_use(mob/living/user, atom/target)
	return istype(target) // Range checking is done in can_be_used_by() above.

/decl/maneuver/leap/spider/show_initial_message(var/mob/living/user, var/atom/target)
	user.visible_message(SPAN_WARNING("\The [user] reels back and prepares to launch itself at \the [target]!"))

/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "A monstrously huge black spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_black.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/strong
	poison_per_bite = 10
	base_movement_delay = -1
	flash_protection = FLASH_PROTECTION_REDUCED
	does_spin = FALSE
	_available_maneuvers = list(/decl/maneuver/leap/spider)
	ai = /datum/mob_controller/aggressive/giant_spider/hunter
	var/leap_range = 5

/mob/living/simple_animal/hostile/giant_spider/hunter/get_door_pry_time()
	return 5 SECONDS

/mob/living/simple_animal/hostile/giant_spider/hunter/get_jump_distance()
	return leap_range

/mob/living/simple_animal/hostile/giant_spider/hunter/perform_maneuver(var/maneuver, var/atom/target)
	if(!isliving(target) || get_dist(src, target) <= 3)
		return FALSE
	stop_automove()
	if(istype(ai))
		ai.pause()
	. = ..()
	if(istype(ai))
		ai.resume()

/mob/living/simple_animal/hostile/giant_spider/hunter/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom
		if(istype(ai))
			ai.resume()
		visible_message(SPAN_DANGER("\The [src] slams into \the [target], knocking them over!"))
		SET_STATUS_MAX(target, STAT_WEAK, 1)
