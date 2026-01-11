/obj/abstract/map_effect/interval/effect_emitter
	/// Effect system attached. Set to type to create in Initialize().
	var/datum/effect/effect/system/effect_system = null
	/// How many effect objects to create on each interval.  Note that there's a hard cap on certain effect_systems.
	var/effect_amount = 10
	/// If true, effects only move in cardinal directions.
	var/effect_cardinals_only = FALSE
	/// If set, effects emitted will always move in this direction.
	var/effect_forced_dir

/obj/abstract/map_effect/interval/effect_emitter/Initialize()
	if(ispath(effect_system))
		effect_system = new effect_system()
	if(!istype(effect_system))
		return INITIALIZE_HINT_QDEL
	effect_system.attach(src)
	return ..()

/obj/abstract/map_effect/interval/effect_emitter/interval/Destroy()
	QDEL_NULL(effect_system)
	return ..()


/obj/abstract/map_effect/interval/effect_emitter/trigger_map_effect()
	to_world("[type]: effect firing")
	if(istype(effect_system) && !QDELETED(src))
		effect_system.set_up(effect_amount, effect_cardinals_only, src.loc, effect_forced_dir)
		effect_system.start()

// Makes sparks.
/obj/abstract/map_effect/interval/effect_emitter/sparks
	name = "spark emitter"
	icon_state = "spark_emitter"
	effect_system = /datum/effect/effect/system/spark_spread
	interval_lower_bound = 3 SECONDS
	interval_upper_bound = 7 SECONDS

// Makes ""steam"" that looks like fire extinguisher water except it does nothing.
/obj/abstract/map_effect/interval/effect_emitter/steam
	name = "steam emitter"
	icon_state = "smoke_emitter"
	effect_system = /datum/effect/effect/system/steam_spread

// Creates smoke clouds every so often.
/obj/abstract/map_effect/interval/effect_emitter/smoke
	name = "smoke emitter"
	icon_state = "smoke_emitter"
	effect_system = /datum/effect/effect/system/smoke_spread
	interval_lower_bound = 1 SECOND
	interval_upper_bound = 1 SECOND
	effect_amount = 2

/obj/abstract/map_effect/interval/effect_emitter/smoke/mist
	name = "mist smoke emitter"
	effect_system = /datum/effect/effect/system/smoke_spread/mist

/obj/abstract/map_effect/interval/effect_emitter/smoke/bad
	name = "bad smoke emitter"
	effect_system = /datum/effect/effect/system/smoke_spread/bad

/obj/abstract/map_effect/interval/effect_emitter/smoke/fire
	name = "fire smoke emitter"
	effect_system = /datum/effect/effect/system/smoke_spread/fire
