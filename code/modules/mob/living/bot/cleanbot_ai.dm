/datum/mob_controller/bot/clean/handle_bot_adjacent_target()
	var/atom/target = get_target()
	if(istype(target) && get_turf(target) == body.loc)
		body.UnarmedAttack(target)

/datum/mob_controller/bot/clean/find_target()
	for(var/thing in list_targets())
		set_target(thing)
		playsound(body, 'sound/machines/boop1.ogg', 30)
		return

/datum/mob_controller/bot/clean/handle_bot_idle()
	var/mob/living/bot/cleanbot/bot = body
	if(!istype(bot))
		return
	if(!bot.screwloose && !bot.oddbutton && prob(5))
		bot.visible_message("\The [bot] makes an excited beeping booping sound!")
	if(bot.screwloose && prob(5) && isturf(bot.loc))
		var/turf/T = bot.loc
		if(T.simulated)
			T.wet_floor()
	if(bot.oddbutton && prob(5)) // Make a big mess
		bot.visible_message("Something flies out of \the [bot]. It seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new(bot.loc)
		add_friend(gib)
		spawn(60 SECONDS)
			if(!QDELETED(gib) && !QDELETED(src))
				remove_friend(gib)

/datum/mob_controller/bot/clean/valid_target(atom/A)
	return ..() && is_type_in_list(A, get_target_types())

/datum/mob_controller/bot/clean/proc/get_target_types()

	var/mob/living/bot/cleanbot/bot = body

	if(istype(bot) && bot.blood)
		var/static/list/blood_types = list(
			/obj/effect/decal/cleanable/blood/oil,
			/obj/effect/decal/cleanable/vomit,
			/obj/effect/decal/cleanable/crayon,
			/obj/effect/decal/cleanable/mucus,
			/obj/effect/decal/cleanable/dirt,
			/obj/effect/decal/cleanable/filth,
			/obj/effect/decal/cleanable/spiderling_remains,
			/obj/effect/decal/cleanable/blood
		)
		return blood_types

	var/static/list/target_types = list(
		/obj/effect/decal/cleanable/blood/oil,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/crayon,
		/obj/effect/decal/cleanable/mucus,
		/obj/effect/decal/cleanable/dirt,
		/obj/effect/decal/cleanable/filth,
		/obj/effect/decal/cleanable/spiderling_remains
	)
	return target_types
