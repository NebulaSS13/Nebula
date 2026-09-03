/mob/living/simple_animal/hostile/giant_spider/carrier
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes."
	icon = 'mods/mobs/spiders/icons/spider_carrier.dmi'
	eye_color = "#7cdd00"
	max_health = 100
	poison_per_bite = 3
	poison_type = /decl/material/liquid/sedatives
	base_movement_delay = 3
	natural_weapon = /obj/item/natural_weapon/bite/weak

	var/spiderling_count = 0
	var/spiderling_type = /obj/effect/spider/spiderling
	var/swarmling_type = /mob/living/simple_animal/hostile/giant_spider/hunter/small
	var/swarmling_prob = 10 // Odds that a spiderling will be a swarmling instead.

/mob/living/simple_animal/hostile/giant_spider/carrier/Initialize()
	spiderling_count = rand(5, 10)
	set_scale(1.2)
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/carrier/death(gibbed)
	. = ..()

	if(gibbed || stat != DEAD || QDELETED(src))
		return

	visible_message(SPAN_WARNING("\The [src]'s abdomen splits as it rolls over, spiderlings crawling from the wound."))
	var/list/new_spiders = list()
	for(var/i = 1 to spiderling_count)
		if(prob(swarmling_prob))
			var/mob/living/swarmling = new swarmling_type(loc)
			swarmling.faction = faction
			new_spiders += swarmling
		else
			var/obj/effect/spider/spiderling/child = new spiderling_type(loc)
			child.disturbed()
	// Transfer our player to their new body, if RNG provided one.
	if(length(new_spiders) && client)
		transfer_key_from_mob_to_mob(src, pick(new_spiders))
	return ..()
