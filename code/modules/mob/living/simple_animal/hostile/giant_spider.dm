#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//base type, generic 'worker' type spider with no defining gimmick
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "A monstrously huge green spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider.dmi'
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	emote_see = list("rubs its forelegs together", "wipes its fangs", "stops suddenly")
	speak_chance = 2.5
	turns_per_move = 5
	see_in_dark = 10
	response_harm = "pokes"
	max_health = 125
	natural_weapon = /obj/item/natural_weapon/bite
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "spiders"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 1
	max_gas = list(
		/decl/material/gas/chlorine = 1,
		/decl/material/gas/carbon_dioxide = 5,
		/decl/material/gas/methyl_bromide = 1
	)
	bleed_colour = "#0d5a71"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	base_animal_type = /mob/living/simple_animal/hostile/giant_spider
	butchery_data = /decl/butchery_data/animal/arthropod/giant_spider
	glowing_eyes = TRUE
	ai = /datum/ai/giant_spider

	var/poison_per_bite = 6
	var/poison_type = /decl/material/liquid/venom
	var/busy = 0
	var/eye_colour
	var/allowed_eye_colours = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_LIME, COLOR_DEEP_SKY_BLUE, COLOR_INDIGO, COLOR_VIOLET, COLOR_PINK)
	var/hunt_chance = 1 //percentage chance the mob will run to a random nearby tile

/mob/living/simple_animal/hostile/giant_spider/get_eye_overlay()
	var/image/ret = ..()
	if(ret && eye_colour)
		ret.color = eye_colour
	return ret

/mob/living/simple_animal/hostile/giant_spider/can_do_maneuver(var/decl/maneuver/maneuver, var/silent = FALSE)
	. = ..() && can_act()

//guards - less venomous, tanky, slower, prioritises protecting nurses
/mob/living/simple_animal/hostile/giant_spider/guard
	desc = "A monstrously huge brown spider with shimmering eyes."
	butchery_data = /decl/butchery_data/animal/arthropod/giant_spider/guard
	max_health = 200
	natural_weapon = /obj/item/natural_weapon/bite/strong
	poison_per_bite = 5
	speed = 2
	move_to_delay = 4
	break_stuff_probability = 15
	pry_time = 6 SECONDS

	var/vengance
	var/berserking
	var/mob/living/simple_animal/hostile/giant_spider/nurse/paired_nurse

//nursemaids - these create webs and eggs - the weakest and least threatening
/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "A monstrously huge beige spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_beige.dmi'
	max_health = 80
	harm_intent_damage = 6 //soft
	poison_per_bite = 5
	speed = 0
	poison_type = /decl/material/liquid/sedatives
	break_stuff_probability = 10
	pry_time = 9 SECONDS

	var/atom/cocoon_target
	var/fed = 0
	var/max_eggs = 8
	var/infest_chance = 8
	var/mob/living/simple_animal/hostile/giant_spider/guard/paired_guard

	//things we can't encase in a cocoon
	var/static/list/cocoon_blacklist = list(
		/mob/living/simple_animal/hostile/giant_spider,
		/obj/structure/closet
	)

//hunters - the most damage, fast, average health and the only caste tenacious enough to break out of nets
/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "A monstrously huge black spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_black.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/strong
	poison_per_bite = 10
	speed = -1
	move_to_delay = 2
	break_stuff_probability = 30
	hunt_chance = 25
	can_escape = TRUE
	pry_time = 5 SECONDS
	flash_protection = FLASH_PROTECTION_REDUCED
	does_spin = FALSE
	available_maneuvers = list(/decl/maneuver/leap/spider)
	ability_cooldown = 3 MINUTES

	var/leap_range = 5

//spitters - fast, comparatively weak, very venomous; projectile attacks but will resort to melee once out of ammo
/mob/living/simple_animal/hostile/giant_spider/spitter
	desc = "A monstrously huge iridescent spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_purple.dmi'
	max_health = 90
	poison_per_bite = 15
	ranged = TRUE
	move_to_delay = 2
	projectiletype = /obj/item/projectile/venom
	projectilesound = 'sound/effects/hypospray.ogg'
	fire_desc = "spits venom"
	ranged_range = 6
	pry_time = 7 SECONDS
	flash_protection = FLASH_PROTECTION_REDUCED

	var/venom_charge = 16

