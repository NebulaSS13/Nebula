/turf/unsimulated/wall/cult/nullrod_act(mob/user, obj/item/nullrod/rod)
	user.visible_message(
		SPAN_NOTICE("\The [user] touches \the [src] with \the [rod], and it shifts."),
		SPAN_NOTICE("You touch \the [src] with \the [rod], and it shifts.")
	)
	ChangeTurf(/turf/unsimulated/wall)
	return TRUE