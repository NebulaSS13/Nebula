/mob/living/simple_animal/hostile/giant_spider/volatile
	icon = 'mods/mobs/spiders/icons/spider_volatile.dmi'
	desc = "Crystalline and purple, it makes you shudder to look at it. This one has haunting purple eyes."
	eye_color = "#bc10d7"
	natural_weapon = /obj/item/natural_weapon/bite/strong
	max_health = 225
	base_movement_delay = 5

	poison_chance = 30
	poison_per_bite = 0.5
	poison_type = /decl/material/liquid/fuel/hydrazine

	var/exploded = FALSE
	var/explosion_dev_range		= 1
	var/explosion_heavy_range	= 2
	var/explosion_light_range	= 4
	var/explosion_flash_range	= 6

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 2 SECONDS	// Upper bound.

/mob/living/simple_animal/hostile/giant_spider/volatile/Initialize(mapload, atom/parent)
	. = ..()
	set_scale(1.25)

/mob/living/simple_animal/hostile/giant_spider/volatile/death(gibbed)
	var/turf/death_loc = get_turf(src)
	. = ..()
	if(gibbed || !death_loc || QDELETED(src))
		return
	visible_message(SPAN_DANGER("\The [src]'s body begins to rupture!"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider/volatile, do_death_explosion), 0))

/mob/living/simple_animal/hostile/giant_spider/volatile/proc/do_death_explosion()
	set waitfor = FALSE

	// Flash black and red as a warning.
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	for(var/i = 1 to delay)
		if(i % 2 == 0)
			color = "#000000"
		else
			color = "#ff0000"
		sleep(1)

	if(QDELETED(src) || exploded)
		return

	visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
	exploded = TRUE
	explosion(get_turf(src), explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)

/mob/living/simple_animal/hostile/giant_spider/volatile/immune_to_damage_type(damage_type)
	return (damage_type == PAIN) // You will need more than a taser to kill the juggernaut.
