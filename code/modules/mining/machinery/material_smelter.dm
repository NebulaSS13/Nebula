#define MAX_INTAKE_ORE_PER_TICK 10
#define MAX_ORE_REAGENT_CONTENTS 100000

/obj/machinery/material_processing/smeltery
	name = "material processor"
	icon_state = "furnace"
	use_ui_template = "material_processing_smeltery.tmpl"
	var/list/casting
	var/list/show_materials = list(
		/decl/material/solid/metal/iron,
		/decl/material/solid/metal/gold,
		/decl/material/solid/metal/uranium,
		/decl/material/solid/metal/silver,
		/decl/material/solid/metal/platinum,
		/decl/material/solid/metal/steel,
		/decl/material/solid/mineral/graphite
	)

/obj/machinery/material_processing/smeltery/Initialize()
	. = ..()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	atom_flags &= ~ATOM_FLAG_NO_TEMP_CHANGE
	create_reagents(MAX_ORE_REAGENT_CONTENTS)
	QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/material_processing/smeltery/ProcessAtomTemperature()
	if(use_power)
		if(temperature < HIGH_SMELTING_HEAT_POINT)
			temperature = min(temperature + rand(1000, 2000), HIGH_SMELTING_HEAT_POINT)
		else if(temperature > HIGH_SMELTING_HEAT_POINT)
			temperature = HIGH_SMELTING_HEAT_POINT
		return TRUE
	. = ..()

/obj/machinery/material_processing/smeltery/power_change()
	. = ..()
	QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/material_processing/smeltery/proc/can_eat(var/obj/item/eating)
	for(var/mtype in eating.matter)
		var/decl/material/mat = GET_DECL(mtype)
		if(mat.melting_point > temperature)
			return FALSE
	return TRUE

/obj/machinery/material_processing/smeltery/Process()

	if(!use_power || (stat & (BROKEN|NOPOWER)))
		return

	if(input_turf)
		var/eaten = 0
		for(var/obj/item/eating in input_turf)
			if(!eating.simulated || eating.anchored)
				continue
			if(!can_eat(eating))
				if(output_turf)
					eating.dropInto(output_turf)
				continue
			eaten++
			if(eating.reagents?.total_volume)
				eating.reagents.trans_to_obj(src, Floor(eating.reagents.total_volume * 0.75)) // liquid reagents, lossy
			for(var/mtype in eating.matter)
				reagents.add_reagent(mtype, Floor(eating.matter[mtype] * REAGENT_UNITS_PER_MATERIAL_UNIT))
			qdel(eating)
			if(eaten >= MAX_INTAKE_ORE_PER_TICK)
				break
		if(emagged)
			for(var/mob/living/carbon/human/H in input_turf)
				for(var/obj/item/organ/external/eating in H.organs)
					if(!eating.simulated || eating.anchored || eating.is_stump() || !can_eat(eating) || !prob(5))
						continue
					visible_message(SPAN_DANGER("\The [src] rips \the [H]'s [eating.name] clean off!"))
					for(var/mtype in eating.matter)
						reagents.add_reagent(mtype, Floor(eating.matter[mtype] * REAGENT_UNITS_PER_MATERIAL_UNIT))
					eating.dismember(silent = TRUE)
					qdel(eating)
					break

	if(output_turf)
		for(var/mtype in casting)
			var/decl/material/mat = GET_DECL(mtype)
			var/ramt = REAGENT_VOLUME(reagents, mtype) || 0
			var/samt = Floor((ramt / REAGENT_UNITS_PER_MATERIAL_UNIT) / SHEET_MATERIAL_AMOUNT)
			if(samt > 0)
				mat.place_sheet(output_turf, samt)
				reagents.remove_reagent(mtype, ramt)
	
/obj/machinery/material_processing/smeltery/Topic(var/user, var/list/href_list)
	. = ..()
	if(href_list["toggle_alloying"])
		if(atom_flags & ATOM_FLAG_NO_REACT)
			atom_flags &= ~ATOM_FLAG_NO_REACT
			HANDLE_REACTIONS(reagents)
		else
			atom_flags |= ATOM_FLAG_NO_REACT
		. = TOPIC_REFRESH
	if(href_list["toggle_casting"])
		var/decl/material/mat = locate(href_list["toggle_casting"])
		if(istype(mat))
			if(mat.type in casting)
				casting -= mat.type
			else
				LAZYSET(casting, mat.type, TRUE)
			. = TOPIC_REFRESH

/obj/machinery/material_processing/smeltery/get_ui_data()
	var/list/data = ..()
	data["is_alloying"] = !(atom_flags & ATOM_FLAG_NO_REACT)
	var/list/materials = list()
	for(var/mtype in show_materials)
		var/decl/material/mat = GET_DECL(mtype)
		var/ramt = REAGENT_VOLUME(reagents, mtype) || 0
		var/samt = Floor((ramt / REAGENT_UNITS_PER_MATERIAL_UNIT) / SHEET_MATERIAL_AMOUNT)
		materials += list(list("label" = "[ramt]u [mat.solid_name] ([samt] ingot\s)", "casting" = (mtype in casting), "key" = "\ref[mat]"))
		data["materials"] = materials
	return data

/obj/machinery/material_processing/smeltery/on_reagent_change()
	. = ..()
	for(var/mtype in reagents?.reagent_volumes)
		show_materials |= mtype

#undef MAX_INTAKE_ORE_PER_TICK
#undef MAX_ORE_REAGENT_CONTENTS