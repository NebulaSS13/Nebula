/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"

/obj/effect/spider/stickyweb/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "stickyweb2"

/obj/effect/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return 1
	else if(isliving(mover))
		if(prob(50))
			to_chat(mover, "<span class='warning'>You get stuck in \the [src] for a moment.</span>")
			return 0
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1