//General spider procs
/mob/living/simple_animal/hostile/giant_spider/Initialize(var/mapload, var/atom/parent)
	color = parent?.color || color
	set_max_health(rand(initial(max_health), (1.4 * initial(max_health))))
	eye_colour = pick(allowed_eye_colours)
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/FindTarget()
	. = ..()
	if(.)
		if(!ranged) //ranged mobs find target after each shot, dont need this spammed quite so much
			custom_emote(1,"raises its forelegs at [.]")
		else
			if(prob(15))
				custom_emote(1,"locks its eyes on [.]")

/mob/living/simple_animal/hostile/giant_spider/attack_target(mob/target)
	. = ..()
	if(isliving(.))
		if(current_health < get_max_health())
			var/obj/item/attacking_with = get_natural_weapon()
			if(attacking_with)
				heal_overall_damage(0.2 * attacking_with.force) //heal a bit on hit
		if(ishuman(.))
			var/mob/living/human/H = .
			var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
			if(istype(S) && !length(S.breaches))
				return
		var/mob/living/L = .
		if(L.reagents)
			L.add_to_reagents(poison_type, rand(0.5 * poison_per_bite, poison_per_bite))
			if(prob(poison_per_bite))
				to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")

/datum/ai/giant_spider
	expected_type = /mob/living/simple_animal/hostile/giant_spider

/datum/ai/giant_spider/do_process()
	var/mob/living/simple_animal/hostile/giant_spider/spooder = body
	if(spooder.stance == HOSTILE_STANCE_IDLE)
		//chance to skitter madly away
		if(!spooder.busy && prob(spooder.hunt_chance))
			spooder.stop_automated_movement = 1
			walk_to(spooder, pick(orange(20, spooder)), 1, spooder.move_to_delay)
			addtimer(CALLBACK(spooder, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, disable_stop_automated_movement)), 5 SECONDS)

/mob/living/simple_animal/hostile/giant_spider/proc/disable_stop_automated_movement()
	stop_automated_movement = 0
	walk(src,0)
	kick_stance()

/mob/living/simple_animal/hostile/giant_spider/proc/divorce()
	return

/****************
Guard caste procs
****************/
/mob/living/simple_animal/hostile/giant_spider/guard
	ai = /datum/ai/giant_spider/guard

/datum/ai/giant_spider/guard
	expected_type = /mob/living/simple_animal/hostile/giant_spider/guard

/datum/ai/giant_spider/guard/do_process(time_elapsed)
	. = ..()
	var/mob/living/simple_animal/hostile/giant_spider/guard/spooder = body
	if(spooder.berserking)
		return
	if(!spooder.paired_nurse)
		spooder.find_nurse()
	if(spooder.paired_nurse && !spooder.busy && spooder.stance == HOSTILE_STANCE_IDLE)
		spooder.protect(spooder.paired_nurse)

/mob/living/simple_animal/hostile/giant_spider/guard/death(gibbed)
	. = ..()
	if(.)
		divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/guard/divorce()
	if(paired_nurse)
		if(paired_nurse.paired_guard)
			paired_nurse.paired_guard = null
		paired_nurse = null

/mob/living/simple_animal/hostile/giant_spider/guard/proc/find_nurse()
	for(var/mob/living/simple_animal/hostile/giant_spider/nurse/N in ListTargets(10))
		if(N.stat || N.paired_guard)
			continue
		paired_nurse = N
		paired_nurse.paired_guard = src
		return 1

/mob/living/simple_animal/hostile/giant_spider/guard/proc/protect(mob/nurse)
	stop_automated_movement = 1
	walk_to(src, nurse, 2, move_to_delay)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, disable_stop_automated_movement)), 5 SECONDS)

/mob/living/simple_animal/hostile/giant_spider/guard/proc/go_berserk()
	audible_message("<span class='danger'>\The [src] chitters wildly!</span>")
	var/obj/item/attacking_with = get_natural_weapon()
	if(attacking_with)
		attacking_with.force = initial(attacking_with.force) + 5
	move_to_delay--
	break_stuff_probability = 45
	addtimer(CALLBACK(src, PROC_REF(calm_down)), 3 MINUTES)

