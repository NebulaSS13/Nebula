/obj/structure/defensive_barrier
	name = "defensive barrier"
	desc = "A portable defensive barrier. Usually seen around hardened positions or in storage at important areas."
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_rised"
	density =    FALSE
	throwpass =  TRUE
	anchored =   TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CHECKS_BORDER
	can_buckle = TRUE
	material =   /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_NAME
	maxhealth = 200
	var/secured

/obj/structure/defensive_barrier/Initialize()
	. = ..()
	update_icon()
	events_repository.register(/decl/observ/dir_set, src, src, .proc/update_layers)

/obj/structure/defensive_barrier/physically_destroyed(var/skip_qdel)
	visible_message(SPAN_DANGER("\The [src] was destroyed!"))
	playsound(src, 'sound/effects/clang.ogg', 100, 1)
	. = ..()

/obj/structure/defensive_barrier/Destroy()
	events_repository.unregister(/decl/observ/dir_set, src, src, .proc/update_layers)
	. = ..()

/obj/structure/defensive_barrier/proc/update_layers()
	if(dir != SOUTH)
		layer = initial(layer) + 0.01
	else if(dir == SOUTH && density)
		layer = ABOVE_HUMAN_LAYER
	else
		layer = initial(layer) + 0.01

/obj/structure/defensive_barrier/on_update_icon()
	..()
	if(!secured)
		if(density)
			icon_state = "barrier_rised"
		else
			icon_state = "barrier_downed"
	else
		icon_state = "barrier_deployed"
	update_layers()

/obj/structure/defensive_barrier/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(!density || air_group || (height == 0))
		return TRUE

	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/proj = mover
		if(Adjacent(proj?.firer))
			return TRUE
		if(mover.dir != global.reverse_dir[dir])
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
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/defensive_barrier/proc/try_pack_up(var/mob/user)

	if(secured)
		to_chat(user, SPAN_WARNING("\The [src] is secured in place and cannot be packed up. You will need to unsecure it with a screwdriver."))
		return FALSE

	if(density)
		to_chat(user, SPAN_WARNING("\The [src] is raised and must be lowered before you can pack it up."))
		return FALSE

	visible_message(SPAN_NOTICE("\The [user] starts packing up \the [src]."))

	if(!do_after(user, 60, src) || secured || density)
		return FALSE

	visible_message(SPAN_NOTICE("\The [user] packs up \the [src]."))
	var/obj/item/defensive_barrier/B = new(get_turf(user), material?.type)
	playsound(src, 'sound/items/Deconstruct.ogg', 100, 1)
	B.stored_health = health
	B.stored_max_health = maxhealth
	B.add_fingerprint(user)
	qdel(src)
	return TRUE

/obj/structure/defensive_barrier/CtrlClick(mob/living/user)
	try_pack_up(user)

/obj/structure/defensive_barrier/attack_hand(mob/user)

	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()

	var/decl/species/species = user.get_species()
	if(ishuman(user) && species?.can_shred(user) && user.a_intent == I_HURT)
		take_damage(20)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	if(user.a_intent == I_GRAB)
		try_pack_up(user)
		return TRUE

	if(secured)
		to_chat(user, SPAN_WARNING("\The [src] is secured in place and cannot be put up or down. You will need to unsecure it with a screwdriver."))
		return TRUE

	if(!do_after(user, 5, src))
		return TRUE

	playsound(src, 'sound/effects/extout.ogg', 100, 1)
	density = !density
	to_chat(user, SPAN_NOTICE("You [density ? "raise" : "lower"] \the [src]."))
	update_icon()
	return TRUE

/obj/structure/defensive_barrier/attackby(obj/item/W, mob/user)

	if(IS_SCREWDRIVER(W) && density)
		user.visible_message(SPAN_NOTICE("\The [user] begins to [secured ? "secure" : "unsecure"] \the [src]..."))
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		if(!do_after(user, 30, src))
			return TRUE
		secured = !secured
		user.visible_message(SPAN_NOTICE("\The [user] has [secured ? "secured" : "unsecured"] \the [src]."))
		update_icon()
		return TRUE

	. = ..()

/obj/structure/defensive_barrier/take_damage(damage)
	if(damage)
		playsound(src.loc, 'sound/effects/bang.ogg', 75, 1)
		damage = round(damage * 0.5)
		if(damage)
			..()

/obj/structure/defensive_barrier/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if(!cover)
		return TRUE

	var/chance = secured ? 55 : 35
	if(get_dir(loc, from) == dir)
		chance += 25

	if(prob(chance))
		visible_message(SPAN_WARNING("\The [P] hits \the [src]!"))
		bullet_act(P)
		return FALSE

	return TRUE

/obj/item/defensive_barrier
	name = "deployable barrier"
	desc = "A portable barrier in flatpack form. Usually seen around hardened positions or in storage at important areas."
	icon = 'icons/obj/structures/barrier.dmi'
	icon_state = "barrier_hand"
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/metal/steel
	var/stored_health = 200
	var/stored_max_health = 200

/obj/item/defensive_barrier/Initialize(ml, material_key)
	. = ..()
	if(material)
		name = "[material.solid_name] [initial(name)]"

/obj/item/defensive_barrier/proc/turf_check(mob/user)
	var/turf/T = get_turf(user)
	if(!istype(T))
		return FALSE
	for(var/obj/structure/defensive_barrier/D in T)
		if((D.dir == user.dir))
			to_chat(user, SPAN_WARNING("There is already a barrier set up facing that direction."))
			return FALSE
	return TRUE

/obj/item/defensive_barrier/attack_self(mob/user)

	if(!turf_check(user) || !do_after(user, 1 SECOND, src) || !turf_check(user))
		return TRUE

	playsound(src, 'sound/effects/extout.ogg', 100, 1)
	var/obj/structure/defensive_barrier/B = new(get_turf(user), material?.type)
	B.set_dir(user.dir)
	B.health = stored_health
	if(loc == user)
		user.drop_from_inventory(src)
	qdel(src)

/obj/item/defensive_barrier/attackby(obj/item/W, mob/user)
	if(stored_health < stored_max_health && IS_WELDER(W))
		if(W.do_tool_interaction(TOOL_WELDER, user, src,        \
		  max(5, round((stored_max_health-stored_health) / 5)), \
		  "repairing the damage to", "repairing the damage to", \
		  "You fail to patch the damage to \the [src].",        \
		  fuel_expenditure = 1
		))
			stored_health = stored_max_health
		return TRUE
	. = ..()
