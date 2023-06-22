/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/structures/displaycase.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE //Dissolving the case would also delete the gun.
	alpha = 150
	maxhealth = 100
	hitsound = 'sound/effects/Glasshit.ogg'
	req_access = null

	var/destroyed = FALSE
	var/locked = TRUE

/obj/structure/displaycase/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(AM.simulated && !AM.anchored)
			AM.forceMove(src)
	update_icon()

	if(!req_access)
		var/area/A = get_area(src)
		if(!istype(A) || !islist(A.req_access))
			return
		req_access = A.req_access.Copy()

/obj/structure/displaycase/examine(mob/user, distance)
	. = ..()
	if(contents.len)
		to_chat(user, "Inside you see [english_list(contents)].")

	if(distance <= 1)
		to_chat(user, "It looks [locked ? "locked. You can open it with your ID card" : "unlocked"].")

/obj/structure/displaycase/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1)
			new /obj/item/shard(loc)
			for(var/atom/movable/AM in src)
				AM.dropInto(loc)
			qdel(src)
		else if(prob(50))
			take_damage(20 - (severity * 5))

/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	..()
	take_damage(Proj.get_structure_damage())

/obj/structure/proc/subtract_matter(var/obj/subtracting)
	if(!length(matter))
		return
	if(!istype(subtracting) || !length(subtracting.matter))
		return
	for(var/mat in matter)
		if(!subtracting[mat])
			continue
		matter[mat] -= subtracting[mat]
		if(matter[mat] <= 0)
			matter -= mat
	UNSETEMPTY(matter)

/obj/structure/displaycase/dismantle()
	SHOULD_CALL_PARENT(FALSE)
	. = TRUE

/obj/structure/displaycase/physically_destroyed(var/skip_qdel)
	if(destroyed)
		return
	. = ..(TRUE)
	if(.)
		set_density(0)
		destroyed = TRUE
		subtract_matter(new /obj/item/shard(get_turf(src), material?.type))
		playsound(src, "shatter", 70, 1)
		update_icon()

/obj/structure/displaycase/on_update_icon()
	..()
	if(destroyed)
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	underlays.Cut()
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/obj/item/card/id/id = W.GetIdCard()
	if(istype(id))
		if(allowed(usr))
			locked = !locked
			to_chat(user, "\The [src] was [locked ? "locked" : "unlocked"].")
		else
			to_chat(user, "\The [src]'s card reader denies you access.")
		return

	if(isitem(W) && (!locked || destroyed))
		if(!W.simulated || W.anchored)
			return

		if(user.try_unequip(W, src))
			W.pixel_x = 0
			W.pixel_y = -7
			update_icon()
		return
	. = ..()

/obj/structure/displaycase/attack_hand(mob/user)

	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	add_fingerprint(user)

	if(!locked || destroyed)
		var/obj/item/selected_item
		selected_item = show_radial_menu(user, src, make_item_radial_menu_choices(src), radius = 42, require_near = TRUE, use_labels = TRUE)
		if(QDELETED(selected_item) || !contents.Find(selected_item) || !Adjacent(user) || user.incapacitated())
			return

		to_chat(user, SPAN_NOTICE("You remove \the [selected_item] from \the [src]."))
		selected_item.dropInto(loc)
		update_icon()
		return TRUE

	else if(!destroyed && user.a_intent == I_HURT)
		visible_message(SPAN_WARNING("[user] kicks \the [src]."), SPAN_WARNING("You kick \the [src]."))
		take_damage(2)
		return TRUE
