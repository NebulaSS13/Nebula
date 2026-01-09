// This one is tanky by having armor.
/mob/living/simple_animal/hostile/hivebot/melee/armored
	name = "armored hivebot"
	desc = "A robot clad in heavy armor."
	icon = 'icons/mob/simple_animal/hivebots/hivebot_yellow.dmi'
	max_health = 150
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_MAJOR,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_PISTOL,
		(ARMOR_LASER)  = ARMOR_LASER_HANDGUNS,
		(ARMOR_ENERGY) = ARMOR_ENERGY_RESISTANT,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)

/mob/living/simple_animal/hostile/hivebot/melee/armored/anti_melee
	name = "riot hivebot"
	desc = "A robot specialized in close quarters combat."
	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_VERY_HIGH,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)

/mob/living/simple_animal/hostile/hivebot/melee/armored/anti_bullet
	name = "bulletproof hivebot"
	desc = "A robot specialized in ballistic defense."
	natural_armor = list(
		(ARMOR_BULLET) = ARMOR_BALLISTIC_RIFLE,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)

/mob/living/simple_animal/hostile/hivebot/melee/armored/anti_laser
	name = "ablative hivebot"
	desc = "A robot specialized in photonic defense."
	natural_armor = list(
		(ARMOR_LASER)  = ARMOR_LASER_RIFLES,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)
	var/reflect_chance = 40

// Ablative Hivebots can reflect lasers just like humans.
/mob/living/simple_animal/hostile/hivebot/melee/armored/anti_laser/bullet_act(obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflect_prob = reflect_chance - round(P.damage/3)
		if(prob(reflect_prob))
			visible_message(
				SPAN_DANGER("\The [P] is reflected by \the [src]'s armor!"),
				SPAN_DANGER("\The [P] gets reflected by \the [src]'s armor!")
			)
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				P.redirect(new_x, new_y, get_turf(src), src)
			return PROJECTILE_CONTINUE
	return (..(P))
