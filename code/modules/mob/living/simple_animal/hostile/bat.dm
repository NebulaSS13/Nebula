/mob/living/simple_animal/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats - they look pretty upset."
	icon = 'icons/mob/simple_animal/bats.dmi'

	max_health = 20
	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite
	min_gas = null
	max_gas = null
	minbodytemp = 0
	environment_smash = 1
	faction = "scarybat"
	ai = /datum/mob_controller/aggressive/bats
	var/mob/living/owner

/mob/living/simple_animal/hostile/scarybat/cave
	name = "cave bats"
	desc = "A swarm of screeching cave bats, twisted by the deep dark and hungering for blood."
	faction = "undead"

/datum/mob_controller/aggressive/bats
	speak_chance = 0
	turns_per_wander = 6

/datum/mob_controller/aggressive/bats/find_target()
	. = ..()
	if(.)
		body.custom_emote(VISIBLE_MESSAGE, "flutters towards [.]")

/mob/living/simple_animal/hostile/scarybat/Initialize(mapload, mob/living/L)
	. = ..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/Destroy()
	owner = null
	return ..()

/datum/mob_controller/aggressive/bats/valid_target(var/atom/A)
	. = ..()
	if(.)
		var/mob/living/simple_animal/hostile/scarybat/bats = body
		return !istype(bats) || !bats.owner || A != bats.owner

/mob/living/simple_animal/hostile/scarybat/apply_attack_effects(mob/living/target)
	. = ..()
	if(prob(15))
		SET_STATUS_MAX(target, STAT_STUN, 1)
		target.visible_message(SPAN_DANGER("\The [src] scares \the [target]!"))
