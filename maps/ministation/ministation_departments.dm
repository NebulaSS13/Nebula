/decl/department/service
	name = "Service"
	announce_channel = "Service"
	colour = "#88b764"
	display_color = "#d0f0c0"

/decl/department/command
	name = "Command"
	colour = "#800080"
	display_priority = 5
	display_color = "#ccccff"

/obj/machinery/network/pager
	department = /decl/department/command

/decl/department/civilian
	name = "Civilian"
	display_priority = 1
	display_color = "#dddddd"

/decl/department/engineering
	name = "Engineering"
	announce_channel = "Engineering"
	colour = "#ffa500"
	display_priority = 2
	display_color = "#fff5cc"

/decl/department/medical
	name = "Medical"
	goals = list(/datum/goal/department/medical_fatalities)
	announce_channel = "Medical"
	colour = "#008000"
	display_priority = 3
	display_color = "#ffeef0"

/obj/item/robot_module/medical
	associated_department = /decl/department/medical

/obj/machinery/network/pager/medical
	department = /decl/department/medical

/decl/department/science
	name = "Science"
	goals = list(/datum/goal/department/extract_slime_cores)
	announce_channel = "Science"
	colour = "#a65ba6"
	display_color = "#e79fff"

/obj/item/robot_module/research
	associated_department = /decl/department/science

/obj/machinery/network/pager/science
	department = /decl/department/science

/decl/department/security
	name = "Security"
	announce_channel = "Security"
	colour = "#dd0000"
	display_priority = 4
	display_color = "#ffddf0"

/obj/item/robot_module/security
	associated_department = /decl/department/security

/obj/machinery/network/pager/security 
	department = /decl/department/security

/decl/department/miscellaneous
	name = "Misc"
	display_priority = -1
	display_color = "#ccffcc"

/decl/department/tradehouse
	name = "Tradehouse"
	announce_channel = "Tradehouse"
	colour = "#b98f03"
	display_priority = 4
	display_color = "#ffddf0"