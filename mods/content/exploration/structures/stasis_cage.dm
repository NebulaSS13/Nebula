/obj/structure/stasis_cage
	name = "stasis cage"
	desc = "A high-tech animal cage, designed to keep contained fauna docile and safe."
	icon = 'mods/content/exploration/icons/stasis_cage.dmi'
	icon_state = "stasis_cage"
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	VAR_PRIVATE/weakref/_contained

/obj/structure/stasis_cage/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	var/mob/living/simple_animal/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/stasis_cage/Destroy()
	STOP_PROCESSING(SSobj, src)
	release()
	return ..()

/obj/structure/stasis_cage/Process()
	. = ..()
	for(var/mob/specimen in contents)
		specimen.add_mob_modifier(/decl/mob_modifier/stasis, SSobj.wait * 2, source = src)

/obj/structure/stasis_cage/proc/get_specimen()
	var/mob/living/simple_animal/critter = _contained?.resolve()
	if(!critter || critter.loc != src || QDELETED(critter))
		_contained = null
		return null
	return critter

/obj/structure/stasis_cage/attackby(obj/item/used_item, mob/user)
	if(_contained && istype(used_item, /obj/item/scanner/xenobio))
		var/mob/living/simple_animal/specimen = get_specimen()
		if(specimen)
			return specimen.attackby(used_item, user)
	. = ..()

/obj/structure/stasis_cage/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	try_release(user)
	return TRUE

/obj/structure/stasis_cage/attack_robot(var/mob/user)
	if(CanPhysicallyInteract(user))
		try_release(user)
		return TRUE

/obj/structure/stasis_cage/proc/try_release(mob/user)
	var/mob/living/simple_animal/specimen = get_specimen()
	if(!specimen)
		to_chat(user, SPAN_NOTICE("There's no animals inside \the [src]"))
		return
	user.visible_message("[user] begins undoing the locks and latches on \the [src].")
	if(do_after(user, 20, src))

		user.visible_message("[user] releases \the [specimen] from \the [src]!")
		release()

/obj/structure/stasis_cage/on_update_icon()
	..()
	var/mob/living/simple_animal/specimen = get_specimen()
	if(specimen)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/structure/stasis_cage/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/mob/living/simple_animal/specimen = get_specimen()
	if(specimen)
		. += "\The [specimen] is kept inside."

/obj/structure/stasis_cage/proc/contain(var/mob/living/simple_animal/animal)
	var/mob/living/simple_animal/specimen = get_specimen()
	if(specimen || !istype(animal))
		return

	_contained = weakref(animal)
	animal.forceMove(src)
	update_icon()

/obj/structure/stasis_cage/proc/release()

	var/mob/living/simple_animal/specimen = get_specimen()
	if(!specimen)
		return

	specimen.dropInto(src)
	_contained = null
	update_icon()

/mob/living/simple_animal/handle_mouse_drop(atom/over, mob/user, params)
	if(istype(over, /obj/structure/stasis_cage))
		var/obj/structure/stasis_cage/cage = over
		if(!stat && !istype(buckled, /obj/effect/energy_net))
			to_chat(user, SPAN_WARNING("It's going to be difficult to convince \the [src] to move into \the [cage] without capturing it in a net."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] begins loading \the [src] into \the [cage]."),
			SPAN_NOTICE("You begin loading \the [src] into \the [cage].")
		)
		Bumped(user)
		if(do_after(user, 20, cage))
			cage.visible_message(
				SPAN_NOTICE("\The [user] finishes loading \the [src] into \the [cage]."),
				SPAN_NOTICE("You finishes loading \the [src] into \the [cage].")
			)
			cage.contain(src)
		return TRUE
	. = ..()

/obj/item/scanner/xenobio/is_valid_scan_target(atom/O)
	if(istype(O, /obj/structure/stasis_cage))
		var/obj/structure/stasis_cage/cagie = O
		return !!cagie.get_specimen()
	return ..()

/decl/hierarchy/supply_pack/science/stasis_cages
	name          = "Stasis Cage"
	contains      = list(
		/obj/structure/stasis_cage = 1
	)
	containertype = /obj/structure/closet/crate/large
	containername = "stasis cage crate"
	access        = access_xenofauna
