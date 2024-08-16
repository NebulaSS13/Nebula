/mob/living/simple_animal/hostile/vagrant
	name = "creature"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/simple_animal/vagrant.dmi'
	max_health = 60
	move_intents = list(
		/decl/move_intent/walk/animal_fast,
		/decl/move_intent/run/animal_fast
	)
	faction = "vagrant"
	harm_intent_damage = 3
	natural_weapon = /obj/item/natural_weapon/bite/weak
	light_color = "#8a0707"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	gene_damage = -1
	pass_flags = PASS_FLAG_TABLE
	bleed_colour = "#aad9de"
	nutrition = 100
	ai = /datum/mob_controller/aggressive/vagrant
	base_movement_delay = 2

	var/cloaked = 0
	var/mob/living/human/gripping = null
	var/blood_per_tick = 3
	var/health_per_tick = 0.8

/datum/mob_controller/aggressive/vagrant
	speak_chance = 0
	turns_per_wander = 8
	break_stuff_probability = 0

/mob/living/simple_animal/hostile/vagrant/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/vagrant/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = current_health
	. = ..()
	if(istype(ai) && isliving(Proj.firer) && (ai.get_target() != Proj.firer) && current_health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT)) //Respond to being shot at
		ai.set_target(Proj.firer)
		ai.turns_per_wander = 6
		ai.move_to_target()

/mob/living/simple_animal/hostile/vagrant/death(gibbed)
	. = ..()
	if(. && !gibbed)
		gib()

/mob/living/simple_animal/hostile/vagrant/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	if(gripping)
		if(!(get_turf(src) == get_turf(gripping)))
			gripping = null

		else if(gripping.should_have_organ(BP_HEART))
			var/blood_volume = round(gripping.vessel.total_volume)
			if(blood_volume > 5)
				gripping.vessel.remove_any(blood_per_tick)
				heal_overall_damage(health_per_tick)
				if(prob(15))
					to_chat(gripping, SPAN_DANGER("You feel your fluids being drained!"))
			else
				gripping = null

		// I suspect the original coder mistook this var for movement delay.
		// Changing wander time makes no sense in this context.
		if(istype(ai) && ai.turns_per_wander != initial(ai.turns_per_wander))
			ai.turns_per_wander = initial(ai.turns_per_wander)

	if(istype(ai) && ai.get_stance() == STANCE_IDLE && !cloaked)
		cloaked = 1
		update_icon()

	if(get_nutrition() > get_max_nutrition())
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		gib()

/mob/living/simple_animal/hostile/vagrant/on_update_icon()
	..()
	if(stat == CONSCIOUS)
		if(cloaked) //It's fun time
			alpha = 75
			set_light(0)
			icon_state = initial(icon_state)
			set_moving_slowly()
		else //It's fight time
			alpha = 255
			icon_state += "-glowing"
			set_light(3, 0.2)
			set_moving_quickly()

/mob/living/simple_animal/hostile/vagrant/apply_attack_effects(mob/living/target)
	. = ..()
	if(ishuman(target))
		var/mob/living/human/H = target
		if(gripping == H)
			SET_STATUS_MAX(H, STAT_WEAK, 1)
			SET_STATUS_MAX(H, STAT_STUN, 1)
			return
		//This line ensures there's always a reasonable chance of grabbing, while still
		//Factoring in health
		if(!gripping && (cloaked || prob(current_health + ((get_max_health() - current_health) * 2))))
			gripping = H
			cloaked = 0
			update_icon()
			SET_STATUS_MAX(H, STAT_WEAK, 1)
			SET_STATUS_MAX(H, STAT_STUN, 1)
			H.visible_message("<span class='danger'>\the [src] latches onto \the [H], pulsating!</span>")
			src.forceMove(gripping.loc)

/mob/living/simple_animal/hostile/vagrant/swarm/Initialize()
	. = ..()
	if(prob(75)) new/mob/living/simple_animal/hostile/vagrant(loc)
	if(prob(50)) new/mob/living/simple_animal/hostile/vagrant(loc)
