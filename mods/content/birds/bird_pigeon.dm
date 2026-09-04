/mob/living/simple_animal/passive/bird/pigeon
	name = "messenger pigeon"
	desc = "The noble messenger pigeon, a friend to armies and academics everywhere."
	icon = 'mods/content/birds/icons/pigeon.dmi'
	ai   = /datum/mob_controller/passive/pigeon
	holder_type = /obj/item/holder/bird/pigeon
	var/weakref/home_hutch

/mob/living/simple_animal/passive/bird/pigeon/Initialize()
	. = ..()
	update_hutch()

/obj/item/holder/bird/pigeon/attack_self(mob/user)
	var/mob/living/simple_animal/passive/bird/pigeon/pigeon = locate() in contents
	if(!istype(pigeon) || !pigeon.can_be_handled_by(user))
		return ..()
	if(!is_outside())
		to_chat(user, SPAN_WARNING("You need to be outdoors to release \the [pigeon]."))
		return TRUE
	var/obj/structure/hutch/hutch = pigeon.home_hutch?.resolve()
	if(QDELETED(hutch) || !istype(hutch))
		pigeon.home_hutch = null
	if(isnull(pigeon.home_hutch))
		var/decl/pronouns/pronouns = pigeon.get_pronouns()
		to_chat(user, SPAN_WARNING("\The [pigeon] tilts [pronouns.his] head at you in confusion. [pronouns.He] must not have a hutch to return to."))
	else
		user.drop_from_inventory(src)
		pigeon.fly_to_target(user, hutch)
		qdel(src)
	return TRUE

/mob/living/simple_animal/passive/bird/pigeon/proc/update_hutch()
	var/obj/structure/hutch/hutch = home_hutch?.resolve()
	if(!istype(hutch) || QDELETED(hutch))
		hutch = get_recursive_loc_of_type(/obj/structure/hutch)
	if(istype(hutch) && !QDELETED(hutch))
		home_hutch = weakref(hutch)
		events_repository.unregister(/decl/observ/moved, src, src)
	else
		events_repository.register(/decl/observ/moved, src, src, TYPE_PROC_REF(/mob/living/simple_animal/passive/bird/pigeon, update_hutch))

/mob/living/simple_animal/passive/bird/pigeon/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	LAZYADD(., SPAN_SUBTLE("Pigeons can be given a small item like a piece of paper to hold."))
	LAZYADD(., SPAN_SUBTLE("While holding a pigeon, use it in hand to release it to return to its home hutch."))

/datum/mob_controller/passive/pigeon
	emote_speech   = list("Oo-ooo.","Oo-ooo?","Oo-ooo...")
	emote_hear     = list("coos")
	emote_see      = list("preens its feathers", "puffs out its neck", "ruffles its wings")
