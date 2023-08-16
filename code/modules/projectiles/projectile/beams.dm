/obj/item/projectile/beam
	name = "laser"
	fire_sound='sound/weapons/Laser.ogg'
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_LASER_MEAT, BULLET_IMPACT_METAL = SOUNDS_LASER_METAL)

	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GLASS | PASS_FLAG_GRILLE
	temperature = T0C + 300

	damage               = 50
	armor_penetration    = 25
	eyeblur              = 5
	penetration_modifier = 0.5
	distance_falloff     = 0.5

	damage_type  = BURN
	damage_flags = DAM_LASER
	hitscan      = TRUE
	sharp        = TRUE

	invisibility = 101
	muzzle_type = /obj/effect/projectile/muzzle/variable
	tracer_type = /obj/effect/projectile/tracer/variable
	impact_type = /obj/effect/projectile/impact/variable
	color = COLOR_RED
	var/variable_beam = FALSE

/obj/item/projectile/beam/Initialize()
	if(ispath(tracer_type,/obj/effect/projectile/tracer/variable))
		variable_beam = TRUE
	. = ..()

/obj/item/projectile/beam/after_move()
	. = ..()
	if(variable_beam)
		var/obj/effect/projectile/invislight/light = locate() in loc
		if(light)
			light.light_color = color
			light.set_light(l_color = light.light_color)
	else
		color = null

/obj/item/projectile/beam/update_effect(var/obj/effect/projectile/effect)
	if(variable_beam)
		effect.color = color
		effect.set_light(l_color = effect.light_color)
	else
		color = null

//Lasers

/obj/item/projectile/beam/small
	name = "small laser"
	damage = 25
	armor_penetration = 10
	penetration_modifier = 0.1

/obj/item/projectile/beam/heavy
	name = "heavy laser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

	damage = 70
	armor_penetration = 35
	eyeblur = 10
	penetration_modifier = 1

	muzzle_type = /obj/effect/projectile/muzzle/variable/heavy
	tracer_type = /obj/effect/projectile/tracer/variable/heavy
	impact_type = /obj/effect/projectile/impact/variable/heavy

/obj/item/projectile/beam/heavy/pop
	fire_sound = 'sound/weapons/gunshot/laserbulb.ogg'
	fire_sound_vol = 100

	penetration_modifier = 1.5
	color = COLOR_VIOLET

/obj/item/projectile/beam/practice
	fire_sound = 'sound/weapons/Taser.ogg'

	damage = 2
	eyeblur = 2
	penetration_modifier = 0
	sharp = FALSE

//Xray

/obj/item/projectile/beam/xray
	name = "x-ray beam"
	fire_sound = 'sound/weapons/laser3.ogg'

	damage = 80
	armor_penetration = 80
	penetration_modifier = 3

	color = COLOR_GREEN

/obj/item/projectile/beam/xray/heavy
	name = "heavy x-ray beam"
	fire_sound = 'sound/weapons/marauder.ogg'

	damage = 160
	armor_penetration = 160
	penetration_modifier = 4
	stun = 10
	weaken = 10

	muzzle_type = /obj/effect/projectile/muzzle/variable/heavy
	tracer_type = /obj/effect/projectile/tracer/variable/heavy
	impact_type = /obj/effect/projectile/impact/variable/heavy

//Capacitor

/obj/item/projectile/beam/variable
	muzzle_type = /obj/effect/projectile/muzzle/variable
	tracer_type = /obj/effect/projectile/tracer/variable
	impact_type = /obj/effect/projectile/impact/variable

/obj/item/projectile/beam/variable/heavy
	muzzle_type = /obj/effect/projectile/muzzle/variable/heavy
	tracer_type = /obj/effect/projectile/tracer/variable/heavy
	impact_type = /obj/effect/projectile/impact/variable/heavy

/obj/item/projectile/beam/variable/split
	muzzle_type = /obj/effect/projectile/muzzle/variable/heavy
	tracer_type = /obj/effect/projectile/tracer/variable/heavy
	impact_type = /obj/effect/projectile/impact/variable/heavy
	var/split_type = /obj/item/projectile/beam/variable/heavy
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

//Stun/shock

/obj/item/projectile/beam/stun
	name = "stun beam"
	fire_sound = 'sound/weapons/Taser.ogg'

	damage_type = BURN
	damage_flags = 0
	sharp = FALSE
	damage = 5
	eyeblur = 10
	agony = 30

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/stun/heavy
	name = "shock beam"
	fire_sound='sound/weapons/pulse.ogg'

	damage_type = ELECTROCUTE
	damage = 30
	eyeblur = 20

/obj/item/projectile/beam/stun/light
	name = "stun ray"
	fire_sound='sound/weapons/confuseray.ogg'

	damage_type = STUN
	damage = 0
	agony = 5
	penetration_modifier = 0

	life_span = 3
	distance_falloff = 5

	muzzle_type = /obj/effect/projectile/muzzle/disabler
	tracer_type = /obj/effect/projectile/tracer/disabler
	impact_type = /obj/effect/projectile/impact/disabler

/obj/item/projectile/beam/stun/light/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		var/potency = rand(3,6)
		ADJ_STATUS(L, STAT_CONFUSE, potency)
		ADJ_STATUS(L, STAT_BLURRY,  potency)
		if(GET_STATUS(L, STAT_CONFUSE) >= 10)
			SET_STATUS_MAX(L, STAT_STUN, 1)
	return 1

//Plasmacutter

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'

	damage = 60 //it can cut off limbs, they said...
	edge = TRUE
	damage_type = BURN
	life_span = 5
	pass_flags = PASS_FLAG_TABLE
	distance_falloff = 4

	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	tracer_type = /obj/effect/projectile/tracer/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter

/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/exterior/wall))
		var/turf/exterior/wall/M = A
		M.dismantle_wall()
	. = ..()

//Pulse

/obj/item/projectile/beam/pulse
	name = "pulse"
	fire_sound='sound/weapons/pulse.ogg'
	damage = 15

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

//Special

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	fire_sound = 'sound/weapons/emitter.ogg'
	damage = 0 //see emitter code

	muzzle_type = /obj/effect/projectile/muzzle/emitter
	tracer_type = /obj/effect/projectile/tracer/emitter
	impact_type = /obj/effect/projectile/impact/emitter

//Lasertag

/obj/item/projectile/beam/tag
	name = "lasertag beam"
	damage = 0
	no_attack_log = TRUE
	var/required_suit = /obj/item/clothing/suit/bluetag

/obj/item/projectile/beam/tag/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.get_equipped_item(slot_wear_suit_str), required_suit))
			SET_STATUS_MAX(M, STAT_WEAK, 5)
	return 1

/obj/item/projectile/beam/tag/blue
	required_suit = /obj/item/clothing/suit/redtag
	color = COLOR_BLUE

//PD

/obj/item/projectile/beam/pointdefense
	name = "point defense salvo"
	damage = 15
	damage_type = ELECTROCUTE //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	muzzle_type = /obj/effect/projectile/muzzle/pd
	tracer_type = /obj/effect/projectile/tracer/pd
	impact_type = /obj/effect/projectile/impact/pd

