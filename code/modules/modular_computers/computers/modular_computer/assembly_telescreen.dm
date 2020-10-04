/datum/extension/assembly/modular_computer/telescreen
	hardware_flag = PROGRAM_TELESCREEN
	max_hardware_size = 2
	base_idle_power_usage = 75
	base_active_power_usage = 300
	steel_sheet_cost = 10
	max_damage = 300

/datum/extension/assembly/modular_computer/telescreen/New()
	broken_damage = max_damage / 2
	..()