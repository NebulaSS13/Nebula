//spitters - fast, comparatively weak, very venomous; projectile attacks but will resort to melee once out of ammo
/mob/living/simple_animal/hostile/giant_spider/ranged/spitter
	desc = "A monstrously huge iridescent spider with shimmering eyes."
	icon = 'mods/mobs/spiders/icons/spider_purple.dmi'
	max_health = 90
	poison_per_bite = 15
	projectiletype = /obj/item/projectile/venom
	projectilesound = 'sound/effects/hypospray.ogg'
	fire_desc = "spits venom"
	ranged_range = 7
	flash_protection = FLASH_PROTECTION_REDUCED
	natural_weapon = /obj/item/natural_weapon/bite/weak
	ai = /datum/mob_controller/aggressive/giant_spider/cautious
