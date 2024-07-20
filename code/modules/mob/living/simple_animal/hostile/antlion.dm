/mob/living/simple_animal/hostile/antlion
	name = "antlion"
	desc = "A large insectoid creature."
	icon = 'icons/mob/simple_animal/antlion.dmi'
	mob_size = MOB_SIZE_MEDIUM
	speak_emote = list("clicks")
	response_harm = "strikes"
	faction = "antlions"
	bleed_colour = COLOR_SKY_BLUE
	max_health = 65
	natural_weapon = /obj/item/natural_weapon/bite
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
	)
	ability_cooldown = 30 SECONDS
	butchery_data = /decl/butchery_data/animal/antlion
	ai = /datum/mob_controller/aggressive/antlion
	var/healing = FALSE
	var/heal_amount = 6

/datum/mob_controller/aggressive/antlion
	emote_hear = list("clicks its mandibles")
	emote_see = list("shakes the sand off itself")

/mob/living/simple_animal/hostile/antlion/handle_regular_status_updates()
	. = ..()
	process_healing()
	if(. && !is_on_special_ability_cooldown() && can_act() && istype(ai) && ai.get_target())
		vanish()

/mob/living/simple_animal/hostile/antlion/proc/vanish()
	if(invisibility >= INVISIBILITY_OBSERVER)
		return
	visible_message(SPAN_NOTICE("\The [src] burrows into \the [get_turf(src)]!"))
	set_density(FALSE)
	set_invisibility(INVISIBILITY_OBSERVER)
	set_special_ability_cooldown(5 SECONDS)
	prep_burrow(TRUE)
	addtimer(CALLBACK(src, PROC_REF(diggy)), 5 SECONDS)

/mob/living/simple_animal/hostile/antlion/proc/diggy()
	if(!istype(ai))
		return
	var/list/turf_targets
	var/current_target = get_turf(ai.get_target())
	if(current_target)
		for(var/turf/T in range(1, current_target))
			if(!T.is_floor())
				continue
			if(!T.z != src.z)
				continue
			turf_targets += T
	else
		for(var/turf/T in orange(5, src))
			if(!T.is_floor())
				continue
			if(!T.z != src.z)
				continue
			turf_targets += T
	if(!LAZYLEN(turf_targets)) //oh no
		addtimer(CALLBACK(src, PROC_REF(emerge)), 2 SECONDS)
		return
	var/turf/T = pick(turf_targets)
	if(T && !incapacitated())
		forceMove(T)
	addtimer(CALLBACK(src, PROC_REF(emerge)), 2 SECONDS)

/mob/living/simple_animal/hostile/antlion/proc/emerge()
	var/turf/T = get_turf(src)
	if(!T)
		return
	visible_message(SPAN_WARNING("\The [src] erupts from \the [T]!"))
	set_density(TRUE)
	set_invisibility(initial(invisibility))
	prep_burrow(FALSE)
	set_special_ability_cooldown(ability_cooldown)
	for(var/mob/living/human/H in get_turf(src))
		H.attackby(natural_weapon, src)
		visible_message(SPAN_DANGER("\The [src] tears into \the [H] from below!"))
		SET_STATUS_MAX(H, STAT_WEAK, 1)

/mob/living/simple_animal/hostile/antlion/proc/process_healing()
	if(!incapacitated() && healing && current_health < get_max_health())
		heal_overall_damage(rand(heal_amount), rand(heal_amount))

/mob/living/simple_animal/hostile/antlion/proc/prep_burrow(var/new_bool)
	if(istype(ai))
		if(new_bool)
			ai.pause()
		else
			ai.resume()
	healing = new_bool

/mob/living/simple_animal/hostile/antlion/mega
	name = "antlion queen"
	desc = "A huge antlion. It looks displeased."
	icon = 'icons/mob/simple_animal/antlion_queen.dmi'
	mob_size = MOB_SIZE_LARGE
	max_health = 275
	natural_weapon = /obj/item/natural_weapon/bite/megalion
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT
		)
	heal_amount = 9
	ability_cooldown = 45 SECONDS
	butchery_data = /decl/butchery_data/animal/antlion/queen
	ai = /datum/mob_controller/aggressive/antlion/mega

/datum/mob_controller/aggressive/antlion/mega
	break_stuff_probability = 25
	can_escape_buckles = TRUE

/obj/item/natural_weapon/bite/megalion
	name = "mandibles"
	_base_attack_force = 25

/mob/living/simple_animal/hostile/antlion/mega/Initialize()
	. = ..()
	set_scale(1.5)