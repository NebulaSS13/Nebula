/mob/living/simple_animal/hostile/clown
	name = "clown"
	desc = "A denizen of clown planet"
	icon = 'icons/mob/simple_animal/clown.dmi'
	a_intent = I_HURT
	max_health = 75
	harm_intent_damage = 8
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 10	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	unsuitable_atmos_damage = 10
	natural_weapon = /obj/item/natural_weapon/clown
	faction = "circus"
	ai = /datum/mob_controller/aggressive/clown

/datum/mob_controller/aggressive/clown
	turns_per_wander = 10
	emote_speech = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see    = list("honks")
	speak_chance = 0.25
	stop_wander_when_pulled = FALSE
	only_attack_enemies = TRUE
	can_escape_buckles = TRUE

/obj/item/natural_weapon/clown
	name = "bike horn"
	_base_attack_force = 10
	hitsound = 'sound/items/bikehorn.ogg'
