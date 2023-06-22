/obj/item/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items/beartrap.dmi'
	icon_state = "beartrap0"
	randpixel = 0
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	throwforce = 0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/metal/steel
	can_buckle = 0 //disallow manual un/buckling
	var/deployed = 0

/obj/item/beartrap/proc/can_use(mob/user)
	. = (user.check_dexterity(DEXTERITY_SIMPLE_MACHINES) && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/beartrap/user_unbuckle_mob(mob/user)
	if(buckled_mob && can_use(user))
		user.visible_message(
			"<span class='notice'>\The [user] begins freeing \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free \the [buckled_mob] from \the [src].</span>",
			"<span class='notice'>You hear metal creaking.</span>"
			)
		if(do_after(user, 60, src))
			user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
			unbuckle_mob()
			anchored = 0

/obj/item/beartrap/attack_self(mob/user)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60, src) && user.try_unequip(src))
			user.visible_message(
				"<span class='danger'>\The [user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)

			deployed = 1
			update_icon()
			anchored = 1

/obj/item/beartrap/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	if(buckled_mob)
		user_unbuckle_mob(user)
		return TRUE
	if(!deployed || !can_use(user))
		return FALSE
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
		anchored = 0
		update_icon()
	return TRUE

/obj/item/beartrap/proc/attack_mob(mob/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	if(!L.apply_damage(30, BRUTE, target_zone, used_weapon=src))
		return 0

	//trap the victim in place
	set_dir(L.dir)
	buckle_mob(L)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = 0

/obj/item/beartrap/Crossed(atom/movable/AM)
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(!MOVING_DELIBERATELY(L))
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!buckled_mob)
				anchored = 0
			deployed = 0
			update_icon()
	..()

/obj/item/beartrap/on_update_icon()
	. = ..()
	icon_state = "beartrap[deployed == TRUE]"
