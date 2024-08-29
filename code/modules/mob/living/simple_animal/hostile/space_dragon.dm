/mob/living/simple_animal/hostile/space_dragon
	name = "space dragon"
	desc = "A large reptilian creature, with vicious looking claws."
	icon = 'icons/mob/simple_animal/space_dragon.dmi'
	mob_size = MOB_SIZE_LARGE
	speak_emote = list("hisses")
	faction = "space dragons"
	butchery_data = /decl/butchery_data/animal/reptile/space_dragon
	bleed_colour = COLOR_VIOLET
	max_health = 200
	natural_weapon = /obj/item/natural_weapon/claws/space_dragon
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_ENERGY = ARMOR_ENERGY_SHIELDED,
		ARMOR_LASER = ARMOR_LASER_HEAVY,
		ARMOR_BOMB = ARMOR_BOMB_SHIELDED
	)
	ability_cooldown = 80 SECONDS
	ai = /datum/mob_controller/aggressive/space_dragon

	var/obj/item/whip/tail/tailwhip
	var/empowered_attack = FALSE
	var/gas_spent = FALSE

/datum/mob_controller/aggressive/space_dragon
	emote_hear = list("clicks")
	break_stuff_probability = 15
	emote_see = list("flaps its wings idly")

/mob/living/simple_animal/hostile/space_dragon/get_door_pry_time()
	return 4 SECONDS

/mob/living/simple_animal/hostile/space_dragon/lava_act(datum/gas_mixture/air, temperature, pressure)
	return

/mob/living/simple_animal/hostile/space_dragon/apply_attack_effects(mob/living/target)
	. = ..()
	if(empowered_attack)
		depower()
		return
	if(can_act() && !is_on_special_ability_cooldown() && ai?.get_target())
		empower()

/mob/living/simple_animal/hostile/space_dragon/get_natural_weapon()
	if(empowered_attack)
		if(!tailwhip)
			tailwhip = new(src)
		return tailwhip
	. = ..()

/mob/living/simple_animal/hostile/space_dragon/proc/empower()
	visible_message(SPAN_MFAUNA("\The [src] thrashes its tail about!"))
	empowered_attack = TRUE
	if(prob(25) && !gas_spent)
		vent_gas()
		set_special_ability_cooldown(ability_cooldown * 1.5)
		return
	set_special_ability_cooldown(ability_cooldown)

/mob/living/simple_animal/hostile/space_dragon/proc/vent_gas()
	visible_message(SPAN_MFAUNA("\The [src] raises its wings, vents a miasma of burning gas, and spreads it about with a flap!"))
	gas_spent = TRUE
	for(var/mob/living/L in oview(2))
		var/obj/item/projectile/P = new /obj/item/projectile/hotgas(get_turf(src))
		P.launch(L)

/mob/living/simple_animal/hostile/space_dragon/proc/depower()
	empowered_attack = FALSE

/obj/item/natural_weapon/claws/space_dragon
	_base_attack_force = 15