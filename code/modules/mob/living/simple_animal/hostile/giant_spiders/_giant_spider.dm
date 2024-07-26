//base type, generic 'worker' type spider with no defining gimmick
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "A monstrously huge green spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider.dmi'
	speak_emote = list("chitters")
	see_in_dark = 10
	response_harm = "pokes"
	max_health = 125
	natural_weapon = /obj/item/natural_weapon/bite
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "spiders"
	pass_flags = PASS_FLAG_TABLE
	base_movement_delay = 1
	max_gas = list(
		/decl/material/gas/chlorine = 1,
		/decl/material/gas/carbon_dioxide = 5,
		/decl/material/gas/methyl_bromide = 1
	)
	bleed_colour = "#0d5a71"
	base_animal_type = /mob/living/simple_animal/hostile/giant_spider
	butchery_data = /decl/butchery_data/animal/arthropod/giant_spider
	glowing_eyes = TRUE
	ai = /datum/mob_controller/aggressive/giant_spider

	var/poison_per_bite = 6
	var/poison_type = /decl/material/liquid/venom
	var/eye_colour
	var/allowed_eye_colours = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_LIME, COLOR_DEEP_SKY_BLUE, COLOR_INDIGO, COLOR_VIOLET, COLOR_PINK)

/mob/living/simple_animal/hostile/giant_spider/has_footsteps()
	return TRUE

/mob/living/simple_animal/hostile/giant_spider/get_footstep_sound(turf/step_turf)
	return 'sound/effects/spider_loop.ogg'

/mob/living/simple_animal/hostile/giant_spider/modify_footstep_volume(volume, obj/item/clothing/shoes/shoes)
	return volume

/mob/living/simple_animal/hostile/giant_spider/modify_footstep_range(range, obj/item/clothing/shoes/shoes)
	return range

/mob/living/simple_animal/hostile/giant_spider/get_pry_desc()
	return "clawing"

/mob/living/simple_animal/hostile/giant_spider/get_door_pry_time()
	return 8 SECONDS

/mob/living/simple_animal/hostile/giant_spider/get_eye_overlay()
	var/image/ret = ..()
	if(ret && eye_colour)
		ret.color = eye_colour
	return ret

/mob/living/simple_animal/hostile/giant_spider/can_do_maneuver(var/decl/maneuver/maneuver, var/silent = FALSE)
	. = ..() && can_act()

/mob/living/simple_animal/hostile/giant_spider/Initialize(var/mapload, var/atom/parent)
	color = parent?.color || color
	set_max_health(rand(initial(max_health), (1.4 * initial(max_health))))
	eye_colour = pick(allowed_eye_colours)
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/apply_attack_effects(mob/living/target)
	. = ..()
	if(current_health < get_max_health())
		var/obj/item/attacking_with = get_natural_weapon()
		if(attacking_with)
			heal_overall_damage(0.2 * attacking_with.force) //heal a bit on hit
	if(ishuman(target))
		var/mob/living/human/H = target
		var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
		if(istype(S) && !length(S.breaches))
			return
	if(target.reagents)
		target.add_to_reagents(poison_type, rand(0.5 * poison_per_bite, poison_per_bite))
		if(prob(poison_per_bite))
			to_chat(target, "<span class='warning'>You feel a tiny prick.</span>")

/mob/living/simple_animal/hostile/giant_spider/proc/disable_stop_automated_movement()
	stop_automove()
	if(istype(ai))
		ai.stop_wandering()
		ai.set_stance(ai.get_target() ? STANCE_ATTACK : STANCE_IDLE)

/mob/living/simple_animal/hostile/giant_spider/proc/divorce()
	return
