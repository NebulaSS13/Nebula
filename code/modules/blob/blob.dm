/obj/effect/blob
	name = "pulsating mass"
	desc = "A pulsating mass of interwoven tendrils."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_range = 2
	light_color = BLOB_COLOR_PULS
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_PRIORITY

	layer = BLOB_SHIELD_LAYER

	max_health = 30

	var/regen_rate = 5

	// TODO: make blobs use either damage handlers or an armour extension (or both?).
	var/list/blob_damage_resistance = list(
		ARMOR_BULLET = 4.3,
		ARMOR_BOMB   = 4.3,
		ARMOR_MELEE  = 4.3,
		ARMOR_LASER  = 2,
		ARMOR_ENERGY = 0.8
	)
	var/static/list/blob_damage_immunity = list(
		ARMOR_RAD,
		ARMOR_BIO
	)

	var/expandType = /obj/effect/blob
	var/secondary_core_growth_chance = 5 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.
	var/damage_min = 15
	var/damage_max = 30
	var/pruned = FALSE
	var/product = /obj/item/blob_tendril
	var/attack_freq = 5 //see proc/attempt_attack; lower is more often, min 1

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
	take_damage(rand(140 - (severity * 40), 140 - (severity * 20)), BRUTE)

/obj/effect/blob/on_update_icon()
	if(health > max_health / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/Process(wait, tick)
	regen()
	if(tick % attack_freq)
		return
	attempt_attack(global.alldirs)

/obj/effect/blob/take_damage(damage, damage_type = BRUTE, def_zone, damage_flags = 0, used_weapon, armor_pen, silent = FALSE, override_droplimb, skip_update_health = FALSE)

	var/decl/damage_handler/damage_type_data = GET_DECL(damage_type)
	var/armor_key = damage_type_data?.get_armor_key(damage_flags)
	if(armor_key in blob_damage_immunity)
		return FALSE

	if(armor_key in blob_damage_resistance)
		damage = round(damage / blob_damage_resistance[armor_key])

	if(damage <= 0)
		return FALSE

	health -= damage
	if(health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/effect/blob/proc/regen()
	health = min(health + regen_rate, max_health)
	update_icon()

/obj/effect/blob/proc/expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || isspaceturf(T))
		return
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(80, BRUTE)
		return
	var/obj/structure/girder/G = locate() in T
	if(G)
		if(prob(40))
			G.dismantle()
		return
	var/obj/structure/window/W = locate() in T
	if(W)
		W.shatter()
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return
	for(var/obj/machinery/door/D in T) // There can be several - and some of them can be open, locate() is not suitable
		if(D.density)
			D.explosion_act(2)
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle/V = locate() in T
	if(V)
		V.explosion_act(2)
		return
	var/obj/machinery/camera/CA = locate() in T
	if(CA)
		CA.take_damage(30, BRUTE)
		return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		attack_living(L)

	if(!(locate(/obj/effect/blob/core) in range(T, 2)) && prob(secondary_core_growth_chance))
		new/obj/effect/blob/core/secondary(T)
	else
		new expandType(T, min(health, 30))

/obj/effect/blob/proc/do_pulse(var/forceLeft, var/list/dirs)
	set waitfor = FALSE
	sleep(4)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(health))
			expand(T)
		return
	if(forceLeft)
		B.do_pulse(forceLeft - 1, dirs)

/obj/effect/blob/proc/attack_living(var/mob/L)
	if(!L)
		return
	L.visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [L]!"), SPAN_DANGER("A tendril flies out from \the [src] and smashes into you!"))
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	L.take_damage(rand(damage_min, damage_max), pick(BRUTE, BURN), used_weapon = "blob tendril")

/obj/effect/blob/proc/attempt_attack(var/list/dirs)
	var/attackDir = pick(dirs)
	var/turf/T = get_step(src, attackDir)
	for(var/mob/living/victim in T)
		if(victim.stat == DEAD)
			continue
		attack_living(victim)

/obj/effect/blob/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	if(IS_WIRECUTTER(W))
		if(prob(user.skill_fail_chance(SKILL_SCIENCE, 90, SKILL_EXPERT)))
			to_chat(user, SPAN_WARNING("You fail to collect a sample from \the [src]."))
			return
		else
			if(!pruned)
				to_chat(user, SPAN_NOTICE("You collect a sample from \the [src]."))
				new product(user.loc)
				pruned = TRUE
				return
			else
				to_chat(user, SPAN_WARNING("\The [src] has already been pruned."))
				return

	take_damage(W.force, W.damtype)
	if(IS_WELDER(W) && W.damtype == BURN)
		playsound(loc, 'sound/items/Welder.ogg', 100, 1)

/obj/effect/blob/core
	name = "master nucleus"
	desc = "A massive, fragile nucleus guarded by a shield of thick tendrils."
	icon_state = "blob_core"
	max_health = 450
	damage_min = 30
	damage_max = 40
	expandType = /obj/effect/blob/shield
	product = /obj/item/blob_tendril/core

	light_color = BLOB_COLOR_CORE
	layer = BLOB_CORE_LAYER

	var/blob_may_process = 1
	var/reported_low_damage = FALSE
	var/times_to_pulse = 0

/obj/effect/blob/core/proc/get_health_percent()
	return ((health / max_health) * 100)

