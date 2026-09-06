/obj/item/beartrap
	name             = "mechanical trap"
	desc             = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throw_speed      = 2
	throw_range      = 1
	gender           = PLURAL
	icon             = 'icons/obj/items/beartrap.dmi'
	icon_state       = "beartrap0"
	randpixel        = 0
	w_class          = ITEM_SIZE_NORMAL
	origin_tech      = @'{"materials":1}'
	material         = /decl/material/solid/metal/steel
	max_buckled_mobs = 0 //disallow manual un/buckling
	var/deployed     = FALSE

/obj/item/beartrap/proc/can_use(mob/user)
	. = (user.check_dexterity(DEXTERITY_SIMPLE_MACHINES) && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/beartrap/user_unbuckle_mob(mob/user, mob/living/unbuckling_mob)
	var/mob/buckle_mob = get_buckled_mob(user = user)
	if(buckle_mob && can_use(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins freeing \the [buckle_mob] from \the [src]."),
			SPAN_NOTICE("You carefully begin to free \the [buckle_mob] from \the [src]."),
			SPAN_NOTICE("You hear metal creaking.")
			)
		if(do_after(user, 60, src))
			user.visible_message(SPAN_NOTICE("\The [buckle_mob] has been freed from \the [src] by \the [user]."))
			unbuckle_mob(buckle_mob)
			anchored = FALSE

/obj/item/beartrap/attack_self(mob/user)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			SPAN_DANGER("\The [user] starts to deploy \the [src]."),
			SPAN_DANGER("You begin deploying \the [src]!"),
			"You hear the slow creaking of a spring."
		)

		if (do_after(user, 6 SECONDS, src) && user.try_unequip(src))
			user.visible_message(
				SPAN_DANGER("\The [user] has deployed \the [src]."),
				SPAN_DANGER("You have deployed \the [src]!"),
				"You hear a latch click loudly."
			)
			deployed = TRUE
			update_icon()
			anchored = TRUE

/obj/item/beartrap/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	if(has_buckled_mob())
		user_unbuckle_mob(user)
		return TRUE
	if(!deployed || !can_use(user))
		return ..()
	user.visible_message(
		SPAN_DANGER("\The [user] starts to disarm \the [src]."),
		SPAN_NOTICE("You begin disarming \the [src]!"),
		"You hear a latch click followed by the slow creaking of a spring."
	)
	if(do_after(user, 60, src))
		user.visible_message(
			SPAN_DANGER("\The [user] has disarmed \the [src]."),
			SPAN_NOTICE("You have disarmed \the [src]!")
		)
		deployed = 0
		anchored = FALSE
		update_icon()
	return TRUE

/obj/item/beartrap/proc/attack_mob(mob/victim)

	if(victim.immune_to_floor_hazards())
		return FALSE

	var/target_zone
	if(victim.current_posture.prone)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	if(!victim.apply_damage(30, BRUTE, target_zone, used_weapon=src))
		return FALSE

	//trap the victim in place
	set_dir(victim.dir)
	buckle_mob(victim)
	to_chat(victim, SPAN_DANGER("The steel jaws of \the [src] bite into you, trapping you in place!"))
	deployed = FALSE
	return TRUE

/obj/item/beartrap/Crossed(atom/movable/AM)
	..()
	if(!deployed || !isliving(AM))
		return
	var/mob/living/victim = AM
	if(MOVING_DELIBERATELY(victim) || victim.immune_to_floor_hazards())
		return
	victim.visible_message(
		SPAN_DANGER("\The [victim] steps on \the [src]."),
		SPAN_DANGER("You step on \the [src]!"),
		"<b>You hear a loud metallic snap!</b>"
	)
	attack_mob(victim)
	if(!has_buckled_mob())
		anchored = FALSE
	deployed = FALSE
	update_icon()

/obj/item/beartrap/on_update_icon()
	. = ..()
	icon_state = "beartrap[deployed]"
