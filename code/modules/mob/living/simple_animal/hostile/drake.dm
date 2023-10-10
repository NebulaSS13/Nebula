/mob/living/simple_animal/hostile/drake
	name = "drake"
	desc = "A large reptilian creature, with vicious looking claws."
	icon = 'icons/mob/simple_animal/drake.dmi'
	mob_size = MOB_SIZE_LARGE
	speak_emote = list("hisses")
	emote_hear = list("clicks")
	emote_see = list("flaps its wings idly")
	break_stuff_probability = 15
	faction = "drakes"
	pry_time = 4 SECONDS
	skull_type = /obj/item/whip/tail
	bleed_colour = COLOR_VIOLET

	health = 200
	maxHealth = 200
	natural_weapon = /obj/item/natural_weapon/claws/drake
	var/obj/item/whip/tail/tailwhip
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_ENERGY = ARMOR_ENERGY_SHIELDED,
		ARMOR_LASER = ARMOR_LASER_HEAVY,
		ARMOR_BOMB = ARMOR_BOMB_SHIELDED
	)
	ability_cooldown = 80 SECONDS

	var/empowered_attack = FALSE
	var/gas_spent = FALSE

/mob/living/simple_animal/hostile/drake/lava_act(datum/gas_mixture/air, temperature, pressure)
	return

/mob/living/simple_animal/hostile/drake/AttackingTarget()
	. = ..()
	if(empowered_attack)
		depower()
		return
	if(can_act() && !is_on_special_ability_cooldown() && target_mob)
		empower()

/mob/living/simple_animal/hostile/drake/get_natural_weapon()
	if(empowered_attack)
		if(!tailwhip)
			tailwhip = new(src)
		return tailwhip
	. = ..()

/mob/living/simple_animal/hostile/drake/proc/empower()
	visible_message(SPAN_MFAUNA("\The [src] thrashes its tail about!"))
	empowered_attack = TRUE
	if(prob(25) && !gas_spent)
		vent_gas()
		set_special_ability_cooldown(ability_cooldown * 1.5)
		return
	set_special_ability_cooldown(ability_cooldown)

/mob/living/simple_animal/hostile/drake/proc/vent_gas()
	visible_message(SPAN_MFAUNA("\The [src] raises its wings, vents a miasma of burning gas, and spreads it about with a flap!"))
	gas_spent = TRUE
	for(var/mob/living/L in oview(2))
		var/obj/item/projectile/P = new /obj/item/projectile/hotgas(get_turf(src))
		P.launch(L)

/mob/living/simple_animal/hostile/drake/proc/depower()
	empowered_attack = FALSE

/obj/item/natural_weapon/claws/drake
	force = 15