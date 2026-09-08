/mob/living/simple_animal/hostile/frostfly
	name = "frostfly"
	desc = "A large insect with glittering wings."
	icon = 'mods/content/polaris/icons/wildlife/frostfly.dmi'
	ai = /datum/mob_controller/aggressive/frostfly
	max_health = 65
	base_movement_delay = -1
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_KNIVES,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_MINOR,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)
	cold_damage_per_tick = 0
	ability_cooldown = 10 SECONDS
	projectiletype = /obj/item/projectile/energy/blob/freezing
	_available_maneuvers = list(/decl/maneuver/smokescreen)
	ability_cooldown = 3 MINUTES
	ability_system = /datum/effect/effect/system/smoke_spread/frost
	natural_weapon = /obj/item/natural_weapon/frostfly_pincers

/mob/living/simple_animal/hostile/frostfly/get_cold_protection(temperature)
	return 1

/mob/living/simple_animal/hostile/frostfly/inflict_cold_damage(amount)
	return

/mob/living/simple_animal/hostile/frostfly/can_overcome_gravity()
	return !incapacitated()

/mob/living/simple_animal/hostile/frostfly/handle_regular_status_updates()
	. = ..()
	if(incapacitated())
		stop_floating()
	else
		start_floating()

/mob/living/simple_animal/hostile/frostfly/death(gibbed)
	. = ..()
	if(. && !gibbed)
		stop_floating()

/obj/item/natural_weapon/frostfly_pincers
	name = "pincers"
	_base_attack_force = 7
	sharp = TRUE
	attack_verb = list("nipped", "bit", "pinched")
	attack_cooldown = 1.5 SECONDS

/datum/mob_controller/aggressive/frostfly
	emote_speech = list("Zzzz.", "Kss.", "Zzt?")
	emote_see    = list("flutters its wings","looks around", "rubs its mandibles")
	emote_hear   = list("chitters", "clicks", "chirps")
