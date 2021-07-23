/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	temperature = T0C + 300
	fire_sound='sound/weapons/Laser.ogg'
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 40
	damage_type = BURN
	sharp = 1 //concentrated burns
	damage_flags = DAM_LASER
	eyeblur = 4
	hitscan = 1
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine
	penetration_modifier = 0.3
	distance_falloff = 2.5

	muzzle_type = /obj/effect/projectile/muzzle/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/item/projectile/beam/variable
	muzzle_type = /obj/effect/projectile/muzzle/variable
	tracer_type = /obj/effect/projectile/tracer/variable
	impact_type = /obj/effect/projectile/impact/variable

/obj/item/projectile/beam/variable/after_move()
	. = ..()
	var/obj/effect/projectile/invislight/light = locate() in loc
	if(light)
		light.light_color = color
		light.set_light(l_color = light.light_color)

/obj/item/projectile/beam/variable/update_effect(var/obj/effect/projectile/effect)
	effect.color = color
	effect.set_light(l_color = effect.light_color)

/obj/item/projectile/beam/variable/split
	muzzle_type = /obj/effect/projectile/muzzle/variable_heavy
	tracer_type = /obj/effect/projectile/tracer/variable_heavy
	impact_type = /obj/effect/projectile/impact/variable_heavy
	var/split_type = /obj/item/projectile/beam/variable
	var/split_count = 3

/obj/item/projectile/beam/variable/split/on_impact(var/atom/A)
	if(split_type)
		var/list/targets = list()
		var/split_loc = get_turf(A)
		if(split_loc)
			for(var/turf/T in view(5, split_loc))
				targets += T
			for(var/i = 1 to split_count)
				if(!length(targets))
					break
				var/obj/item/projectile/P = new split_type(split_loc)
				P.color = color
				P.light_color = color
				P.firer = firer
				P.shot_from = shot_from
				P.damage = FLOOR(damage/split_count)
				P.armor_penetration = FLOOR(armor_penetration/split_count)
				P.launch(pick_n_take(targets), def_zone)
	. = ..()

/obj/item/projectile/beam/practice
	fire_sound = 'sound/weapons/Taser.ogg'
	damage = 2
	eyeblur = 2

/obj/item/projectile/beam/smalllaser
	damage = 25
	armor_penetration = 10

/obj/item/projectile/beam/midlaser
	damage = 50
	armor_penetration = 20
	distance_falloff = 1

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	damage = 60
	armor_penetration = 30
	distance_falloff = 0.5

	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/item/projectile/beam/xray
	name = "x-ray beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	damage = 30
	armor_penetration = 30
	penetration_modifier = 0.8

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/xray/midlaser
	damage = 30
	armor_penetration = 50

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	fire_sound='sound/weapons/pulse.ogg'
	damage = 15 //lower damage, but fires in bursts

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/beam/pulse/destroy
	name = "destroyer pulse"
	damage = 100 //badmins be badmins I don't give a fuck
	armor_penetration = 100

/obj/item/projectile/beam/pulse/destroy/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		target.explosion_act(2)
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 // The actual damage is computed in /code/modules/power/singularity/emitter.dm

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN

	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

