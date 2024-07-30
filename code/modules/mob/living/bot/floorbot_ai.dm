/datum/mob_controller/bot/floor/handle_bot_adjacent_target()
	var/atom/target = get_target()
	if(istype(target) && get_turf(target) == body.loc)
		body.UnarmedAttack(target)

	for(var/turf/floor/T in view(src))
		if(valid_target(T))
			set_target(T)
			return

/datum/mob_controller/bot/floor/find_target()
	var/mob/living/bot/floorbot/bot = body
	if(!istype(bot) || bot.amount >= bot.maxAmount || (!bot.eattiles && !bot.maketiles))
		return
	for(var/obj/item/stack/S in list_targets())
		set_target(S)
		return

/datum/mob_controller/bot/floor/handle_general_bot_ai(mob/living/bot/bot)
	var/mob/living/bot/floorbot/floorbot = bot
	if(!istype(floorbot))
		return
	floorbot.tilemake++
	if(floorbot.tilemake >= 100)
		floorbot.tilemake = 0
		floorbot.addTiles(1)
	if(prob(1))
		floorbot.custom_emote(AUDIBLE_MESSAGE, "makes an excited booping beeping sound!")
	return ..()

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
	return (bot.amount && (T.is_floor_damaged() || (bot.improvefloors && !T.flooring)))
