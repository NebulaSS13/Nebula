// HAWK NOTES
// - Summon whistles should call a hawk back to your inventory after being sent off to hunt.
// - Hawks are unable to pick up mice or rabbits currently - needs investigation.

/mob/living/simple_animal/passive/bird/hawk
	name = "hawk"
	desc = "A fierce, proud hunter with a majestic cry."
	icon = 'mods/content/birds/icons/hawk.dmi'
	ai   = /datum/mob_controller/hunter/hawk
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

/datum/mob_controller/hunter/hawk
	emote_speech = list("Skree!","SKREE!","Skree!?")
	emote_hear   = list("screeches", "screams")
	emote_see    = list("preens its feathers", "flicks its wings", "looks sharply around")
	ai_flags     = AI_FLAG_WANDERS | AI_FLAG_AGGRESSIVE | AI_FLAG_CAUTIOUS | AI_FLAG_COWARD | AI_FLAG_HUNTER | AI_FLAG_RETURNING
	var/handling_skill = SKILL_BOTANY
	var/handling_difficulty = SKILL_ADEPT

/datum/mob_controller/hunter/hawk/consume_prey(mob/living/prey)

	return ..()

/datum/mob_controller/hunter/hawk/set_target(atom/new_target)
	. = ..()
	handler_set_target = FALSE

/datum/mob_controller/hunter/hawk/process_handler_target(mob/handler, atom/target)
	if(!(. = ..()))
		return
	set_target(target)
	handler_set_target = TRUE
	set_stance(/decl/mob_controller_stance/attack)

/datum/mob_controller/hunter/hawk/can_hunt(mob/living/victim)
	return handler_set_target || ..()

/datum/mob_controller/hunter/hawk/check_handler_can_order(mob/handler, atom/target, intent_flags)
	if(!(. = ..()) && handler.skill_check(handling_skill, handling_difficulty))
		add_friend(handler)
		return ..()

/datum/mob_controller/hunter/hawk/process_handler_failure(mob/handler, atom/target)
	body?.visible_message(SPAN_DANGER("\The [body] ignores \the [target] in favour of attacking \the [handler]!"))
	set_target(handler)
	handler_set_target = TRUE
	next_hunt = 0
	return ..()
