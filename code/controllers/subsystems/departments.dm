SUBSYSTEM_DEF(departments)
	name = "Deparments"
	init_order = SS_INIT_DEPARTMENTS
	flags = SS_NO_FIRE
	var/list/datum/department/departments = list()

/datum/controller/subsystem/departments/Initialize()
	for(var/dtype in subtypesof(/datum/department))
		var/datum/department/dept = dtype
		var/dept_name = initial(dept.reference)
		if(dept_name)
			departments["[dept_name]"] = new dtype
	for(var/thing in departments)
		var/datum/department/dept = departments[thing]
		dept.Initialize()
	. = ..()