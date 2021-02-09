/obj/item/firearm_component/receiver/energy/laser

/obj/item/firearm_component/receiver/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0 //just in case
	has_safety = FALSE

/obj/item/firearm_component/receiver/energy/laser/antique
	one_hand_penalty = 1 //a little bulky
	max_shots = 5 //to compensate a bit for self-recharging
	self_recharge = 1

/obj/item/firearm_component/receiver/energy/laser/cannon
	max_shots = 6

/obj/item/firearm_component/receiver/energy/laser/cannon/mounted
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	has_safety = FALSE
	one_hand_penalty = 0
