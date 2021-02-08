/mob/living/critter/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats - they look pretty upset."
	icon = 'icons/mob/critter/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	speak_chance = 0
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
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

/mob/living/critter/hostile/scarybat/Initialize(mapload, mob/living/L)
	. = ..()
	if(istype(L))
		owner = L

/mob/living/critter/hostile/scarybat/FindTarget()
	. = ..()
	if(.)
		emote("flutters towards [.]")

/mob/living/critter/hostile/scarybat/Found(var/atom/A)//This is here as a potential override to pick a specific target if available
	if(istype(A) && A == owner)
		return 0
	return ..()

/mob/living/critter/hostile/scarybat/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Stun(1)
			L.visible_message("<span class='danger'>\the [src] scares \the [L]!</span>")

/mob/living/critter/hostile/scarybat/cult
	faction = "cult"
	supernatural = 1

/mob/living/critter/hostile/scarybat/cult/cultify()
	return
