/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A junky looking robot with four spiky legs."
	icon = 'icons/mob/simple_animal/hivebot.dmi'
	max_health = 55
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectiletype = /obj/item/projectile/beam/smalllaser
	faction = "hivebot"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES
		)
	bleed_colour = SYNTH_BLOOD_COLOR
	gene_damage = -1
	base_animal_type = /mob/living/simple_animal/hostile/hivebot
	butchery_data = /decl/butchery_data/synthetic

/mob/living/simple_animal/hostile/hivebot/check_has_mouth()
	return FALSE

/mob/living/simple_animal/hostile/hivebot/range
	desc = "A junky looking robot with four spiky legs. It's equipped with some kind of small-bore gun."
	ranged = 1
	base_movement_delay = 7

/mob/living/simple_animal/hostile/hivebot/rapid
	ranged = 1
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/strong
	desc = "A junky looking robot with four spiky legs - this one has thick armour plating."
	max_health = 120
	ranged = 1
	can_escape = 1
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT
		)

/mob/living/simple_animal/hostile/hivebot/get_death_message(gibbed)
	return "blows apart!"

/mob/living/simple_animal/hostile/hivebot/death(gibbed)
	. = ..()
	if(. && !gibbed)
		new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
		spark_at(src, cardinal_only = TRUE)
		qdel(src)

/*
Special projectiles
*/
/obj/item/projectile/bullet/gyro/megabot
	name = "microrocket"
	distance_falloff = 1.3
	fire_sound = 'sound/effects/Explosion1.ogg'
	var/gyro_devastation = -1
	var/gyro_heavy_impact = 0
	var/gyro_light_impact = 1

/obj/item/projectile/bullet/gyro/megabot/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, gyro_devastation, gyro_heavy_impact, gyro_light_impact)
	..()

/obj/item/projectile/beam/megabot
	damage = 45
	distance_falloff = 0.5

/*
The megabot
*/
#define ATTACK_MODE_MELEE    "melee"
#define ATTACK_MODE_LASER    "laser"
#define ATTACK_MODE_ROCKET   "rocket"

/mob/living/simple_animal/hostile/hivebot/mega
	name = "hivemind"
	desc = "A huge quadruped robot equipped with a myriad of weaponry."
	icon = 'icons/mob/simple_animal/megabot.dmi'
	max_health = 440
	natural_weapon = /obj/item/natural_weapon/circular_saw
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL
		)
	can_escape = TRUE
	armor_type = /datum/extension/armor/toggle
	ability_cooldown = 3 MINUTES

	pixel_x = -32
	default_pixel_x = -32
	base_movement_delay = 0

	var/attack_mode = ATTACK_MODE_MELEE
	var/num_shots
	var/deactivated

/obj/item/natural_weapon/circular_saw
	name = "giant circular saw"
	attack_verb = list("sawed", "ripped")
	force = 15
	sharp = TRUE
	edge = TRUE

/mob/living/simple_animal/hostile/hivebot/mega/Initialize()
	. = ..()
	switch_mode(ATTACK_MODE_ROCKET)

/mob/living/simple_animal/hostile/hivebot/mega/handle_regular_status_updates()
	. = ..()
	if(. && !is_on_special_ability_cooldown())
		switch_mode(ATTACK_MODE_ROCKET)

/mob/living/simple_animal/hostile/hivebot/mega/emp_act(severity)
	. = ..()
	if(severity >= 1)
		deactivate()

/mob/living/simple_animal/hostile/hivebot/mega/on_update_icon()
	..()
	if(stat != DEAD)
		if(deactivated)
			add_overlay("[icon_state]-standby")
			return
		add_overlay("[icon_state]-active")
		switch(attack_mode)
			if(ATTACK_MODE_MELEE)
				add_overlay("[icon_state]-melee")
			if(ATTACK_MODE_LASER)
				add_overlay("[icon_state]-laser")
			if(ATTACK_MODE_ROCKET)
				add_overlay("[icon_state]-rocket")

/mob/living/simple_animal/hostile/hivebot/mega/proc/switch_mode(var/new_mode)
	if(!new_mode || new_mode == attack_mode)
		return

	switch(new_mode)
		if(ATTACK_MODE_MELEE)
			attack_mode = ATTACK_MODE_MELEE
			ranged = FALSE
			projectilesound = null
			projectiletype = null
			num_shots = 0
			visible_message(SPAN_MFAUNA("\The [src]'s circular saw spins up!"))
			deactivate()
		if(ATTACK_MODE_LASER)
			attack_mode = ATTACK_MODE_LASER
			ranged = TRUE
			projectilesound = 'sound/weapons/Laser.ogg'
			projectiletype = /obj/item/projectile/beam/megabot
			num_shots = 12
			fire_desc = "fires a laser"
			visible_message(SPAN_MFAUNA("\The [src]'s laser cannon whines!"))
		if(ATTACK_MODE_ROCKET)
			attack_mode = ATTACK_MODE_ROCKET
			ranged = TRUE
			projectilesound = 'sound/effects/Explosion1.ogg'
			projectiletype = /obj/item/projectile/bullet/gyro/megabot
			num_shots = 4
			set_special_ability_cooldown(ability_cooldown)
			fire_desc = "launches a microrocket"
			visible_message(SPAN_MFAUNA("\The [src]'s missile pod rumbles!"))

	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/proc/deactivate()
	stop_automation = TRUE
	deactivated = TRUE
	visible_message(SPAN_MFAUNA("\The [src] clicks loudly as its lights fade and its motors grind to a halt!"))
	update_icon()
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(FALSE)
	addtimer(CALLBACK(src, PROC_REF(reactivate)), 4 SECONDS)

/mob/living/simple_animal/hostile/hivebot/mega/proc/reactivate()
	stop_automation = FALSE
	deactivated = FALSE
	visible_message(SPAN_MFAUNA("\The [src] whirs back to life!"))
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(TRUE)
	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/OpenFire(target_mob)
	if(num_shots <= 0)
		if(attack_mode == ATTACK_MODE_ROCKET)
			switch_mode(ATTACK_MODE_LASER)
		else
			switch_mode(ATTACK_MODE_MELEE)
		return
	return ..()

/mob/living/simple_animal/hostile/hivebot/mega/Shoot(target, start, user, bullet)
	. = ..()
	if(.)
		num_shots--

#undef ATTACK_MODE_MELEE
#undef ATTACK_MODE_LASER
#undef ATTACK_MODE_ROCKET