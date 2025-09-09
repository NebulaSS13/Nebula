/obj/effect/blob
	name = "pulsating mass"
	desc = "A pulsating mass of interwoven tendrils."
	icon = 'mods/content/blob/icons/blob.dmi'
	icon_state = "blob"
	light_range = 2
	light_color = BLOB_COLOR_PULS
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_PRIORITY

	layer = BLOB_SHIELD_LAYER

	max_health = 15

	var/regen_rate = 2.5
	var/brute_damage_divisor = 4.3
	var/fire_damage_divisor = 1.1
	var/laser_damage_divisor = 2	// Special resist for laser based weapons - Emitters or handheld energy weaponry. Damage is divided by this and THEN by fire_damage_divisor.
	var/expandType = /obj/effect/blob
	var/secondary_core_growth_chance = 2.5 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.
	var/damage_min = 15
	var/damage_max = 30
	var/pruned = FALSE
	var/product = /obj/item/blob_sample/tendril
	var/attack_freq = 8 //see proc/attempt_attack; lower is more often, min 1. must be an integet

/obj/effect/blob/Initialize()
	. = ..()
	update_icon()
	START_PROCESSING(SSblob, src)

/obj/effect/blob/Destroy()
	STOP_PROCESSING(SSblob, src)
	. = ..()

/obj/effect/blob/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1
	return 0

/obj/effect/blob/explosion_act(var/severity)
	SHOULD_CALL_PARENT(FALSE)
	take_damage(rand(140 - (severity * 40), 140 - (severity * 20)) / brute_damage_divisor)

