/datum/build_mode/callproc
	name = "Call proc"
	icon_state = "buildmode11"
	var/client/C
	var/proc_name
	var/list/arguments
	var/returnval

/datum/build_mode/callproc/proc/clear()
	proc_name = null
	arguments = null

/datum/build_mode/callproc/Destroy()
	. = ..()

/datum/build_mode/callproc/Help()
	to_chat(user, SPAN_NOTICE("**************************************"))
	to_chat(user, SPAN_NOTICE("L.Click on target = apply proc to atom"))
	to_chat(user, SPAN_NOTICE("R.Click on button = set proc & vars"))
	to_chat(user, SPAN_NOTICE("**************************************"))

/datum/build_mode/callproc/Configurate()
	proc_name = input("Enter proc name:", "Proc name", proc_name) as text|null
	if(!proc_name)
		return
	arguments = list()
	get_args()

/datum/build_mode/callproc/OnClick(var/atom/A, var/list/parameters)
	if(!check_rights(R_DEBUG, 1, user) && !check_rights(R_VAREDIT, 1, user))
		return
	if(parameters["left"] && istype(A))
		log_admin("[key_name(user)] called [A]'s [proc_name]() with [arguments.len ? "the arguments [list2params(arguments)]" : "no arguments"].")
		message_admins("[key_name(user)] called [A]'s [proc_name]() with [arguments.len ? "the arguments [list2params(arguments)]" : "no arguments"].")
		if(arguments.len)
			returnval = call(A, proc_name)(arglist(arguments))
		else
			returnval = call(A, proc_name)()
		to_chat(user, "<span class='info'>[proc_name]() returned: [json_encode(returnval)]</span>")

/datum/build_mode/callproc/proc/get_args()
	var/done = 0
	var/current = null

	while(!done)
		switch(input("Type of [arguments.len+1]\th variable", "argument [arguments.len+1]") as null|anything in list(
				"finished", "null", "text", "path", "num", "type", "obj reference", "mob reference",
				"area/turf reference", "icon", "file", "client", "mob's area"))
			if(null)

			if("finished")
				done = 1

			if("null")
				current = null

			if("text")
				current = input("Enter text for [arguments.len+1]\th argument") as null|text
				if(isnull(current))
					return

			if("path")
				current = text2path(input("Enter path for [arguments.len+1]\th argument") as null|text)
				if(isnull(current))
					return

			if("num")
				current = input("Enter number for [arguments.len+1]\th argument") as null|num
				if(isnull(current))
					return

			if("type")
				current = input("Select type for [arguments.len+1]\th argument") as null|anything in typesof(/obj, /mob, /area, /turf)
				if(isnull(current))
					return

			if("obj reference")
				current = input("Select object for [arguments.len+1]\th argument") as null|obj in world
				if(isnull(current))
					return

			if("mob reference")
				current = input("Select mob for [arguments.len+1]\th argument") as null|mob in world
				if(isnull(current))
					return

			if("area/turf reference")
				current = input("Select area/turf for [arguments.len+1]\th argument") as null|area|turf in world
				if(isnull(current))
					return

			if("icon")
				current = input("Provide icon for [arguments.len+1]\th argument") as null|icon
				if(isnull(current))
					return

			if("client")
				current = input("Select client for [arguments.len+1]\th argument") as null|anything in GLOB.clients
				if(isnull(current))
					return

			if("mob's area")
				var/mob/M = input("Select mob to take area for [arguments.len+1]\th argument") as null|mob in world
				if(!M) return
				current = get_area(M)
				if(!current)
					switch(alert("\The [M] appears to not have an area; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return

			if("marked datum")
				current = C.holder.marked_datum()
				if(!current)
					switch(alert("You do not currently have a marked datum; do you want to pass null instead?",, "Yes", "Cancel"))
						if("Yes")
							; // do nothing
						if("Cancel")
							return

		if(!done)
			arguments += current
	return done
