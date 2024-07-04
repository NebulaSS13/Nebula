//spitters - fast, comparatively weak, very venomous; projectile attacks but will resort to melee once out of ammo
/mob/living/simple_animal/hostile/giant_spider/spitter
	desc = "A monstrously huge iridescent spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_purple.dmi'
	max_health = 90
	poison_per_bite = 15
	projectiletype = /obj/item/projectile/venom
	projectilesound = 'sound/effects/hypospray.ogg'
	fire_desc = "spits venom"
	ranged_range = 6
	flash_protection = FLASH_PROTECTION_REDUCED
	var/venom_charge = 16

/mob/living/simple_animal/hostile/giant_spider/spitter/get_door_pry_time()
	return 7 SECONDS

/mob/living/simple_animal/hostile/giant_spider/spitter/has_ranged_attack()
	return venom_charge > 0

/mob/living/simple_animal/hostile/giant_spider/spitter/handle_regular_status_updates()
	. = ..()
	if(!.)
		return FALSE
	if(venom_charge <= 0 && prob(25))
		venom_charge++

/mob/living/simple_animal/hostile/giant_spider/spitter/shoot_at()
	. = ..()
	if(.)
		venom_charge--
