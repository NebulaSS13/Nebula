/datum/mob_controller/hostile/ghoul
	expected_type = /mob/living/simple_animal/hostile/ghoul
	emote_hear   = list("rasps","gurgles","growls")
	emote_see    = list("shuffles", "jerks violently")
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0




/mob/living/simple_animal/hostile/ghoul
	name = "feral ghoul"
	desc = "A ghoul."
	icon = 'mods/content/fallout/mobs/icons/human/ghoul.dmi'
	mob_size = MOB_SIZE_MEDIUM
	speak_emote = list("rasps")
	response_harm = "strikes"
	faction = "hostile"
	bleed_colour = COLOR_RED
	harm_intent_damage = 8

	current_health = 65
	max_health = 65
	natural_weapon = /obj/item/natural_weapon/bite
	natural_armor = list()

/mob/living/simple_animal/hostile/ghoul/reaver
	name = "reaver ghoul"
	desc = "A strong-looking ghoul."
	icon = 'mods/content/fallout/mobs/icons/human/reaver.dmi'
	harm_intent_damage = 12
	current_health = 120
	max_health = 120

/mob/living/simple_animal/hostile/ghoul/ranged
	name = "vault ghoul"
	desc = "A ghoul wearing tattered vault clothese."
	icon = 'mods/content/fallout/mobs/icons/human/vaultghoul.dmi'
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectiletype = /obj/item/gun/projectile/pistol

