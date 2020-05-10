/obj/machinery/AdjustInitializeArguments(list/arguments)
	. = ..()
	if(arguments.len > 2)
		arguments[3] = FALSE
	else
		arguments |= list(null, FALSE)