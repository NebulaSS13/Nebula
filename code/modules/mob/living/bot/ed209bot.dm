/mob/living/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/mob/bot/ED209.dmi'
	icon_state = "ed2090"
	attack_state = "ed209-c"
	layer = MOB_LAYER
	density = TRUE
	max_health = 100

	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	var/shot_delay = 4
	var/last_shot = 0

/mob/living/bot/secbot/ed209/on_update_icon()
	..()
	icon_state = "ed2090"

/mob/living/bot/secbot/ed209/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..()
	if(. && my_turf)
		var/obj/item/gun/energy/taser/G = new /obj/item/gun/energy/taser(my_turf)
		var/obj/item/cell/power_supply = G.get_cell()
		power_supply?.charge = 0
		if(prob(50))
			new /obj/item/robot_parts/l_leg(my_turf)
		if(prob(50))
			new /obj/item/robot_parts/r_leg(my_turf)
		if(prob(50))
			if(prob(50))
				new /obj/item/clothing/head/helmet(my_turf)
			else
				new /obj/item/clothing/suit/armor/vest(my_turf)

/mob/living/bot/secbot/ed209/handleRangedTarget()
	RangedAttack(target)

/mob/living/bot/secbot/ed209/RangedAttack(var/atom/A, var/params)
	if(last_shot + shot_delay > world.time)
		to_chat(src, "You are not ready to fire yet!")
		return TRUE

	last_shot = world.time
	var/projectile = /obj/item/projectile/beam/stun
	if(emagged)
		projectile = /obj/item/projectile/beam

	playsound(loc, emagged ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)
	var/def_zone = get_exposed_defense_zone(A)
	P.launch(A, def_zone)
	return TRUE
