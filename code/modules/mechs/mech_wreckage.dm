/obj/structure/mech_wreckage
	name = "wreckage"
	desc = "It might have some salvagable parts."
	density = TRUE
	opacity = 1
	anchored = TRUE
	icon_state = "wreck"
	icon = 'icons/mecha/mech_part_items.dmi'
	var/prepared
	var/list/loot_pool

/obj/structure/mech_wreckage/Initialize(mapload, var/mob/living/exosuit/exosuit, var/gibbed)
	. = ..(mapload)
	if(exosuit)
		name = "wreckage of \the [exosuit.name]"
		loot_pool = list()
		if(!gibbed)
			for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
				if(thing && prob(40))
					loot_pool += thing
				if(thing == exosuit.arms)
					exosuit.arms = null
				else if(thing == exosuit.legs)
					exosuit.legs = null
				else if(thing == exosuit.head)
					exosuit.head = null
				else if(thing == exosuit.body)
					exosuit.body = null
			for(var/hardpoint in exosuit.hardpoints)
				if(exosuit.hardpoints[hardpoint] && prob(40))
					var/obj/item/thing = exosuit.hardpoints[hardpoint]
					if(exosuit.remove_system(hardpoint))
						loot_pool += thing

		if(!QDELETED(exosuit))
			qdel(exosuit)

	if(length(loot_pool))
		if(loc)
			for(var/atom/movable/thing as anything in loot_pool)
				if(ispath(thing) && prob(loot_pool[thing]))
					thing = new thing(src)
					if(istype(thing, /obj/item/mech_component))
						var/obj/item/mech_component/comp = thing
						comp.prebuild()
				if(istype(thing))
					thing.forceMove(src)
		loot_pool = null


/obj/structure/mech_wreckage/attack_hand(var/mob/user)
	var/list/contained_atoms = get_contained_external_atoms()
	if(!length(contained_atoms) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/obj/item/thing = pick(contained_atoms)
	thing.forceMove(get_turf(user))
	user.put_in_hands(thing)
	to_chat(user, "You retrieve \the [thing] from \the [src].")
	return TRUE

/obj/structure/mech_wreckage/attackby(var/obj/item/W, var/mob/user)

	var/cutting
	if(IS_WELDER(W))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			cutting = TRUE
		else
			to_chat(user, SPAN_WARNING("Turn \the [WT] on, first."))
	else if(istype(W, /obj/item/gun/energy/plasmacutter))
		cutting = TRUE

	if(cutting)
		if(!prepared)
			prepared = 1
			to_chat(user, SPAN_NOTICE("You partially dismantle \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] has already been weakened."))
		return 1

	else if(IS_WRENCH(W))
		if(prepared)
			to_chat(user, SPAN_NOTICE("You finish dismantling \the [src]."))
			SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(src), rand(5, 10))
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("It's too solid to dismantle. Try cutting through some of the bigger bits."))
		return 1
	else if(istype(W) && W.force > 20)
		visible_message(SPAN_DANGER("\The [src] has been smashed with \the [W] by \the [user]!"))
		if(prob(20))
			physically_destroyed()
		return 1
	return ..()

/obj/structure/mech_wreckage/Destroy()
	for(var/obj/thing in contents)
		if(prob(65))
			thing.forceMove(get_turf(src))
		else
			qdel(thing)
	return ..()
