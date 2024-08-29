/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/simple_animal/viscerator.dmi'
	pass_flags = PASS_FLAG_TABLE
	max_health = 15
	natural_weapon = /obj/item/natural_weapon/rotating_blade
	faction = "syndicate"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	attack_delay = DEFAULT_QUICK_COOLDOWN
	bleed_colour = SYNTH_BLOOD_COLOR
	butchery_data = /decl/butchery_data/synthetic

/obj/item/natural_weapon/rotating_blade
	name = "rotating blades"
	attack_verb = list("sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	_base_attack_force = 15
	edge = 1
	sharp = 1

/mob/living/simple_animal/hostile/viscerator/check_has_mouth()
	return FALSE

/mob/living/simple_animal/hostile/viscerator/get_death_message(gibbed)
	return "is smashed into pieces!"

/mob/living/simple_animal/hostile/viscerator/death(gibbed)
	. = ..()
	if(. && !gibbed)
		qdel(src)

/mob/living/simple_animal/hostile/viscerator/hive
	faction = "hivebot"
