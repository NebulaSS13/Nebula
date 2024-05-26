/obj/item/chems/pill/get_food_consumption_method(mob/eater)
	return EATING_METHOD_EAT

/obj/item/chems/pill/get_edible_material_amount(var/mob/eater)
	return reagents?.total_volume

/obj/item/chems/pill/get_food_default_transfer_amount(mob/eater)
	return reagents?.total_volume // Always eat it in one bite.

/obj/item/chems/pill/show_feed_message_start(mob/user, mob/target, consumption_method = EATING_METHOD_EAT)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You begin trying to swallow \the [target]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] attempts to force \the [target] to swallow \the [src]!"))

/obj/item/chems/pill/show_feed_message_end(mob/user, mob/target, consumption_method = EATING_METHOD_EAT)
	target = target || user
	if(user)
		if(user == target)
			to_chat(user, SPAN_NOTICE("You swallow \the [src]."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] forces \the [target] to swallow \the [src]!"))

/obj/item/chems/pill/play_feed_sound(mob/user, consumption_method = EATING_METHOD_EAT)
	return

/obj/item/chems/pill/show_food_consumed_message(mob/user, mob/target, consumption_method = EATING_METHOD_EAT)
	return
