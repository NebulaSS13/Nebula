/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"

	temperature  = T0C + 300
	damage_type  = BURN
	damage       = 0
	damage_flags = 0

//Ion

/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	fire_sound = 'sound/weapons/Laser.ogg'
	nodamage = TRUE
	var/heavy_effect_range = 1
	var/light_effect_range = 2

/obj/item/projectile/ion/on_impact(var/atom/A)
	empulse(A, heavy_effect_range, light_effect_range)
	return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	heavy_effect_range = 0
	light_effect_range = 1

/obj/item/projectile/ion/tiny
	heavy_effect_range = 0
	light_effect_range = 0

//Flash round

/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 5
	agony = 10
	life_span = 15 //if the shell hasn't hit anything after travelling this far it just explodes.

	var/flash_range = 1
	var/brightness = 7
	var/light_flash_color = COLOR_WHITE

	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind and confuse adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_MAJOR)
			M.flash_eyes()
			ADJ_STATUS(M, STAT_BLURRY, brightness / 2)
			ADJ_STATUS(M, STAT_CONFUSE, brightness / 2)

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	spark_at(T, amount=2, cardinal_only = TRUE)

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/effect/smoke/illumination(T, 5, 4, 1, light_flash_color)

/obj/item/projectile/energy/flash/flare
	agony = 20 //ghetto stun
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	flash_range = 2
	brightness = 15

/obj/item/projectile/energy/flash/flare/on_impact(var/atom/A)
	light_flash_color = pick("#e58775", "#ffffff", "#faa159", "#e34e0e")
	set_light(4, 2, light_flash_color)
	..() //initial flash

	//residual illumination
	new /obj/effect/effect/smoke/illumination(loc, rand(190,240), 8, 1, light_flash_color) //same lighting power as flare

	var/turf/TO = get_turf(src)
	var/area/AO = TO.loc
	if(AO && (AO.area_flags & AREA_FLAG_EXTERNAL))
		//Everyone saw that!
		for(var/mob/living/mob in global.living_mob_list_)
			var/turf/T = get_turf(mob)
			var/area/A1 = T.loc
			if(T && (T != TO) && (TO.z == T.z) && !mob.blinded)
				var/visible = FALSE
				if(A1 && (A1.area_flags & AREA_FLAG_EXTERNAL))
					visible = TRUE
				else
					var/dir = get_dir(T,TO)
					var/turf/pos = T
					for (var/j in 0 to 5)
						pos = get_step(pos, dir)
						if(pos.opacity)
							break
						A1 = pos.loc
						if(A1 && (A1.area_flags & AREA_FLAG_EXTERNAL))
							visible = TRUE
							break
				if(visible)
					to_chat(mob, SPAN_NOTICE("You see a bright light to \the [dir2text(get_dir(T,TO))]."))
			CHECK_TICK

//Stun shell

/obj/item/projectile/energy/stun
	name = "electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Taser.ogg'
	agony = 50
	damage = 5
	eyeblur = 10
	step_delay = 2

/obj/item/projectile/energy/stun/heavy
	agony = 80

//Toxin

/obj/item/projectile/energy/toxin
	name = "toxin bolt"
	icon_state = "energy"
	fire_sound = 'sound/weapons/pulse3.ogg'

	damage_type = TOX
	damage      = 60
	irradiate   = 60