/datum/ai/passive/fox
	var/weakref/hunt_target
	var/next_hunt = 0

/datum/ai/passive/fox/update_targets()
	// Fleeing takes precedence.
	. = ..()
	if(!.  && !hunt_target && world.time >= next_hunt) // TODO: generalized nutrition process. && body.get_nutrition() < body.get_max_nutrition() * 0.5)
		for(var/mob/living/snack in view(body)) //search for a new target
			if(can_hunt(snack))
				hunt_target = weakref(snack)
				break

	return . || !!hunt_target

/datum/ai/passive/fox/proc/can_hunt(mob/living/victim)
	return !victim.isSynthetic() && (victim.stat == DEAD || victim.get_object_size() < body.get_object_size())

/datum/ai/passive/fox/do_process(time_elapsed)

	..()

	var/mob/living/simple_animal/critter = body
	if(!istype(critter) || body.incapacitated() || body.current_posture?.prone || body.buckled || flee_target || !hunt_target)
		return

	var/atom/hunt_target_atom = hunt_target?.resolve()
	if(!isliving(hunt_target_atom) || QDELETED(hunt_target_atom) || !(hunt_target_atom in view(body)))
		hunt_target = null
		critter.stop_automated_movement = FALSE
		return

	// Find or pursue the target.
	if(!body.Adjacent(hunt_target_atom))
		critter.stop_automated_movement = 1
		walk_to(body, hunt_target_atom, 0, 3)
		return

	// Hunt/consume the target.
	var/mob/living/hunt_mob = hunt_target_atom
	if(hunt_mob.stat != DEAD)
		critter.attack_target(hunt_target_atom)

	if(QDELETED(hunt_mob))
		hunt_target = null
		critter.stop_automated_movement = FALSE
		return

	if(hunt_mob.stat != DEAD)
		return

	// Eat the mob.
	hunt_target = null
	critter.stop_automated_movement = FALSE
	body.visible_message(SPAN_DANGER("\The [body] consumes the body of \the [hunt_mob]!"))
	var/remains_type = hunt_mob.get_remains_type()
	if(remains_type)
		var/obj/item/remains/remains = new remains_type(get_turf(hunt_mob))
		remains.desc += "These look like they belonged to \a [hunt_mob.name]."
	body.adjust_nutrition(5 * hunt_mob.get_max_health())
	next_hunt = world.time + rand(15 MINUTES, 30 MINUTES)
	if(prob(5))
		hunt_mob.gib()
	else
		qdel(hunt_mob)

/mob/living/simple_animal/passive/fox
	name           = "fox"
	desc           = "A cunning and graceful predatory mammal, known for its red fur and eerie screams."
	icon           = 'icons/mob/simple_animal/fox.dmi'
	natural_weapon = /obj/item/natural_weapon/bite/weak
	ai             = /datum/ai/passive/fox
	mob_size       = MOB_SIZE_SMALL
	emote_speech   = list("Yip!","AIEE!","YIPE!")
	speak_emote    = list("yelps", "yips", "hisses", "screams")
	emote_hear     = list("screams","yips")
	emote_see      = list("paces back and forth", "flicks its tail")
	pass_flags     = PASS_FLAG_TABLE
	butchery_data  = /decl/butchery_data/animal/fox
