/obj/structure/defensive_barrier
	name = "defensive barrier"
	desc = "A portable barrier - usually, you can see it on defensive positions or in storages in important areas."
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_rised"
	density = TRUE
	throwpass = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CHECKS_BORDER

	var/health = 200
	var/maxhealth = 200
	var/deployed = 0
	var/basic_chance = 50

/obj/structure/defensive_barrier/Initialize()
	. = ..()
	queue_icon_update()
	GLOB.dir_set_event.register(src, src, .proc/update_layers)

/obj/structure/defensive_barrier/examine(user)
	. = ..()
	if(.)
		if(health>=200)
			to_chat(user, SPAN_NOTICE("It looks undamaged."))
		if(health>=140 && health<200)
			to_chat(user, SPAN_WARNING("It has small dents."))
		if(health>=80 && health<140)
			to_chat(user, SPAN_WARNING("It has medium dents."))
		if(health<80)
			to_chat(user, SPAN_DANGER("It will break apart soon!"))

/obj/structure/defensive_barrier/Destroy()
	if(health <= 0)
		visible_message(SPAN_DANGER("\The [src] was destroyed!"))
		playsound(src, 'sound/effects/clang.ogg', 100, 1)
		new /obj/item/stack/material/steel(loc)
		new /obj/item/stack/material/steel(loc)

	GLOB.dir_set_event.unregister(src, src, .proc/update_layers)
	. = ..()

/obj/structure/defensive_barrier/proc/update_layers()
	if(dir != SOUTH)
		layer = initial(layer) + 0.1
	else if(dir == SOUTH && density)
		layer = ABOVE_HUMAN_LAYER
	else
		layer = initial(layer) + 0.1

/obj/structure/defensive_barrier/on_update_icon()
	if(density && !deployed)
		icon_state = "barrier_rised"
	if(!density && !deployed)
		icon_state = "barrier_downed"
	if(deployed)
		icon_state = "barrier_deployed"

	update_layers()

/obj/structure/defensive_barrier/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!density || air_group)
		return TRUE

	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover

		if(Adjacent(proj?.firer))
			return TRUE

		if(mover.dir != reverse_direction(dir))
			return TRUE

		if(get_dist(proj.starting, loc) <= 1)//allows to fire from 1 tile away of barrier
			return TRUE

		return check_cover(mover, target)

	if(get_dir(get_turf(src), target) == dir && density)//turned in front of barrier
		return FALSE

	return TRUE

