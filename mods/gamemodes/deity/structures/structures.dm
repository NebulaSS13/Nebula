/proc/valid_deity_structure_spot(var/type, var/turf/target, var/mob/living/deity/deity, var/mob/living/user)
	var/obj/structure/deity/D = type
	var/flags = initial(D.deity_flags)

	if(flags & DEITY_STRUCTURE_NEAR_IMPORTANT && !deity.near_structure(target))
		if(user)
			to_chat(user, SPAN_WARNING("You need to be near \a [deity.get_type_name(/obj/structure/deity/altar)] to build this!"))
		return 0

	if(flags & DEITY_STRUCTURE_ALONE)
		for(var/structure in deity.structures)
			if(istype(structure,type) && get_dist(target,structure) <= 3)
				if(user)
					to_chat(user, SPAN_WARNING("You are too close to another [deity.get_type_name(type)]!"))
				return 0
	return 1

/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	max_health = 10
	density = TRUE
	anchored = TRUE
	icon_state = "tomealtar"
	is_spawnable_type = FALSE // will usually runtime without a linked god

	var/mob/living/deity/linked_god
	var/power_adjustment = 1 //How much power we get/lose
	var/build_cost = 0 //How much it costs to build this item.
	var/deity_flags = DEITY_STRUCTURE_NEAR_IMPORTANT

/obj/structure/deity/Initialize(mapload, var/god)
	. = ..(mapload)
	if(god)
		linked_god = god
		linked_god.form.sync_structure(src)
		linked_god.adjust_source(power_adjustment, src)

/obj/structure/deity/Destroy()
	if(linked_god)
		linked_god.adjust_source(-power_adjustment, src)
		linked_god = null
	return ..()

/obj/structure/deity/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 50, 1)
	user.visible_message(
		SPAN_DANGER("[user] hits \the [src] with \the [W]!"),
		SPAN_DANGER("You hit \the [src] with \the [W]!"),
		SPAN_DANGER("You hear something breaking!")
		)
	take_damage(W.get_attack_force(user), W.atom_damage_type)

/obj/structure/deity/physically_destroyed(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	qdel(src)
	. = TRUE

/obj/structure/deity/physically_destroyed(var/skip_qdel)
	visible_message(SPAN_DANGER("\The [src] crumbles!"))
	. = ..()

/obj/structure/deity/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage, P.atom_damage_type)

/obj/structure/deity/proc/attack_deity(var/mob/living/deity/deity)
	return