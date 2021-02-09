/obj/item/firearm_component/receiver/energy/staff
	name = "staff handle"
	max_shots = 5
	self_recharge = 1
	charge_meter = 0
	max_shots = 10

/obj/item/firearm_component/receiver/energy/staff/beacon
	name = "glowing staff handle"
	self_recharge = 0

/obj/item/firearm_component/receiver/energy/animate
	name = "writhing staff handle"
	max_shots = 5
	recharge_time = 5 SECONDS

/*
/obj/item/gun/staff/handle_click_empty()
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(get_turf(src), 'sound/effects/sparks1.ogg', 100, 1)
*/