/mob/living/simple_animal/hostile/giant_spider/guard/proc/calm_down()
	berserking = FALSE
	visible_message("<span class='notice'>\The [src] calms down and surveys the area.</span>")
	var/obj/item/attacking_with = get_natural_weapon()
	if(attacking_with)
		attacking_with.force = initial(attacking_with.force)
	move_to_delay++
	break_stuff_probability = 10

/****************
Nurse caste procs
****************/
/mob/living/simple_animal/hostile/giant_spider/nurse/divorce()
	if(paired_guard)
		if(paired_guard.paired_nurse)
			paired_guard.paired_nurse = null
	paired_guard = null

/mob/living/simple_animal/hostile/giant_spider/nurse/death(gibbed)
	. = ..()
	if(.)
		if(paired_guard)
			paired_guard.vengance = rand(50,100)
			if(prob(paired_guard.vengance))
				paired_guard.berserking = TRUE
				paired_guard.go_berserk()
		divorce()

/mob/living/simple_animal/hostile/giant_spider/nurse/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/nurse/attack_target(mob/target)
	. = ..()
	if(ishuman(.))
		var/mob/living/human/H = .
		if(prob(infest_chance) && max_eggs)
			var/list/limbs = H.get_external_organs()
			var/obj/item/organ/external/O = LAZYLEN(limbs)? pick(limbs) : null
			if(O && !BP_IS_PROSTHETIC(O) && !BP_IS_CRYSTAL(O) && (LAZYLEN(O.implants) < 2))
				var/eggs = new /obj/effect/spider/eggcluster(O, src)
				LAZYADD(O.implants, eggs)
				max_eggs--

/mob/living/simple_animal/hostile/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(100)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
			busy = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/giant_spider/nurse
	ai = /datum/ai/giant_spider/nurse

/datum/ai/giant_spider/nurse
	expected_type = /mob/living/simple_animal/hostile/giant_spider/nurse

