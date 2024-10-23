/datum/mob_controller/bot/floor/find_target()
	..()
	var/mob/living/bot/floorbot/bot = body
	if(!istype(bot) || bot.amount >= bot.maxAmount || (!bot.eattiles && !bot.maketiles))
		return
	for(var/obj/item/stack/S in get_valid_targets())
		set_target(S)
		return

/datum/mob_controller/bot/floor/do_process()
	..()
	if(body && !body.stat && prob(1))
		body.custom_emote(AUDIBLE_MESSAGE, "makes an excited booping beeping sound!")

// The fact that we do some checks twice may seem confusing but remember that the bot's
// settings may be toggled while it's moving and we want them to stop in that case
/datum/mob_controller/bot/floor/valid_target(atom/A)
	if(!(. = ..()))
		return
	var/mob/living/bot/floorbot/bot = body
	if(!istype(bot))
		return
	bot.anchored = FALSE
	if(istype(A, /obj/item/stack/tile/floor))
		return (bot.amount < bot.maxAmount && bot.eattiles)
	if(istype(A, /obj/item/stack/material))
		var/obj/item/stack/material/S = A
		if(S.material?.type == /decl/material/solid/metal/steel)
			return (bot.amount < bot.maxAmount && bot.maketiles)
	var/turf/floor/T = A
	if(!istype(T) || T.is_open())
		return FALSE
	if(bot.emagged)
		return TRUE
	return (bot.amount && (T.is_floor_damaged() || (bot.improvefloors && !T.has_flooring())))
