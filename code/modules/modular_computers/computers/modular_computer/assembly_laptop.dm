/datum/extension/assembly/modular_computer/laptop
	hardware_flag = PROGRAM_LAPTOP
	max_hardware_size = 2
	base_idle_power_usage = 25
	base_active_power_usage = 200
	max_damage = 200

/datum/extension/assembly/modular_computer/laptop/New()
	broken_damage = max_damage / 2
	..()