/datum/ai/giant_spider/nurse/do_process(time_elapsed)
	. = ..()
	var/mob/living/simple_animal/hostile/giant_spider/nurse/spooder = body
	if(spooder.stance != HOSTILE_STANCE_IDLE)
		spooder.busy = 0
		spooder.stop_automated_movement = 0
		return

	var/list/can_see = view(spooder, 10)
	//30% chance to stop wandering and do something
	if(!spooder.busy && prob(30))
		//first, check for potential food nearby to cocoon
		for(var/mob/living/web_target in can_see)
			if(is_type_in_list(web_target, spooder.cocoon_blacklist))
				continue
			if(web_target.stat)
				spooder.cocoon_target = web_target
				spooder.busy = MOVING_TO_TARGET
				walk_to(spooder, web_target, 1, spooder.move_to_delay)
				//give up if we can't reach them after 10 seconds
				spooder.GiveUp(web_target)
				return

		//second, spin a sticky spiderweb on this tile
		var/obj/effect/spider/stickyweb/W = locate() in get_turf(spooder)
		if(!W)
			spooder.busy = SPINNING_WEB
			spooder.visible_message(SPAN_NOTICE("\The [spooder] begins to secrete a sticky substance."))
			spooder.stop_automated_movement = 1
			spawn(4 SECONDS)
				if(spooder.busy == SPINNING_WEB)
					new /obj/effect/spider/stickyweb(spooder.loc)
					spooder.busy = 0
					spooder.stop_automated_movement = 0
		else
			//third, lay an egg cluster there
			var/obj/effect/spider/eggcluster/E = locate() in get_turf(spooder)
			if(!E && spooder.fed > 0 && spooder.max_eggs)
				spooder.busy = LAYING_EGGS
				spooder.visible_message(SPAN_NOTICE("\The [spooder] begins to lay a cluster of eggs."))
				spooder.stop_automated_movement = 1
				spawn(5 SECONDS)
					if(spooder.busy == LAYING_EGGS)
						E = locate() in get_turf(spooder)
						if(!E)
							new /obj/effect/spider/eggcluster(spooder.loc, spooder)
							spooder.max_eggs--
							spooder.fed--
						spooder.busy = 0
						spooder.stop_automated_movement = 0
			else
				//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
				for(var/obj/O in can_see)

					if(O.anchored)
						continue

					if(is_type_in_list(O, spooder.cocoon_blacklist))
						continue

					if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
						spooder.cocoon_target = O
						spooder.busy = MOVING_TO_TARGET
						spooder.stop_automated_movement = 1
						walk_to(spooder, O, 1, spooder.move_to_delay)
						//give up if we can't reach them after 10 seconds
						spooder.GiveUp(O)

	else if(spooder.busy == MOVING_TO_TARGET && spooder.cocoon_target)
		if(spooder.Adjacent(spooder.cocoon_target))
			spooder.busy = SPINNING_COCOON
			spooder.visible_message(SPAN_NOTICE("\The [spooder] begins to secrete a sticky substance around \the [spooder.cocoon_target]."))
			spooder.stop_automated_movement = 1
			walk(spooder,0)
			spawn(5 SECONDS)
				if(spooder.busy == SPINNING_COCOON)
					if(spooder.cocoon_target && isturf(spooder.cocoon_target.loc) && get_dist(spooder, spooder.cocoon_target) <= 1)
						var/obj/effect/spider/cocoon/C = new(spooder.cocoon_target.loc)
						var/large_cocoon = 0
						C.pixel_x = spooder.cocoon_target.pixel_x
						C.pixel_y = spooder.cocoon_target.pixel_y
						for(var/mob/living/M in C.loc)
							large_cocoon = 1
							spooder.fed++
							spooder.max_eggs++
							spooder.visible_message(SPAN_WARNING("\The [spooder] sticks a proboscis into \the [spooder.cocoon_target] and sucks a viscous substance out."))
							M.forceMove(C)
							C.pixel_x = M.pixel_x
							C.pixel_y = M.pixel_y
							break
						for(var/obj/item/I in C.loc)
							I.forceMove(C)
						for(var/obj/structure/S in C.loc)
							if(!S.anchored)
								S.forceMove(C)
						for(var/obj/machinery/M in C.loc)
							if(!M.anchored)
								M.forceMove(C)
						if(large_cocoon)
							C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
					spooder.busy = 0
					spooder.stop_automated_movement = 0

/*****************
Hunter caste procs
*****************/
/mob/living/simple_animal/hostile/giant_spider/hunter/MoveToTarget(var/move_only = FALSE)
	if(!can_act() || perform_maneuver(/decl/maneuver/leap/spider, target_mob))
		return
	..()

/mob/living/simple_animal/hostile/giant_spider/hunter/get_jump_distance()
	return leap_range

/mob/living/simple_animal/hostile/giant_spider/hunter/perform_maneuver(var/maneuver, var/atom/target)
	if(!isliving(target) || get_dist(src, target) <= 3)
		return FALSE
	walk(src,0)
	var/first_stop_automation
	if(stop_automation)
		first_stop_automation = stop_automation
		stop_automation = TRUE
	. = ..()
	if(!isnull(first_stop_automation))
		stop_automation = first_stop_automation

/mob/living/simple_animal/hostile/giant_spider/hunter/throw_impact(atom/hit_atom)
	..()
	if(isliving(hit_atom))
		var/mob/living/target = hit_atom
		stop_automation = FALSE
		visible_message(SPAN_DANGER("\The [src] slams into \the [target], knocking them over!"))
		SET_STATUS_MAX(target, STAT_WEAK, 1)
		MoveToTarget()

/******************
Spitter caste procs
******************/
/mob/living/simple_animal/hostile/giant_spider/spitter/handle_regular_status_updates()
	. = ..()
	if(!.)
		return FALSE
	if(venom_charge <= 0)
		ranged = FALSE
		if(prob(25))
			venom_charge++
			if(venom_charge >= 8)
				ranged = TRUE

/mob/living/simple_animal/hostile/giant_spider/spitter/Shoot()
	. = ..()
	if(.)
		venom_charge--

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
