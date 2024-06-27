/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	temperature = T0C + 300
	damage = 0
	atom_damage_type = BURN
	damage_flags = 0
	distance_falloff = 2.5

//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 5
	agony = 20
	life_span = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	muzzle_type = /obj/effect/projectile/muzzle/bullet
	var/flash_range = 1
	var/brightness = 7
	var/light_flash_color = COLOR_WHITE

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind and confuse adjacent people
	for (var/mob/living/M in viewers(T, flash_range))
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

//blinds people like the flash round, but in a larger area and can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage = 10
	agony = 25
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
			if(T && (T != TO) && (TO.z == T.z) && !mob.is_blind())
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

/obj/item/projectile/energy/electrode	//has more pain than a beam because it's harder to hit
	name = "electrode"
	icon_state = "spark"
	fire_sound = 'sound/weapons/Taser.ogg'
	agony = 50
	damage = 2
	atom_damage_type = BURN
	eyeblur = 1//Some feedback that you've been hit
	step_delay = 0.7

/obj/item/projectile/energy/electrode/green
	icon_state = "spark_green"

/obj/item/projectile/energy/electrode/stunshot
	agony = 80
	damage = 3

/obj/item/projectile/energy/declone
	name = "decloner beam"
	icon_state = "declone"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 30
	atom_damage_type = CLONE
	irradiate = 40

/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	atom_damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	atom_damage_type = TOX
	nodamage = 0
	agony = 40
	stutter = 10

/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20
	agony = 60

/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	atom_damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/radiation
	name = "radiation bolt"
	icon_state = "energy"
	fire_sound = 'sound/effects/stealthoff.ogg'
	damage = 20
	atom_damage_type = TOX
	irradiate = 20

/obj/item/projectile/energy/plasmastun
	name = "plasma pulse"
	icon_state = "plasma_stun"
	fire_sound = 'sound/weapons/blaster.ogg'
	armor_penetration = 10
	life_span = 4
	damage = 5
	agony = 70
	atom_damage_type = BURN
	vacuum_traversal = 0
	var/min_dizziness_amt = 60
	var/med_dizziness_amt = 120
	var/max_dizziness_amt = 300

/obj/item/projectile/energy/plasmastun/proc/bang(var/mob/living/M)

	if(!istype(M))
		return

	to_chat(M, SPAN_DANGER("You hear a loud roar!"))

	var/ear_safety = 0
	if(M.get_sound_volume_multiplier() < 0.2)
		ear_safety += 2
	if(ishuman(M))
		var/mob/living/human/H = M
		if(istype(H.get_equipped_item(slot_head_str), /obj/item/clothing/head/helmet))
			ear_safety += 1

	if(!ear_safety)
		SET_STATUS_MAX(M, STAT_DIZZY, max_dizziness_amt)
		ADJ_STATUS(M, STAT_TINNITUS, rand(1, 10))
		SET_STATUS_MAX(M, STAT_DEAF, 15)

	else if(ear_safety > 1)
		SET_STATUS_MAX(M, STAT_DIZZY, min_dizziness_amt)
	else
		SET_STATUS_MAX(M, STAT_DIZZY, med_dizziness_amt)

	if(GET_STATUS(M, STAT_TINNITUS) >= 15)
		to_chat(M, SPAN_DANGER("Your ears start to ring badly!"))
		if(prob(GET_STATUS(M, STAT_TINNITUS) - 5))
			to_chat(M, SPAN_DANGER("You can't hear anything!"))
			M.add_genetic_condition(GENE_COND_DEAFENED)
	else
		if(GET_STATUS(M, STAT_TINNITUS) >= 5)
			to_chat(M, SPAN_DANGER("Your ears start to ring!"))

/obj/item/projectile/energy/plasmastun/on_hit(var/atom/target)
	bang(target)
	. = ..()

/obj/item/projectile/energy/plasmastun/sonic
	name = "sonic pulse"
	icon_state = "sound"
	fire_sound = 'sound/effects/basscannon.ogg'
	damage = 5
	armor_penetration = 40
	atom_damage_type = BRUTE
	vacuum_traversal = 0
	penetration_modifier = 0.2
	penetrating = 1
	min_dizziness_amt = 10
	med_dizziness_amt = 60
	max_dizziness_amt = 120

/obj/item/projectile/energy/plasmastun/sonic/bang(var/mob/living/M)
	..()
	if(istype(M, /atom/movable) && M.simulated && !M.anchored)
		M.throw_at(get_edge_target_turf(M, get_dir(src, M)), rand(1,5), 6)

/obj/item/projectile/energy/plasmastun/sonic/weak
	agony = 70

/obj/item/projectile/energy/plasmastun/sonic/strong
	damage = 20
	penetrating = 1

/obj/item/projectile/energy/darkmatter
	name = "dark matter pellet"
	icon_state = "dark_pellet"
	fire_sound = 'sound/weapons/eLuger.ogg'
	damage = 10
	armor_penetration = 35
	atom_damage_type = BRUTE
