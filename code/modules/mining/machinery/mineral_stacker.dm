/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"
	console = /obj/machinery/computer/mining/stacking
	input_turf =  EAST
	output_turf = WEST
	var/stack_amt = 50
	var/list/stacks = list()

/obj/machinery/mineral/stacking_machine/Process()
	if(input_turf)
		for(var/obj/item/I in input_turf)
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/S = I
				if(S.material && S.material.stack_type)
					if(isnull(stacks[S.material.type]))
						stacks[S.material.type] = 0
					stacks[S.material.type] += S.amount
					qdel(S)
					continue
			if(output_turf)
				I.forceMove(output_turf)

	if(output_turf)
		for(var/sheet in stacks)
			if(stacks[sheet] >= stack_amt)
				var/decl/material/stackmat = decls_repository.get_decl(sheet)
				stackmat.place_sheet(output_turf, stack_amt)
				stacks[sheet] -= stack_amt

/obj/machinery/mineral/stacking_machine/get_console_data()
	. = ..()
	. += "<h1>Sheet Stacking</h1>"
	. += "Stacking: [stack_amt] <a href='?src=\ref[src];change_stack=1'>\[change\]</a>"
	var/line = ""
	for(var/stacktype in stacks)
		if(stacks[stacktype] > 0)
			var/decl/material/mat = decls_repository.get_decl(stacktype)
			line += "<tr><td>[capitalize(mat.solid_name)]</td><td>[stacks[stacktype]]</td><td><A href='?src=\ref[src];release_stack=\ref[mat]'>Release</a></td></tr>"
	. += "<table>[line]</table>"

/obj/machinery/mineral/stacking_machine/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,30,50,60)
		if(!choice) return
		stack_amt = choice
		. = TRUE
	if(href_list["release_stack"])
		var/decl/material/mat = locate(href_list["release_stack"])
		if(istype(mat) && stacks[mat.type] > 0)
			mat.place_sheet(output_turf, stacks[mat.type])
			stacks -= mat.type
			. = TRUE
	if(. && console)
		console.updateUsrDialog()

/obj/machinery/mineral/stacking_machine/on_update_icon()
	if(panel_open)
		icon_state = "stacker-open"
	else
		icon_state = "stacker"
