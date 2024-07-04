/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A junky looking robot with four spiky legs."
	icon = 'icons/mob/simple_animal/hivebot.dmi'
	max_health = 55
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectiletype = /obj/item/projectile/beam/smalllaser
	faction = "hivebot"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
		)
	bleed_colour = SYNTH_BLOOD_COLOR
	gene_damage = -1
	base_animal_type = /mob/living/simple_animal/hostile/hivebot
	butchery_data = /decl/butchery_data/synthetic

/mob/living/simple_animal/hostile/hivebot/check_has_mouth()
	return FALSE

/mob/living/simple_animal/hostile/hivebot/get_death_message(gibbed)
	return "blows apart!"

/mob/living/simple_animal/hostile/hivebot/death(gibbed)
	. = ..()
	if(. && !gibbed)
		new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
		spark_at(src, cardinal_only = TRUE)
		qdel(src)
