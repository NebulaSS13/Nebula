/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = TRUE
	anchored = TRUE
	var/spawnable = null

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/faithless
	)

/obj/effect/gateway/active/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(create_and_delete)), rand(30,60) SECONDS)

/obj/effect/gateway/active/proc/create_and_delete()
	var/t = pick(spawnable)
	new t(src.loc)
	qdel(src)

/obj/effect/gateway/active/proc/can_transform(mob/victim)
	if(victim.stat == DEAD)
		return FALSE
	if(victim.HasMovementHandler(/datum/movement_handler/mob/transformation))
		return FALSE
	if(ishuman(victim) || isrobot(victim))
		return TRUE
	return FALSE

/obj/effect/gateway/active/Crossed(var/atom/movable/AM)
	if(!isliving(AM))
		return

	var/mob/living/victim = AM

	if(!can_transform(victim))
		return

	victim.handle_pre_transformation()

	victim.AddMovementHandler(/datum/movement_handler/mob/transformation)
	victim.icon = null
	victim.overlays.len = 0
	victim.set_invisibility(INVISIBILITY_ABSTRACT)

	if(isrobot(victim))
		var/mob/living/silicon/robot/Robot = victim
		QDEL_NULL(Robot.central_processor)
	else
		for(var/obj/item/W in victim)
			victim.drop_from_inventory(W)
			if(istype(W, /obj/item/implant))
				qdel(W)

	var/mob/living/new_mob = new /mob/living/simple_animal/corgi(AM.loc)
	new_mob.a_intent = I_HURT
	if(victim.mind)
		victim.mind.transfer_to(new_mob)
	else
		new_mob.key = victim.key

	to_chat(new_mob, "<B>Your form morphs into that of a corgi.</B>")//Because we don't have cluwnes