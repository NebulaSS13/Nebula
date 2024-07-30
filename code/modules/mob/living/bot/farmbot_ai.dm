/datum/mob_controller/bot/farm/handle_general_bot_ai(mob/living/bot/bot)
	if(bot.emagged && prob(1))
		flick("farmbot_broke", bot)
	return ..()

/datum/mob_controller/bot/farm/find_target()
	var/mob/living/bot/farmbot/bot = body
	if(!istype(bot))
		return
	var/list/targets = list_targets()
	if(bot.emagged)
		for(var/mob/living/human/victim in targets)
			set_target(victim)
			return
	for(var/obj/machinery/portable_atmospherics/hydroponics/tray in targets)
		set_target(tray)
		return
	if(bot.refills_water && bot.tank?.reagents?.total_volume && bot.tank.reagents.total_volume < bot.tank.reagents.maximum_volume)
		for(var/obj/structure/hygiene/sink/source in targets)
			set_target(source)
			return

/datum/mob_controller/bot/farm/handle_bot_adjacent_target()
	var/atom/target = get_target()
	if(istype(target))
		body.UnarmedAttack(target)

/datum/mob_controller/bot/farm/valid_target(atom/A)
	var/mob/living/bot/farmbot/bot = body
	if(!istype(bot) || !(. = ..()))
		return FALSE
	if(bot.emagged && ishuman(A))
		return (A in view(world.view, bot))
	if(istype(A, /obj/structure/hygiene/sink))
		return bot.tank?.reagents?.maximum_volume && (bot.tank.reagents.total_volume >= bot.tank.reagents.maximum_volume)
	var/obj/machinery/portable_atmospherics/hydroponics/tray = A
	if(!istype(tray) || tray.closed_system || !tray.seed)
		return FALSE
	if((tray.dead && bot.removes_dead) || (tray.harvest && bot.collects_produce))
		return FARMBOT_COLLECT
	if(bot.refills_water && tray.waterlevel < 40 && !tray.reagents.has_reagent(/decl/material/liquid/water) && (bot.tank?.reagents?.total_volume > 0))
		return FARMBOT_WATER
	if(bot.uproots_weeds && tray.weedlevel > 3)
		return FARMBOT_UPROOT
	if(bot.replaces_nutriment && tray.nutrilevel < 1 && tray.reagents.total_volume < 1)
		return FARMBOT_NUTRIMENT
	return FALSE

/mob/living/bot/farmbot/calcTargetPath() // We need to land NEXT to the tray, because the tray itself is impassable

	var/datum/mob_controller/bot/botai = ai
	if(!istype(botai))
		return

	for(var/trayDir in list(NORTH, SOUTH, EAST, WEST))
		botai.target_path = AStar(get_turf(loc), get_step(get_turf(ai?.get_target()), trayDir), TYPE_PROC_REF(/turf, CardinalTurfsWithAccess), TYPE_PROC_REF(/turf, Distance), 0, max_target_dist, id = botcard)
		if(LAZYLEN(botai.target_path))
			break
	if(!LAZYLEN(botai.target_path) && ai)
		ai.add_friend(ai.get_target())
		ai.set_target(null)
	return

/mob/living/bot/farmbot/stepToTarget() // Same reason

	var/datum/mob_controller/bot/botai = ai
	if(!istype(botai))
		return

	var/turf/T = get_turf(ai?.get_target())
	if(!LAZYLEN(botai.target_path) || !T.Adjacent(botai.target_path[LAZYLEN(botai.target_path)]))
		calcTargetPath()
	makeStep(botai.target_path)
	return
