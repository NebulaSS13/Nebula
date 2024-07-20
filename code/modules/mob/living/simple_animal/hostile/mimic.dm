//
// Abstract Class
//

var/global/list/protected_objects = list(
	/obj/machinery,
	/obj/structure/table,
	/obj/structure/cable,
	/obj/structure/window,
	/obj/structure/wall_frame,
	/obj/structure/grille,
	/obj/structure/catwalk,
	/obj/structure/ladder,
	/obj/structure/stairs,
	/obj/structure/sign,
	/obj/structure/railing,
	/obj/item/modular_computer,
	/obj/item/projectile/animate
)

/mob/living/simple_animal/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon =  'icons/obj/closets/bases/crate.dmi'
	color = COLOR_STEEL
	icon_state = "crate"
	butchery_data = null
	max_health = 100
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite
	min_gas = null
	max_gas = null
	minbodytemp = 0
	pass_flags = PASS_FLAG_TABLE
	faction = "mimic"
	ai = /datum/mob_controller/aggressive/mimic
	move_intents = list(
		/decl/move_intent/walk/animal_very_slow,
		/decl/move_intent/run/animal_very_slow
	)

	var/weakref/copy_of
	var/weakref/creator // the creator
	var/knockdown_people = 0
	var/awake = TRUE

// Return a list of targets that isn't the creator
/datum/mob_controller/aggressive/mimic/list_targets(var/dist = 7)
	var/mob/living/simple_animal/hostile/mimic/mimic = body
	. = istype(mimic) && mimic.awake && ..()
	if(length(.) && mimic.creator)
		. -= mimic.creator.resolve()

/datum/mob_controller/aggressive/mimic/destroy_surroundings()
	var/mob/living/simple_animal/hostile/mimic/mimic = body
	. = istype(mimic) && mimic.awake && ..()

/datum/mob_controller/aggressive/mimic/find_target()
	. = ..()
	if(.)
		body.custom_emote(AUDIBLE_MESSAGE, "growls at [.]")

/mob/living/simple_animal/hostile/mimic/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	if(copy_of && copy_of.resolve())
		appearance = copy_of.resolve()
	else
		icon = initial(icon)
		icon_state = initial(icon_state)

/mob/living/simple_animal/hostile/mimic/Initialize(mapload, var/obj/o, var/mob/living/creator)
	. = ..()
	if(o)
		if(ispath(o))
			o = new o(loc)
		CopyObject(o,creator)

	if(!awake && istype(ai))
		ai.stop_wandering()

/mob/living/simple_animal/hostile/mimic/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))
		O.forceMove(src)
		copy_of = weakref(O)

		var/obj/item/attacking_with = get_natural_weapon()
		if(istype(O, /obj/structure))
			current_health = (anchored * 50) + 50
			ai?.try_destroy_surroundings = TRUE
			if(O.density && O.anchored)
				knockdown_people = 1
				attacking_with.set_base_attack_force(2 * attacking_with.get_initial_base_attack_force())
		else if(istype(O, /obj/item))
			ai?.try_destroy_surroundings = FALSE
			var/obj/item/I = O
			current_health = 15 * I.w_class
			attacking_with.set_base_attack_force(2 + I.get_initial_base_attack_force())

			if(I.w_class <= ITEM_SIZE_SMALL)
				move_intents = list(
					/decl/move_intent/walk/animal_fast,
					/decl/move_intent/run/animal_fast
				)
			else if(I.w_class <= ITEM_SIZE_GARGANTUAN)
				move_intents = list(
					/decl/move_intent/walk/animal,
					/decl/move_intent/run/animal
				)
			else if(I.w_class <= ITEM_SIZE_STRUCTURE)
				move_intents = list(
					/decl/move_intent/walk/animal_slow,
					/decl/move_intent/run/animal_slow
				)
			else
				move_intents = list(
					/decl/move_intent/walk/animal_very_slow,
					/decl/move_intent/run/animal_very_slow
				)
			move_intent = GET_DECL(move_intents[1])


		set_max_health(current_health)
		if(creator)
			src.creator = weakref(creator)
			faction = "\ref[creator]" // very unique

		update_icon()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/mimic/death(gibbed)
	if(!copy_of)
		return
	var/atom/movable/C = copy_of.resolve()
	. = ..()
	if(. && C)
		C.forceMove(src.loc)
		if(istype(C,/obj/structure/closet))
			for(var/atom/movable/M in src)
				M.forceMove(C)
		if(C.storage)
			for(var/atom/movable/M in src)
				if(C.storage.can_be_inserted(M, null, 1))
					C.storage.handle_item_insertion(null, M)
				else
					M.forceMove(src.loc)
		for(var/atom/movable/M in src)
			M.dropInto(loc)
		qdel(src)

/mob/living/simple_animal/hostile/mimic/apply_attack_effects(mob/living/target)
	. = ..()
	if(knockdown_people && prob(15))
		SET_STATUS_MAX(target, STAT_WEAK, 1)
		target.visible_message(SPAN_DANGER("\The [src] knocks down \the [target]!"))

/mob/living/simple_animal/hostile/mimic/Destroy()
	copy_of = null
	creator = null
	return ..()

/mob/living/simple_animal/hostile/mimic/proc/trigger()
	if(!awake)
		src.visible_message("<b>\The [src]</b> starts to move!")
		awake = TRUE

/mob/living/simple_animal/hostile/mimic/adjustBruteLoss(var/damage, var/do_update_health = FALSE)
	..(damage)
	if(!awake)
		trigger()

/mob/living/simple_animal/hostile/mimic/attack_hand()
	if(!awake)
		trigger()
	return ..()

/mob/living/simple_animal/hostile/mimic/sleeping
	awake = FALSE