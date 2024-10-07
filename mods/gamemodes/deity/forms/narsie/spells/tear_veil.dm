/decl/ability/deity
	abstract_type           = /decl/ability/deity
	associated_handler_type = /decl/ability_handler/deity

/decl/ability_handler/deity

/decl/ability/deity/tear_veil
	name                = "Tear Veil"
	desc                = "Use your mental strength to literally tear a hole from this dimension to the next, letting things through..."
	cooldown_time       = 30 SECONDS
	ability_use_channel = 20 SECONDS
	ability_icon_state  = "const_floor"
	use_sound           = 'sound/effects/meteorimpact.ogg'

	var/static/list/possible_spawns = list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/revenant/cult
	)

/*
/decl/ability/deity/tear_veil/choose_targets()
	var/turf/T = get_turf(holder)
	holder.visible_message(SPAN_NOTICE("A strange portal rips open underneath \the [holder]!"))
	var/obj/effect/gateway/hole = new(get_turf(T))
	hole.density = FALSE
	return list(hole)

/decl/ability/deity/tear_veil/cast(var/list/targets, var/mob/holder, var/channel_count)
	if(channel_count == 1)
		return
	var/type = pick(possible_spawns)
	var/mob/living/L = new type(get_turf(targets[1]))
	L.faction = holder.faction
	L.visible_message(SPAN_WARNING("\A [L] escapes from the portal!"))

/decl/ability/deity//tear_veil/after_spell(var/list/targets)
	qdel(targets[1])
	return
*/