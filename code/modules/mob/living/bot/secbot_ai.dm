/datum/mob_controller/bot/security
	var/awaiting_surrender = 0
	var/static/list/threat_found_sounds = list(
		'sound/voice/bcriminal.ogg',
		'sound/voice/bjustice.ogg',
		'sound/voice/bfreeze.ogg'
	)

/datum/mob_controller/bot/security/lose_target()
	..()
	events_repository.unregister(/decl/observ/moved, get_target(), body)
	awaiting_surrender = -1

/datum/mob_controller/bot/security/proc/check_threat(var/mob/living/perp)
	if(!istype(perp) || perp.stat == DEAD || body == perp)
		return 0
	var/mob/living/bot/secbot/bot = body
	if(!istype(bot))
		return 0
	if(bot.emagged && !perp.incapacitated()) //check incapacitated so emagged secbots don't keep attacking the same target forever
		return 10
	return perp.assess_perp(bot.access_scanner, 0, bot.idcheck, bot.check_records, bot.check_arrest)

/datum/mob_controller/bot/security/valid_target(atom/A)
	return ..() && (check_threat(A) >= SECBOT_THREAT_ARREST)

/datum/mob_controller/bot/security/retaliate(atom/source)
	. = ..()
	if(!get_target() && ismob(source))
		set_target(source)
		playsound(body.loc, pick(threat_found_sounds), 50)
		var/mob/attacker = source
		var/target_name = (attacker?.get_id_name(ishuman(attacker) ? "unidentified person" : "unidentified lifeform") || "unidentified lifeform")
		broadcast_security_hud_message("[src] was attacked by a hostile <b>[target_name]</b> in <b>[get_area_name(src)]</b>.", src)
	awaiting_surrender = INFINITY

/datum/mob_controller/bot/security/find_target()
	..()
	var/mob/living/bot/secbot/bot = body
	if(!istype(bot))
		return
	for(var/mob/living/M as anything in get_valid_targets())
		set_target(M)
		awaiting_surrender = -1
		body.say("Level [check_threat(M)] infraction alert!")
		body.custom_emote(VISIBLE_MESSAGE, "points at \the [M]!")
		return
