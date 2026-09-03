/mob/living/simple_animal/hostile/giant_spider/thermic
	icon = 'mods/mobs/spiders/icons/spider_thermic.dmi'
	eye_color = "#ff8300"
	desc = "Mirage-cloaked and orange, it makes you shudder to look at it. This one has simmering orange eyes."
	max_health = 175
	heat_damage_per_tick = 1
	cold_damage_per_tick = 5
	poison_chance = 30
	poison_per_bite = 1
	poison_type = /decl/material/liquid/thermite/venom

/mob/living/simple_animal/hostile/giant_spider/thermic/death(gibbed)
	. = ..()
	if(gibbed || prob(25))
		var/turf/my_turf = get_turf(src)
		if(istype(my_turf))
			new /obj/effect/decal/cleanable/thermite/self_igniting(my_turf)
