/obj/effect/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = TRUE
	anchored = TRUE
	layer = OBJ_LAYER
	icon = 'icons/obj/items/weapon/landmine.dmi'
	icon_state = "uglymine"
	var/triggerproc = PROC_REF(explode) // the proc that's called when the mine is triggered
	var/triggered = 0

/obj/effect/mine/Initialize()
	. = ..()
	icon_state = "uglyminearmed"

/obj/effect/mine/Crossed(atom/movable/AM)
	if(!isobserver(AM))
		Bumped(AM)

/obj/effect/mine/Bumped(mob/M)

	if(triggered) return

	if(ishuman(M))
		visible_message(SPAN_DANGER("\The [M] triggered \the [src]!"))
		triggered = 1
		call(src,triggerproc)(M)

/obj/effect/mine/proc/triggerrad(obj)
	spark_at(src, cardinal_only = TRUE)
	if(ismob(obj))
		var/mob/victim = obj
		victim.radiation += 50
	if(ismob(obj))
		var/mob/mob = obj
		mob.add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/disability)))
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerstun(obj)
	if(ismob(obj))
		var/mob/M = obj
		SET_STATUS_MAX(M, STAT_STUN, 30)
	spark_at(src, cardinal_only = TRUE)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy

	for (var/turf/target in range(1,src))
		if(target.simulated && !target.blocks_air)
			target.assume_gas(/decl/material/gas/nitrous_oxide, 30)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerflame(obj)
	for (var/turf/target in range(1,src))
		if(target.simulated && !target.blocks_air)
			target.assume_gas(/decl/material/gas/hydrogen, 30)
			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerkick(obj)
	spark_at(src, cardinal_only = TRUE)
	if(ismob(obj))
		var/mob/victim = obj
		qdel(victim.client)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/explode(obj)
	explosion(loc, 0, 1, 2, 3)
	spawn(0)
		qdel(src)

/obj/effect/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = PROC_REF(triggerrad)

/obj/effect/mine/flame
	name = "Incendiary Mine"
	icon_state = "uglymine"
	triggerproc = PROC_REF(triggerflame)

/obj/effect/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = PROC_REF(triggerkick)

/obj/effect/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = PROC_REF(triggern2o)

/obj/effect/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = PROC_REF(triggerstun)
