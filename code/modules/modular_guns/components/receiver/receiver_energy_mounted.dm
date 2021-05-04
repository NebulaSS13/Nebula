/obj/item/firearm_component/receiver/energy/electrolaser/mounted
	use_external_power = TRUE
	self_recharge = 1
	has_safety = FALSE

/obj/item/firearm_component/receiver/energy/electrolaser/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/firearm_component/receiver/energy/ionrifle/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE
	fire_delay = 30

/obj/item/firearm_component/receiver/energy/laser/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/firearm_component/receiver/energy/electrolaser/mounted/robot
	use_external_power = TRUE
	max_shots = 6
	recharge_time = 10

/*
/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"
*/