/obj/structure/defensive_barrier/CheckExit(atom/movable/O, target)
	if(O?.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if (get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/defensive_barrier/attack_hand(mob/living/carbon/human/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.species.can_shred(user) && user.a_intent == I_HURT)
		take_damage(20)
		return

	if(deployed)
		to_chat(user, SPAN_NOTICE("\The [src] is already deployed. You can't move it."))
	else
		if(do_after(user, 5, src))
			playsound(src, 'sound/effects/extout.ogg', 100, 1)
			density = !density
			to_chat(user, SPAN_NOTICE("You're getting [density ? "up" : "down"] \the [src]."))
			update_icon()

/obj/structure/defensive_barrier/attackby(obj/item/W, mob/user)
	if(isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(health == maxhealth)
			to_chat(user, SPAN_NOTICE("\The [src] is fully repaired."))
			return

		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("\The [W] should be turned on firstly."))
			return

		if(WT.remove_fuel(0,user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			user.visible_message(
				SPAN_NOTICE("[user] starts to repair \the [src]."),
				SPAN_NOTICE("You begin to repair \the [src]."))

			if(do_after(user, max(5, health / 5), src) && WT?.isOn())
				playsound(src, 'sound/items/Welder2.ogg', 100, 1)
				user.visible_message(
					SPAN_NOTICE("[user] finished repairing \the [src]."),
					SPAN_NOTICE("You finish repair \the [src]."))
				health = maxhealth
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
		update_icon()
		return

	if(isScrewdriver(W))
		if(density)
			user.visible_message(SPAN_DANGER("[user] begins to [deployed ? "un" : ""]deploy \the [src]..."))
			playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
			if(do_after(user, 30, src))
				user.visible_message(SPAN_NOTICE("[user] has [deployed ? "un" : ""]deployed \the [src]."))
				deployed = !deployed
				if(deployed)
					basic_chance = 70
				else
					basic_chance = 50
		update_icon()
		return

	if(isCrowbar(W))
		if(!deployed && !density)
			visible_message(SPAN_DANGER("[user] is begins disassembling \the [src]..."))
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			if(do_after(user, 60, src))
				var/obj/item/defensive_barrier/B = new /obj/item/defensive_barrier(get_turf(user))
				visible_message(SPAN_NOTICE("[user] dismantled \the [src]."))
				playsound(src, 'sound/items/Deconstruct.ogg', 100, 1)
				B.health = health
				B.add_fingerprint(user)
				qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You should unsecure \the [src] first. Use a screwdriver."))
		update_icon()
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(W.force)
		..()

/obj/structure/defensive_barrier/bullet_act(obj/item/projectile/P)
	..()
	take_damage(P.get_structure_damage())

/obj/structure/defensive_barrier/attack_generic(mob/user, damage, attack_verb)
	take_damage(damage)
	attack_animation(user)
	if(damage >=1)
		user.visible_message(SPAN_DANGER("[user] [attack_verb] \the [src]!"))
	else
		user.visible_message(SPAN_DANGER("[user] [attack_verb] \the [src] harmlessly!"))
	return 1

/obj/structure/defensive_barrier/take_damage(damage)
	health -= damage * 0.5
	if(health <= 0)
		Destroy()
	else
		playsound(src.loc, 'sound/effects/bang.ogg', 75, 1)

/obj/structure/defensive_barrier/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	var/chance = basic_chance

	if(!cover)
		return 1

	var/mob/living/carbon/human/M = locate(src.loc)
	if(M)
		chance += 30

		if(M.lying)
			chance += 20

	if(get_dir(loc, from) == dir)
		chance += 10

	if(prob(chance))
		visible_message(SPAN_WARNING("[P] hits \the [src]!"))
		bullet_act(P)
		return 0

	return 1

/obj/structure/defensive_barrier/MouseDrop_T(mob/user)
	if(src.loc != user.loc)
		to_chat(user, "You start climbing onto [src]...")
		step(src, get_dir(src, src.dir))

/obj/structure/defensive_barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			new /obj/item/stack/material/steel(src.loc)
			new /obj/item/stack/material/steel(src.loc)
			if(prob(50))
				new /obj/item/stack/material/steel(src.loc)
			qdel(src)
			return
		if(2.0)
			new /obj/item/stack/material/steel(src.loc)
			if(prob(50))
				new /obj/item/stack/material/steel(src.loc)
			qdel(src)
			return
		else
	return

/obj/item/defensive_barrier
	name = "portable barrier"
	desc = "A portable barrier. Usually, you can see it on defensive positions or in storages at important areas"
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_hand"
	w_class = ITEM_SIZE_LARGE
	health = 200

/obj/item/defensive_barrier/proc/turf_check(mob/user)
	for(var/obj/structure/defensive_barrier/D in user.loc.contents)
		if((D.dir == user.dir))
			to_chat(user, SPAN_WARNING("There is no more space."))
			return 1
	return 0

/obj/item/defensive_barrier/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place it here."))
		return
	if(turf_check(user))
		return

	if(do_after(user, 1 SECOND, src))
		playsound(src, 'sound/effects/extout.ogg', 100, 1)
		var/obj/structure/defensive_barrier/B = new(user.loc)
		B.set_dir(user.dir)
		B.health = health
		user.drop_item()
		qdel(src)

/obj/item/defensive_barrier/attackby(obj/item/W, mob/user)
	if(health != 200 && isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_NOTICE("\The [W] should be turned on firstly."))
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to \the [src]."))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, health / 5), src) && WT?.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to \the [src]."))
				playsound(src, 'sound/items/Welder2.ogg', 100, 1)
				health = 200
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
	return
