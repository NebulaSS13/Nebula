/*
/datum/mob_controller/bot/mule
	max_frustration = 5

/datum/mob_controller/bot/mule/handle_frustrated()
	body.custom_emote(AUDIBLE_MESSAGE, "makes a sighing buzz.")
	playsound(body.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	return ..()

/datum/mob_controller/bot/mule/handle_bot_adjacent_target()
	var/mob/living/bot/mulebot/mulebot = body
	if(!istype(mulebot))
		return
	var/atom/target = get_target()
	if(!istype(target) || target != body.loc)
		return
	body.custom_emote(AUDIBLE_MESSAGE, "makes a chiming sound.")
	playsound(body, 'sound/machines/chime.ogg', 50, 0)
	body.UnarmedAttack(target)
	set_target(null)
	if(mulebot.auto_return && mulebot.home && (mulebot.loc != mulebot.home))
		set_target(mulebot.home)
		mulebot.targetName = "Home"
*/

/datum/mob_controller/bot/mule/do_process()
	. = ..()
	var/mob/living/bot/mulebot/mulebot = body
	if(istype(mulebot) && !mulebot.safety && prob(1))
		flick("mulebot-emagged", body)
	body.update_icon()
