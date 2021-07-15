
/mob/living/simple_animal/hostile/vagrant
	name = "creature"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/mob.dmi'
	icon_state = "vagrant"
	icon_living = "vagrant"
	icon_dead = "vagrant"
	icon_gib = "vagrant"
	maxHealth = 60
	health = 20
	speed = 5
	speak_chance = 0
	turns_per_move = 4
	move_to_delay = 4
	break_stuff_probability = 0
	faction = "vagrant"
	harm_intent_damage = 3
	natural_weapon = /obj/item/natural_weapon/bite/weak
	light_color = "#8a0707"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	gene_damage = -1

	var/cloaked = 0
	var/mob/living/carbon/human/gripping = null
	var/blood_per_tick = 3
	var/health_per_tick = 0.8
	pass_flags = PASS_FLAG_TABLE

	bleed_colour = "#aad9de"

/mob/living/simple_animal/hostile/vagrant/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/vagrant/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = health
	. = ..()
	if((target_mob != Proj.firer) && health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT)) //Respond to being shot at
		target_mob = Proj.firer
		turns_per_move = 3
		MoveToTarget()

/mob/living/simple_animal/hostile/vagrant/death(gibbed)
	. = ..()
	if(. && !gibbed)
		gib()

/mob/living/simple_animal/hostile/vagrant/Life()
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
				health = min(health + health_per_tick, maxHealth)
				if(prob(15))
					to_chat(gripping, "<span class='danger'>You feel your fluids being drained!</span>")
			else
				gripping = null

		if(turns_per_move != initial(turns_per_move))
			turns_per_move = initial(turns_per_move)

	if(stance == HOSTILE_STANCE_IDLE && !cloaked)
		cloaked = 1
		update_icon()
	if(health == maxHealth)
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		gib()
		return

/mob/living/simple_animal/hostile/vagrant/on_update_icon()
	..()
	if(cloaked) //It's fun time
		alpha = 75
		set_light(0)
		icon_state = initial(icon_state)
		move_to_delay = initial(move_to_delay)
	else //It's fight time
		alpha = 255
		icon_state = "vagrant_glowing"
		set_light(3, 0.2)
		move_to_delay = 2

/mob/living/simple_animal/hostile/vagrant/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(gripping == H)
			SET_STATUS_MAX(H, STAT_WEAK, 1)
			SET_STATUS_MAX(H, STAT_STUN, 1)
			return
		//This line ensures there's always a reasonable chance of grabbing, while still
		//Factoring in health
		if(!gripping && (cloaked || prob(health + ((maxHealth - health) * 2))))
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
