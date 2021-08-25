/obj/machinery/material_processing/stacker
	name = "ingot stacker"
	icon_state = "stacker"
	use_ui_template = "material_processing_stacker.tmpl"
	var/stack_max = 50
	var/list/stacked = list()

/obj/machinery/material_processing/stacker/OnTopic(var/user, var/list/href_list)
	. = ..()
	if(href_list["change_stack_max"])
		stack_max = text2num(href_list["change_stack_max"])
		. = TOPIC_REFRESH
	if(href_list["release_sheets"] && output_turf)
		var/decl/material/mat = locate(href_list["release_sheets"])
		if(istype(mat) && stacked[mat.type] > 0)
			mat.create_object(output_turf, stacked[mat.type])
			stacked -= mat.type
			. = TOPIC_REFRESH

/obj/machinery/material_processing/stacker/get_ui_data()
	var/list/data = ..()
	data["stack_max"] = stack_max
	var/list/stacks = list()
	for(var/stack in stacked)
		if(stacked[stack] > 0)
			var/decl/material/mat = GET_DECL(stack)
			stacks += list(list("name" = "[capitalize(mat.solid_name)] x [stacked[stack]]", "key" = "\ref[mat]"))
	data["stacks"] = stacks
	return data

/obj/machinery/material_processing/stacker/Process()

	if(!use_power || (stat & (BROKEN|NOPOWER)))
		return

	if(input_turf)
		for(var/obj/item/stack/material/S in input_turf)
			if(!S.material)
				continue
			if(isnull(stacked[S.material.type]))
				stacked[S.material.type] = S.amount
			else
				stacked[S.material.type] += S.amount
			qdel(S)

		if(emagged)
			for(var/mob/living/M in input_turf)
				visible_message(SPAN_DANGER("\The [src] squashes \the [src] with its stacking mechanism!"))
				M.take_overall_damage(rand(10, 20), 0)
				break

	if(output_turf)
		for(var/sheet in stacked)
			if(stacked[sheet] >= stack_max)
				SSmaterials.create_object(sheet, output_turf, stack_max)
				stacked[sheet] -= stack_max
