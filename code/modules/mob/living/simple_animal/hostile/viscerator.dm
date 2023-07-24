/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/simple_animal/viscerator.dmi'
	pass_flags = PASS_FLAG_TABLE
	mob_default_max_health = 15
	natural_weapon = /obj/item/natural_weapon/rotating_blade
	faction = "syndicate"
	min_gas = null
	max_gas = null
	minbodytemp = 0

	bleed_colour = SYNTH_BLOOD_COLOR

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

/obj/item/natural_weapon/rotating_blade
	name = "rotating blades"
	attack_verb = list("sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 15
	edge = 1
	sharp = 1

/mob/living/simple_animal/hostile/viscerator/death(gibbed, deathmessage, show_dead_message)
	..(null, "is smashed into pieces!", show_dead_message)
	qdel(src)

/mob/living/simple_animal/hostile/viscerator/hive
	faction = "hivebot"