/obj/effect/blob/on_update_icon()
	if(current_health > get_max_health() / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/Process(wait, tick)
	regen()
	if(tick % attack_freq)
		return
	attempt_attack(global.alldirs)

/obj/effect/blob/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	current_health -= damage
	if(current_health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/effect/blob/proc/regen()
	current_health = min(current_health + regen_rate, get_max_health())
	update_icon()

/// Attempts to expand the blob into the specified turf, damaging objects in the way.
/// Returns FALSE if the expansion was blocked, returns the new blob instance if successful.
/obj/effect/blob/proc/expand(var/turf/target_turf)
	if(target_turf.blob_act(src)) // don't expand if blob_act hits anything
		return FALSE

	if(!(locate(/obj/effect/blob/core) in range(target_turf, 2)) && prob(secondary_core_growth_chance))
		. = new /obj/effect/blob/core/secondary(target_turf)
	else
		. = new expandType(target_turf, min(current_health, 30))

/obj/effect/blob/proc/do_pulse(var/forceLeft, var/list/dirs)
	set waitfor = FALSE
	sleep(8)
	var/turf/target_turf
	var/list/remaining_dirs = dirs.Copy()
	while(!target_turf && length(remaining_dirs))
		var/pushDir = pick_n_take(remaining_dirs)
		target_turf = get_step_resolving_mimic(src, pushDir)
	if(!target_turf) // We're not next to ANYWHERE?!
		return
	var/obj/effect/blob/other_blob = (locate() in target_turf)
	if(!other_blob)
		if(prob(current_health))
			expand(target_turf)
		return
	if(forceLeft)
		other_blob.do_pulse(forceLeft - 1, dirs)

/obj/effect/blob/proc/attack_living(var/mob/living/victim)
	if(!victim || victim.stat == DEAD)
		return
	var/blob_damage = pick(BRUTE, BURN)
	victim.visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [victim]!"), SPAN_DANGER("A tendril flies out from \the [src] and smashes into you!"))
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	victim.apply_damage(rand(damage_min, damage_max), blob_damage, used_weapon = "blob tendril")

/obj/effect/blob/proc/attempt_attack(var/list/dirs)
	var/turf/target_turf
	var/list/remaining_dirs = dirs.Copy()
	while(!target_turf && length(remaining_dirs))
		var/attackDir = pick_n_take(remaining_dirs)
		target_turf = get_step_resolving_mimic(src, attackDir)
	if(!target_turf)
		return
	target_turf.blob_act()

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.atom_damage_type)
		if(BRUTE)
			take_damage(Proj.damage / brute_damage_divisor, Proj.atom_damage_type)
		if(BURN)
			take_damage((Proj.damage / laser_damage_divisor) / fire_damage_divisor, Proj.atom_damage_type)
	return 0

/obj/effect/blob/attackby(var/obj/item/used_item, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	if(IS_WIRECUTTER(used_item))
		if(prob(user.skill_fail_chance(SKILL_SCIENCE, 90, SKILL_EXPERT)))
			to_chat(user, SPAN_WARNING("You fail to collect a sample from \the [src]."))
			return TRUE
		else
			if(!pruned)
				to_chat(user, SPAN_NOTICE("You collect a sample from \the [src]."))
				new product(user.loc)
				pruned = TRUE
				return TRUE
			else
				to_chat(user, SPAN_WARNING("\The [src] has already been pruned."))
				return TRUE

	var/damage = 0
	switch(used_item.atom_damage_type)
		if(BURN)
			damage = (used_item.expend_attack_force(user) / fire_damage_divisor)
			if(IS_WELDER(used_item))
				playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		if(BRUTE)
			damage = (used_item.expend_attack_force(user) / brute_damage_divisor)

	take_damage(damage, used_item.atom_damage_type)
	return TRUE

// TODO: readd weedkiller spray damage, which seems to have been lost at some point

/obj/effect/blob/core
	name = "master nucleus"
	desc = "A massive, fragile nucleus guarded by a shield of thick tendrils."
	icon_state = "blob_core"
	max_health = 225
	damage_min = 30
	damage_max = 40
	expandType = /obj/effect/blob/shield
	product = /obj/item/blob_sample/core

	light_color = BLOB_COLOR_CORE
	layer = BLOB_CORE_LAYER

	var/blob_may_process = 1
	var/reported_low_damage = FALSE
	var/times_to_pulse = 0

/*
the master core becomes more vulnereable to damage as it weakens,
but it also becomes more aggressive, and channels more of its energy into regenerating rather than spreading
regen() will cover update_icon() for this proc
*/
/obj/effect/blob/core/proc/process_core_health()
	switch(get_health_percent())
		if(75 to INFINITY)
			brute_damage_divisor = 3.5
			fire_damage_divisor = 2.5
			attack_freq = 5
			regen_rate = 2
			times_to_pulse = 4
			if(reported_low_damage)
				report_shield_status("high")
		if(50 to 74)
			brute_damage_divisor = 2.5
			fire_damage_divisor = 2
			attack_freq = 4
			regen_rate = 3
			times_to_pulse = 3
		if(34 to 49)
			brute_damage_divisor = 1
			fire_damage_divisor = 1.1
			attack_freq = 3
			regen_rate = 4
			times_to_pulse = 2
		if(-INFINITY to 33)
			brute_damage_divisor = 0.5
			fire_damage_divisor = 0.35
			regen_rate = 5
			times_to_pulse = 1
			if(!reported_low_damage)
				report_shield_status("low")

/obj/effect/blob/core/proc/report_shield_status(var/status)
	if(status == "low")
		visible_message(SPAN_DANGER("\The [src]'s tendril shield fails, leaving the nucleus vulnerable!"), 3)
		reported_low_damage = TRUE
	if(status == "high")
		visible_message(SPAN_NOTICE("\The [src]'s tendril shield seems to have fully reformed."), 3)
		reported_low_damage = FALSE

// Rough icon state changes that reflect the core's current_health
/obj/effect/blob/core/on_update_icon()
	switch(get_health_percent())
		if(66 to INFINITY)
			icon_state = "blob_core"
		if(33 to 66)
			icon_state = "blob_node"
		if(-INFINITY to 33)
			icon_state = "blob_factory"

/obj/effect/blob/core/Process()
	if(!blob_may_process)
		return
	blob_may_process = 0
	process_core_health()
	regen()
	for(var/i in 1 to times_to_pulse)
		do_pulse(20, global.alldirs)
	attempt_attack(global.alldirs)
	attempt_attack(global.alldirs)
	blob_may_process = 1

// Blob has a very small probability of growing these when spreading. These will spread the blob further.
/obj/effect/blob/core/secondary
	name = "auxiliary nucleus"
	desc = "An interwoven mass of tendrils. A glowing nucleus pulses at its center."
	icon_state = "blob_node"
	max_health = 65
	regen_rate = 1
	damage_min = 15
	damage_max = 20
	layer = BLOB_NODE_LAYER
	product = /obj/item/blob_sample/core/aux
	times_to_pulse = 4

/obj/effect/blob/core/secondary/process_core_health()
	return

/obj/effect/blob/core/secondary/on_update_icon()
	icon_state = (current_health / get_max_health() >= 0.5) ? "blob_node" : "blob_factory"

/obj/effect/blob/shield
	name = "shielding mass"
	desc = "A pulsating mass of interwoven tendrils. These seem particularly robust, but not quite as active."
	icon_state = "blob_idle"
	max_health = 60
	damage_min = 13
	damage_max = 25
	attack_freq = 8
	regen_rate = 4
	expandType = /obj/effect/blob/ravaging
	light_color = BLOB_COLOR_SHIELD

/obj/effect/blob/shield/Initialize()
	. = ..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	set_density(0)
	update_nearby_tiles()
	return ..()

/obj/effect/blob/shield/on_update_icon()
	var/current_max_health = get_max_health()
	if(current_health > current_max_health * 2 / 3)
		icon_state = "blob_idle"
	else if(current_health > current_max_health / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density

/obj/effect/blob/ravaging
	name = "ravaging mass"
	desc = "A mass of interwoven tendrils. They thrash around haphazardly at anything in reach."
	max_health = 10
	damage_min = 27
	damage_max = 36
	attack_freq = 3
	light_color = BLOB_COLOR_RAV
	color = "#ffd400" //Temporary, for until they get a new sprite.
