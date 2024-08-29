/mob/living/simple_animal/hostile/giant_crab
	name = "giant crab"
	desc = "A gigantic crustacean with a blue shell. Its left claw is nearly twice the size of its right."
	icon = 'icons/mob/simple_animal/bluecrab.dmi'
	mob_size = MOB_SIZE_LARGE
	speak_emote = list("clicks")
	butchery_data = /decl/butchery_data/animal/arthropod/crab/giant
	faction = "crabs"
	max_health = 350
	natural_weapon = /obj/item/natural_weapon/pincers/giant
	return_damage_min = 2
	return_damage_max = 5
	harm_intent_damage = 1
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL
		)
	ability_cooldown = 2 MINUTES
	ai = /datum/mob_controller/aggressive/giant_crab

	var/mob/living/human/victim //the human we're grabbing
	var/grab_duration = 3 //duration of disable in life ticks to simulate a grab
	var/grab_damage = 6 //brute damage before reductions, per crab's life tick
	var/list/grab_desc = list("thrashes", "squeezes", "crushes")
	var/continue_grab_prob = 35 //probability that a successful grab will be extended by one life tick

/datum/mob_controller/aggressive/giant_crab
	break_stuff_probability = 15
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 0.25
	turns_per_wander = 10
	expected_type = /mob/living/simple_animal/hostile/giant_crab
	only_attack_enemies = TRUE
	can_escape_buckles = TRUE

/datum/mob_controller/aggressive/giant_crab/do_process(time_elapsed)
	if(!(. = ..()))
		return
	var/mob/living/simple_animal/hostile/giant_crab/crab = body
	if(!istype(crab) || body.stat)
		return
	crab.process_grab()
	if((body.current_health > body.get_max_health() / 1.5) && LAZYLEN(get_enemies()) && prob(5))
		if(crab.victim)
			crab.release_grab()
		clear_enemies()
		lose_target()
		body.visible_message(SPAN_NOTICE("\The [body] lowers its pincer."))

/obj/item/natural_weapon/pincers/giant
	_base_attack_force = 15
	attack_verb = list("snipped", "pinched", "crushed")

/mob/living/simple_animal/hostile/giant_crab/Initialize() //embiggen
	. = ..()
	set_scale(1.5)

/mob/living/simple_animal/hostile/giant_crab/get_door_pry_time()
	return 2 SECONDS

/mob/living/simple_animal/hostile/giant_crab/Destroy()
	. = ..()
	victim = null

/mob/living/simple_animal/hostile/giant_crab/default_hurt_interaction(mob/user)
	. = ..()
	if(. && ishuman(user))
		reflect_unarmed_damage(user, BRUTE, "armoured carapace")

/mob/living/simple_animal/hostile/giant_crab/apply_attack_effects(mob/living/target)
	. = ..()
	if(!ishuman(target))
		return

	var/mob/living/human/H = target
	if(victim == H)
		if(!Adjacent(victim))
			release_grab()
		else if(prob(continue_grab_prob))
			SET_STATUS_MAX(H, STAT_WEAK, 1)
			SET_STATUS_MAX(H, STAT_STUN, 1)
			grab_damage++
			visible_message(SPAN_MFAUNA("\The [src] tightens its grip on \the [victim]!"))
			return

	if(!victim && can_act() && !is_on_special_ability_cooldown() && Adjacent(H))
		events_repository.register(/decl/observ/destroyed, victim, src, PROC_REF(release_grab))
		victim = H
		SET_STATUS_MAX(H, STAT_WEAK, grab_duration)
		SET_STATUS_MAX(H, STAT_STUN, grab_duration)
		visible_message(SPAN_MFAUNA("\The [src] catches \the [victim] in its powerful pincer!"))
		ai?.pause()

/mob/living/simple_animal/hostile/giant_crab/proc/process_grab()
	if(victim && !incapacitated())
		if(victim.stat >= UNCONSCIOUS || !Adjacent(victim) || !victim.incapacitated())
			release_grab()
			return
		visible_message(SPAN_DANGER("\The [src] [pick(grab_desc)] \the [victim] in its pincer!"))
		victim.apply_damage(grab_damage, BRUTE, BP_CHEST, DAM_EDGE, used_weapon = "crab's pincer")

/mob/living/simple_animal/hostile/giant_crab/proc/release_grab()
	if(victim)
		visible_message(SPAN_NOTICE("\The [src] releases its grip on \the [victim]!"))
		events_repository.unregister(/decl/observ/destroyed, victim)
		victim = null
	set_special_ability_cooldown(ability_cooldown)
	ai?.resume()
	grab_damage = initial(grab_damage)