/*
the master core becomes more vulnereable to damage as it weakens,
but it also becomes more aggressive, and channels more of its energy into regenerating rather than spreading
regen() will cover update_icon() for this proc
*/
/obj/effect/blob/core/proc/process_core_health()
	switch(get_health_percent())
		if(75 to INFINITY)
			blob_damage_resistance[ARMOR_BULLET] = 3.5
			blob_damage_resistance[ARMOR_MELEE]  = 3.5
			blob_damage_resistance[ARMOR_BOMB]   = 3.5
			blob_damage_resistance[ARMOR_ENERGY] = 2
			attack_freq = 5
			regen_rate = 2
			times_to_pulse = 4
			if(reported_low_damage)
				report_shield_status("high")
		if(50 to 74)
			blob_damage_resistance[ARMOR_BULLET] = 2.5
			blob_damage_resistance[ARMOR_MELEE]  = 2.5
			blob_damage_resistance[ARMOR_BOMB]   = 2.5
			blob_damage_resistance[ARMOR_ENERGY] = 1.5
			attack_freq = 4
			regen_rate = 3
			times_to_pulse = 3
		if(34 to 49)
			blob_damage_resistance[ARMOR_BULLET] = 1
			blob_damage_resistance[ARMOR_MELEE]  = 1
			blob_damage_resistance[ARMOR_BOMB]   = 1
			blob_damage_resistance[ARMOR_ENERGY] = 0.8
			attack_freq = 3
			regen_rate = 4
			times_to_pulse = 2
		if(-INFINITY to 33)
			blob_damage_resistance[ARMOR_BULLET] = 0.5
			blob_damage_resistance[ARMOR_MELEE]  = 0.5
			blob_damage_resistance[ARMOR_BOMB]   = 0.5
			blob_damage_resistance[ARMOR_ENERGY] = 0.3
			regen_rate = 5
			times_to_pulse = 1
			if(!reported_low_damage)
				report_shield_status("low")

/obj/effect/blob/core/proc/report_shield_status(var/status)
	if(status == "low")
		visible_message(SPAN_DANGER("The [src]'s tendril shield fails, leaving the nucleus vulnerable!"), 3)
		reported_low_damage = TRUE
	if(status == "high")
		visible_message(SPAN_NOTICE("The [src]'s tendril shield seems to have fully reformed."), 3)
		reported_low_damage = FALSE

// Rough icon state changes that reflect the core's health
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
	for(var/I in 1 to times_to_pulse)
		do_pulse(20, global.alldirs)
	attempt_attack(global.alldirs)
	attempt_attack(global.alldirs)
	blob_may_process = 1

// Blob has a very small probability of growing these when spreading. These will spread the blob further.
/obj/effect/blob/core/secondary
	name = "auxiliary nucleus"
	desc = "An interwoven mass of tendrils. A glowing nucleus pulses at its center."
	icon_state = "blob_node"
	max_health = 125
	regen_rate = 1
	damage_min = 15
	damage_max = 20
	layer = BLOB_NODE_LAYER
	product = /obj/item/blob_tendril/core/aux
	times_to_pulse = 4

/obj/effect/blob/core/secondary/process_core_health()
	return

/obj/effect/blob/core/secondary/on_update_icon()
	icon_state = (health / max_health >= 0.5) ? "blob_node" : "blob_factory"

/obj/effect/blob/shield
	name = "shielding mass"
	desc = "A pulsating mass of interwoven tendrils. These seem particularly robust, but not quite as active."
	icon_state = "blob_idle"
	max_health = 120
	damage_min = 13
	damage_max = 25
	attack_freq = 7
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
	if(health > max_health * 2 / 3)
		icon_state = "blob_idle"
	else if(health > max_health / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density

/obj/effect/blob/ravaging
	name = "ravaging mass"
	desc = "A mass of interwoven tendrils. They thrash around haphazardly at anything in reach."
	max_health = 20
	damage_min = 27
	damage_max = 36
	attack_freq = 3
	light_color = BLOB_COLOR_RAV
	color = "#ffd400" //Temporary, for until they get a new sprite.

//produce
/obj/item/blob_tendril
	name = "asteroclast tendril"
	desc = "A tendril removed from an asteroclast. It's entirely lifeless."
	icon = 'icons/mob/blob.dmi'
	icon_state = "tendril"
	item_state = "blob_tendril"
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("smacked", "smashed", "whipped")
	material = /decl/material/solid/organic/plantmatter
	var/is_tendril = TRUE
	var/types_of_tendril = list("solid", "fire")

/obj/item/blob_tendril/get_heat()
	. = max(..(), damtype == BURN ? 1000 : 0)

/obj/item/blob_tendril/Initialize()
	. = ..()
	if(is_tendril)
		var/tendril_type
		tendril_type = pick(types_of_tendril)
		switch(tendril_type)
			if("solid")
				desc = "An incredibly dense, yet flexible, tendril, removed from an asteroclast."
				force = 10
				color = COLOR_BRONZE
				origin_tech = @'{"materials":2}'
			if("fire")
				desc = "A tendril removed from an asteroclast. It's hot to the touch."
				damtype = BURN
				force = 15
				color = COLOR_AMBER
				origin_tech = @'{"powerstorage":2}'

/obj/item/blob_tendril/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(is_tendril && prob(50))
		force--
		if(force <= 0)
			visible_message(SPAN_NOTICE("\The [src] crumbles apart!"))
			user.drop_from_inventory(src)
			new /obj/effect/decal/cleanable/ash(src.loc)
			qdel(src)

/obj/item/blob_tendril/core
	name = "asteroclast nucleus sample"
	desc = "A sample taken from an asteroclast's nucleus. It pulses with energy."
	icon_state = "core_sample"
	item_state = "blob_core"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"materials":4,"wormholes":5,"biotech":7}'
	is_tendril = FALSE

/obj/item/blob_tendril/core/aux
	name = "asteroclast auxiliary nucleus sample"
	desc = "A sample taken from an asteroclast's auxiliary nucleus."
	icon_state = "core_sample_2"
	origin_tech = @'{"materials":2,"wormholes":3,"biotech":4}'
