/decl/department/engineering
	name = "Engineering"
	reference = DEPT_ENGINEERING
	announce_channel = "Engineering"
	colour = "#ffa500"
	display_priority = 2

/decl/department/security
	name = "Security"
	reference = DEPT_SECURITY
	announce_channel = "Security"
	colour = "#dd0000"
	display_priority = 2

/decl/department/medical
	name = "Medical"
	reference = DEPT_MEDICAL
	goals = list(/datum/goal/department/medical_fatalities)
	announce_channel = "Medical"
	colour = "#008000"
	display_priority = 2

/decl/department/science
	name = "Science"
	reference = DEPT_SCIENCE
	goals = list(/datum/goal/department/extract_slime_cores)
	announce_channel = "Science"
	colour = "#a65ba6"

/decl/department/civilian
	name = "Civilian"
	reference = DEPT_CIVILIAN
	display_priority = 1

/decl/department/command
	name = "Command"
	reference = DEPT_COMMAND
	colour = "#800080"
	display_priority = 3

/decl/department/miscellaneous
	name = "Miscellaneous"
	reference = DEPT_MISC
	display_priority = -1

/decl/department/service
	name = "Service"
	reference = DEPT_SERVICE
	announce_channel = "Service"
	colour = "#88b764"

/decl/department/supply
	name = "Supply"
	reference = DEPT_SUPPLY
	announce_channel = "Supply"
	colour = "#bb9040"

/decl/department/support
	name = "Command Support"
	reference = DEPT_SUPPORT
	announce_channel = "Command"
	colour = "#800080"

/decl/department/exploration
	name = "Exploration"
	reference = DEPT_EXPLORATION
	announce_channel = "Exploration"
	colour = "#68099e"