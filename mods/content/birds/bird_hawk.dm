// HAWK NOTES
// - Summon whistles should call a hawk back to your inventory after being sent off to hunt.
// - Hawks are unable to pick up mice or rabbits currently - needs investigation.

/mob/living/simple_animal/passive/bird/hawk
	name = "hawk"
	desc = "A fierce, proud hunter with a majestic cry."
	icon = 'mods/content/birds/icons/hawk.dmi'
	ai   = /datum/mob_controller/passive/hunter/hawk
	holder_type = /obj/item/holder/bird/hawk
	ability_handlers = list(/datum/ability_handler/predator)

//TODO; whistle to call a hawk back.
/mob/living/simple_animal/passive/bird/hawk/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	LAZYADD(., SPAN_SUBTLE("Hawks can be held in the hand and directed to attack or collect targets by clicking on them."))

/obj/item/holder/bird/hawk/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		return ..()
	var/mob/living/simple_animal/passive/bird/bird = locate() in contents
	. = ..()
	if(!user || !istype(bird) || !bird.can_be_handled_by(user) || QDELETED(src) || bird.loc != src)
		return
	bird.dropInto(loc)
	qdel(src) // This will happen shortly regardless, but might as well skip the 1ds delay.
	if(isturf(target))
		bird.visible_message(SPAN_NOTICE("\The [user] releases \a [bird]!"))
	else
		bird.visible_message(SPAN_NOTICE("\The [user] indicates \the [target] and releases \a [bird]!"))
	if(istype(bird.ai))
		bird.ai.process_handler_target(user, target, user.get_intent()?.intent_flags)

/datum/mob_controller/passive/hunter/hawk
	emote_speech   = list("Skree!","SKREE!","Skree!?")
	emote_hear     = list("screeches", "screams")
	emote_see      = list("preens its feathers", "flicks its wings", "looks sharply around")
	var/handler_set_target = FALSE
	var/handling_skill = SKILL_BOTANY
	var/handling_difficulty = SKILL_ADEPT

/datum/mob_controller/passive/hunter/hawk/consume_prey(mob/living/prey)
	if(prey.stat == DEAD && last_handler && handler_set_target)
		set_target(last_handler?.resolve())
		prey.try_make_grab(body, defer_hand = TRUE)
		return
	return ..()

/datum/mob_controller/passive/hunter/hawk/set_target(atom/new_target)
	. = ..()
	handler_set_target = FALSE

/datum/mob_controller/passive/hunter/hawk/process_handler_target(mob/handler, atom/target)
	if((. = ..()))
		set_target(target)
		handler_set_target = TRUE
		process_hunting(target)

/datum/mob_controller/passive/hunter/hawk/can_hunt(mob/living/victim)
	return handler_set_target || ..()

/datum/mob_controller/passive/hunter/hawk/check_handler_can_order(mob/handler, atom/target, intent_flags)
	if(!(. = ..()) && handler.skill_check(handling_skill, handling_difficulty))
		add_friend(handler)
		return ..()

/datum/mob_controller/passive/hunter/hawk/process_handler_failure(mob/handler, atom/target)
	body?.visible_message(SPAN_DANGER("\The [body] ignores \the [target] in favour of attacking \the [handler]!"))
	set_target(handler)
	handler_set_target = TRUE
	next_hunt = 0
	return ..()

/datum/mob_controller/passive/hunter/hawk/handle_friend_hunting(mob/user)
	..()
	set_target(null)
	resume_wandering()
	if(!body)
		return
	if(body.scoop_check(user) && body.get_scooped(user, body, silent = TRUE))
		body.visible_message(SPAN_NOTICE("\The [body] alights on \the [user]."))
	else
		body.visible_message(SPAN_NOTICE("\The [body] lands beside \the [user]."))

	var/mob/living/simple_animal/passive/bird/bird = body
	if(istype(bird))
		bird.give_held_items_to_handler(user)
	return TRUE

/datum/mob_controller/passive/hunter/hawk/process_hunting(atom/target)
	// Handles pathing to the target, and attacking the target if it's a mob.
	if(!(. = ..()))
		return
	// Maybe consider handling structures at some point?
	if(isitem(target) && body.Adjacent(target))
		body.put_in_hands(target)
		if(target.loc != body)
			body.visible_message(SPAN_WARNING("\The [body] fails to collect \the [target]!"))
	// Return to handler.
	set_target(last_handler?.resolve())
	return FALSE
