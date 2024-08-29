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
	armor_type = /datum/extension/armor/toggle
	ability_cooldown = 3 MINUTES
	pixel_x = -32
	default_pixel_x = -32
	ai = /datum/mob_controller/aggressive/megahivebot
	base_movement_delay = 0

	var/attack_mode = ATTACK_MODE_MELEE
	var/num_shots
	var/deactivated

/datum/mob_controller/aggressive/megahivebot
	can_escape_buckles = TRUE

/datum/mob_controller/aggressive/megahivebot/open_fire()
	var/mob/living/simple_animal/hostile/hivebot/mega/megabot = body
	if(!istype(megabot))
		return ..()
	if(megabot.num_shots <= 0)
		if(megabot.attack_mode == ATTACK_MODE_ROCKET)
			megabot.switch_mode(ATTACK_MODE_LASER)
		else
			megabot.switch_mode(ATTACK_MODE_MELEE)
		return
	return ..()

/obj/item/natural_weapon/circular_saw
	name = "giant circular saw"
	attack_verb = list("sawed", "ripped")
	_base_attack_force = 15
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

/mob/living/simple_animal/hostile/hivebot/mega/has_ranged_attack()
	return attack_mode != ATTACK_MODE_MELEE && num_shots > 0

/mob/living/simple_animal/hostile/hivebot/mega/proc/switch_mode(var/new_mode)
	if(!new_mode || new_mode == attack_mode)
		return

	switch(new_mode)
		if(ATTACK_MODE_MELEE)
			attack_mode = ATTACK_MODE_MELEE
			projectilesound = null
			projectiletype = null
			num_shots = 0
			visible_message(SPAN_MFAUNA("\The [src]'s circular saw spins up!"))
			deactivate()
		if(ATTACK_MODE_LASER)
			attack_mode = ATTACK_MODE_LASER
			projectilesound = 'sound/weapons/Laser.ogg'
			projectiletype = /obj/item/projectile/beam/megabot
			num_shots = 12
			fire_desc = "fires a laser"
			visible_message(SPAN_MFAUNA("\The [src]'s laser cannon whines!"))
		if(ATTACK_MODE_ROCKET)
			attack_mode = ATTACK_MODE_ROCKET
			projectilesound = 'sound/effects/Explosion1.ogg'
			projectiletype = /obj/item/projectile/bullet/gyro/microrocket
			num_shots = 4
			set_special_ability_cooldown(ability_cooldown)
			fire_desc = "launches a microrocket"
			visible_message(SPAN_MFAUNA("\The [src]'s missile pod rumbles!"))

	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/proc/deactivate()
	ai?.pause()
	deactivated = TRUE
	visible_message(SPAN_MFAUNA("\The [src] clicks loudly as its lights fade and its motors grind to a halt!"))
	update_icon()
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(FALSE)
	addtimer(CALLBACK(src, PROC_REF(reactivate)), 4 SECONDS)

/mob/living/simple_animal/hostile/hivebot/mega/proc/reactivate()
	ai?.resume()
	deactivated = FALSE
	visible_message(SPAN_MFAUNA("\The [src] whirs back to life!"))
	var/datum/extension/armor/toggle/armor = get_extension(src, /datum/extension/armor)
	if(armor)
		armor.toggle(TRUE)
	update_icon()

/mob/living/simple_animal/hostile/hivebot/mega/shoot_at(target, start, user, bullet)
	. = ..()
	if(.)
		num_shots--

#undef ATTACK_MODE_MELEE
#undef ATTACK_MODE_LASER
#undef ATTACK_MODE_ROCKET
