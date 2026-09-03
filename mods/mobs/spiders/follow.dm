/datum/follow_holder/spiderling
	sort_order = 6
	followed_type = /obj/effect/spider/spiderling

/datum/follow_holder/spiderling/show_entry()
	var/obj/effect/spider/spiderling/S = followed_instance
	return ..() && S.amount_grown > 0
