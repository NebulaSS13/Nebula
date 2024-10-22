/datum/extension/milkable
	base_type = /datum/extension/milkable
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/milk_type = /decl/material/liquid/drink/milk
	var/milk_prob = 5
	var/milk_min  = 5
	var/milk_max  = 10

	var/impatience = 0
	var/decl/skill/milking_skill = SKILL_BOTANY
	var/milking_skill_req        = SKILL_BASIC

	var/datum/reagents/udder

/datum/extension/milkable/New(datum/holder, _milk_type)
	..()
	if(ispath(_milk_type, /decl/material))
		milk_type = _milk_type
	if(isatom(holder))
		udder = new /datum/reagents(50, holder)
	START_PROCESSING(SSprocessing, src)

/datum/extension/milkable/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(udder)
	return ..()

/datum/extension/milkable/Process()
	if(!isatom(holder) || QDELETED(holder) || QDELETED(src) || QDELETED(udder))
		return PROCESS_KILL

	var/mob/living/critter = holder
	if(critter.stat == DEAD)
		return PROCESS_KILL

	if(critter.stat == CONSCIOUS && !critter.get_automove_target() && impatience > 0 && prob(10)) // if not fleeing, 10% chance to regain patience
		impatience--

	if(prob(milk_prob))
		create_milk()

/datum/extension/milkable/proc/create_milk()
	var/create_milk = min(rand(milk_min, milk_max), REAGENTS_FREE_SPACE(udder))
	if(create_milk > 0)
		udder.add_reagent(milk_type, create_milk, get_milk_data())

/datum/extension/milkable/proc/get_milk_data()
	var/static/list/milk_data = list(
		DATA_MILK_DONOR = "cow"
	)
	return milk_data.Copy()

// Return TRUE if attackby() should halt at this call.
/datum/extension/milkable/proc/handle_milked(obj/item/chems/container, mob/user)

	if(!istype(container) || !ATOM_IS_OPEN_CONTAINER(container))
		return FALSE

	var/mob/living/critter = holder
	if(critter.stat == DEAD)
		return FALSE

	if(udder?.total_volume <= 0)
		to_chat(user, SPAN_WARNING("\The [critter]'s udder is dry. Wait a little longer."))
		return TRUE

	if(critter.get_automove_target())
		if(user.skill_check(milking_skill, SKILL_PROF))
			to_chat(user, SPAN_NOTICE("\The [critter] goes still at your touch."))
			critter.stop_automove()
		else
			to_chat(user, SPAN_WARNING("Wait for \the [critter] to stop moving before you try milking it."))
			return TRUE

	if(container.reagents.total_volume >= container.volume)
		to_chat(user, SPAN_WARNING("\The [container] is full."))
		return TRUE

	// Cows don't like being milked if you're unskilled.
	if(user.skill_fail_prob(milking_skill, 40, milking_skill_req))
		handle_milking_failure(user, critter)
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] starts milking \the [critter] into \the [container]."),
		SPAN_NOTICE("You start milking \the [critter] into \the [container].")
	)
	if(!user.do_skilled(4 SECONDS, milking_skill, target = critter, check_holding = TRUE))
		user.visible_message(
			SPAN_NOTICE("\The [user] stops milking \the [critter]."),
			SPAN_NOTICE("You stop milking \the [critter].")
		)
		return TRUE

	if(critter.stat == DEAD)
		return FALSE

	if(udder?.total_volume <= 0)
		to_chat(user, SPAN_WARNING("\The [critter]'s udder is dry. Wait a little longer."))
		return TRUE

	if(container.reagents.total_volume >= container.volume)
		to_chat(user, SPAN_NOTICE("\The [container] is full."))
		return TRUE

	if(critter.get_automove_target())
		to_chat(user, SPAN_WARNING("Wait for \the [critter] to stop moving before you try milking it."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] milks \the [critter] into \the [container]."),
		SPAN_NOTICE("You milk \the [critter] into \the [container].")
	)
	udder.trans_type_to(container, milk_type, min(REAGENTS_FREE_SPACE(container.reagents), rand(15, 20)))
	return TRUE

/datum/extension/milkable/proc/handle_milking_failure(mob/user, mob/living/critter)
	if(impatience > 3)
		critter.visible_message(SPAN_WARNING("\The [critter] bellows and flees from \the [user]!"))
		critter.flee(user, upset = TRUE)
	else
		critter.visible_message(SPAN_WARNING("\The [critter] huffs and moves away from \the [user]."))
		critter.flee(user, upset = FALSE)
		impatience++

/datum/extension/milkable/goat/handle_milking_failure(mob/user, mob/living/critter)
	critter?.ai?.retaliate()

/datum/extension/milkable/goat/get_milk_data()
	var/static/list/milk_data = list(
		DATA_MILK_DONOR   = "goat",
		DATA_MILK_NAME    = "goat",
		DATA_CHEESE_NAME  = "feta",
		DATA_CHEESE_COLOR = "#f3f2be",
		DATA_MASK_NAME    = "goat's milk",
	)
	return milk_data.Copy()
