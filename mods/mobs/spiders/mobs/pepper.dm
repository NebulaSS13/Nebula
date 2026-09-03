/mob/living/simple_animal/hostile/giant_spider/pepper
	desc = "Red and brown, it makes you shudder to look at it. This one has glinting red eyes."
	icon = 'mods/mobs/spiders/icons/spider_pepper.dmi'
	eye_color = "#ff0000"
	max_health = 210
	poison_chance = 20
	poison_per_bite = 5
	poison_type = /decl/material/liquid/capsaicin/condensed

/mob/living/simple_animal/hostile/giant_spider/pepper/Initialize(mapload, atom/parent)
	. = ..()
	set_scale(1.1)
