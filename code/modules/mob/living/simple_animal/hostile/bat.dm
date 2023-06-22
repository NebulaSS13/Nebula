/mob/living/simple_animal/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats - they look pretty upset."
	icon = 'icons/mob/simple_animal/bats.dmi'
	speak_chance = 0
	turns_per_move = 3
	speed = 4
	maxHealth = 20
	health = 20

	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite

	min_gas = null
	max_gas = null
	minbodytemp = 0

	environment_smash = 1

	faction = "scarybat"
	var/mob/living/owner

/mob/living/simple_animal/hostile/scarybat/Initialize(mapload, mob/living/L)
	. = ..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/Destroy()
	owner = null
	return ..()

/mob/living/simple_animal/hostile/scarybat/FindTarget()
	. = ..()
	if(.)
		emote("flutters towards [.]")

/mob/living/simple_animal/hostile/scarybat/Found(var/atom/A)//This is here as a potential override to pick a specific target if available
	if(istype(A) && A == owner)
		return 0
	return ..()

/mob/living/simple_animal/hostile/scarybat/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			SET_STATUS_MAX(L, STAT_STUN, 1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")

/mob/living/simple_animal/hostile/scarybat/cult
	faction = "cult"
	supernatural = 1

/mob/living/simple_animal/hostile/scarybat/cult/on_defilement()
	return
