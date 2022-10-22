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

/obj/item/robot_module/engineering
	associated_department = /decl/department/engineering

/obj/machinery/network/pager/engineering
	department = /decl/department/engineering

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

/decl/department/command
	name = "Command"
	colour = "#800080"
	display_priority = 4
	display_color = "#ccccff"
	goals = list(/datum/goal/department/paperwork/tradeship)

/obj/machinery/network/pager
	department = /decl/department/command

/decl/department/miscellaneous
	name = "Misc"
	display_priority = -1
	display_color = "#ccffcc"