/obj/item/projectile/beam/lastertag/blue/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			SET_STATUS_MAX(M, STAT_WEAK, 5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	no_attack_log = 1
	damage_type = BURN

/obj/item/projectile/beam/lastertag/red/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			SET_STATUS_MAX(M, STAT_WEAK, 5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	damage = 0
	damage_type = BURN

	muzzle_type = /obj/effect/projectile/muzzle/cult
	tracer_type = /obj/effect/projectile/tracer/cult
	impact_type = /obj/effect/projectile/impact/cult

/obj/item/projectile/beam/lastertag/omni/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			SET_STATUS_MAX(M, STAT_WEAK, 5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	fire_sound = 'sound/weapons/marauder.ogg'
	damage = 50
	armor_penetration = 10
	stun = 3
	weaken = 3
	stutter = 3

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	damage_flags = 0
	sharp = 0 //not a laser
	damage = 1//flavor burn! still not a laser, dmg will be reduce by energy resistance not laser resistances
	damage_type = BURN
	eyeblur = 1//Some feedback that you've been hit
	agony = 40

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/stun/heavy
	name = "heavy stun beam"
	damage = 2
	agony = 60

/obj/item/projectile/beam/stun/shock
	name = "shock beam"
	agony = 0
	damage = 15
	damage_type = ELECTROCUTE
	fire_sound='sound/weapons/pulse.ogg'

/obj/item/projectile/beam/stun/shock/heavy
	name = "heavy shock beam"
	damage = 30

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	damage = 15
	sharp = 1
	edge = 1
	damage_type = BURN
	life_span = 5
	pass_flags = PASS_FLAG_TABLE
	distance_falloff = 4

	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	tracer_type = /obj/effect/projectile/tracer/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter

/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/exterior) && A.density)
		var/turf/exterior/M = A
		M.physically_destroyed()
	. = ..()

/obj/item/projectile/beam/confuseray
	name = "disorientator ray"
	icon_state = "beam_grass"
	fire_sound='sound/weapons/confuseray.ogg'
	damage = 2
	agony = 7
	sharp = FALSE
	distance_falloff = 5
	damage_flags = 0
	damage_type = STUN
	life_span = 3
	penetration_modifier = 0
	var/potency_min = 4
	var/potency_max = 6

	muzzle_type = /obj/effect/projectile/muzzle/disabler
	tracer_type = /obj/effect/projectile/tracer/disabler
	impact_type = /obj/effect/projectile/impact/disabler

/obj/item/projectile/beam/confuseray/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		var/potency = rand(potency_min, potency_max)
		ADJ_STATUS(L, STAT_CONFUSE, potency)
		ADJ_STATUS(L, STAT_BLURRY, potency)
		if(GET_STATUS(L, STAT_CONFUSE) >= 10)
			SET_STATUS_MAX(L, STAT_STUN, 1)
	return 1

/obj/item/projectile/beam/particle
	name = "particle lance"
	icon_state = "particle"
	damage = 35
	armor_penetration = 50
	muzzle_type = /obj/effect/projectile/muzzle/particle
	tracer_type = /obj/effect/projectile/tracer/particle
	impact_type = /obj/effect/projectile/impact/particle
	penetration_modifier = 0.5

/obj/item/projectile/beam/particle/small
	name = "particle beam"
	damage = 20
	armor_penetration = 20
	penetration_modifier = 0.3

/obj/item/projectile/beam/darkmatter
	name = "dark matter bolt"
	icon_state = "darkb"
	damage = 40
	armor_penetration = 35
	damage_type = BRUTE
	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter

/obj/item/projectile/beam/stun/darkmatter
	name = "dark matter wave"
	icon_state = "darkt"
	damage_flags = 0
	sharp = 0 //not a laser
	agony = 40
	damage_type = STUN
	muzzle_type = /obj/effect/projectile/muzzle/darkmattertaser
	tracer_type = /obj/effect/projectile/tracer/darkmattertaser
	impact_type = /obj/effect/projectile/impact/darkmattertaser

/obj/item/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage = 15
	damage_type = ELECTROCUTE //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	muzzle_type = /obj/effect/projectile/muzzle/pd
	tracer_type = /obj/effect/projectile/tracer/pd
	impact_type = /obj/effect/projectile/impact/pd

/obj/item/projectile/beam/incendiary_laser
	name = "scattered laser blast"
	icon_state = "beam_incen"
	fire_sound='sound/weapons/scan.ogg'
	damage = 12
	agony = 8
	eyeblur = 8
	sharp = FALSE
	damage_flags = 0
	life_span = 8
	penetration_modifier = 0.1

	muzzle_type = /obj/effect/projectile/muzzle/incen
	tracer_type = /obj/effect/projectile/tracer/incen
	impact_type = /obj/effect/projectile/impact/incen

/obj/item/projectile/beam/incendiary_laser/on_hit(var/atom/target, var/blocked = 0)
	..()
	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(rand(2,4))
		if(L.fire_stacks >= 3)
			L.IgniteMob()

/obj/item/projectile/beam/pop
	icon_state = "bluelaser"
	fire_sound = 'sound/weapons/gunshot/laserbulb.ogg'
	fire_sound_vol = 100

	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue