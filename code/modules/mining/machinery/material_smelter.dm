#define MAX_INTAKE_ORE_PER_TICK 10

/obj/machinery/material_processing/smeltery
	name = "electric smelter"
	icon_state = "furnace"
	use_ui_template = "material_processing_smeltery.tmpl"
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	var/show_all_materials = FALSE
	var/list/casting
	var/static/list/always_show_materials = list(
		/decl/material/solid/metal/iron,
		/decl/material/solid/metal/gold,
		/decl/material/solid/metal/uranium,
		/decl/material/solid/metal/silver,
		/decl/material/solid/metal/platinum,
		/decl/material/solid/metal/steel,
		/decl/material/solid/mineral/graphite
	)
	var/list/show_materials

/obj/machinery/material_processing/smeltery/Initialize()
	show_materials = always_show_materials.Copy()
	. = ..()
	create_reagents(INFINITY)
	QUEUE_TEMPERATURE_ATOMS(src)

// Outgas anything that is in gas form. Check what you put into the smeltery, nerds.
/obj/machinery/material_processing/smeltery/on_reagent_change()
	. = ..()

	if(!reagents)
		return

	var/datum/gas_mixture/environment = loc?.return_air()
	if(!environment)
		return

	var/adjusted_air = FALSE
	for(var/mtype in reagents?.reagent_volumes)
		var/decl/material/mat = GET_DECL(mtype)
		if(mat.boiling_point && temperature >= mat.boiling_point)
			adjusted_air = TRUE
			var/removing = REAGENT_VOLUME(reagents, mtype)
			reagents.remove_reagent(mtype, removing, defer_update = TRUE)
			if(environment)
				environment.adjust_gas_temp(mtype, (removing * 0.2), temperature, FALSE) // Arbitrary conversion constant, TODO consistent one

	if(adjusted_air)
		if(environment)
			environment.update_values()
		reagents.update_total()

	for(var/mtype in reagents.reagent_volumes)
		show_materials |= mtype

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
				eating.reagents.trans_to_obj(src, FLOOR(eating.reagents.total_volume * 0.75)) // liquid reagents, lossy
			for(var/mtype in eating.matter)
				reagents.add_reagent(mtype, FLOOR(eating.matter[mtype] * REAGENT_UNITS_PER_MATERIAL_UNIT))
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
						reagents.add_reagent(mtype, FLOOR(eating.matter[mtype] * REAGENT_UNITS_PER_MATERIAL_UNIT))
					eating.dismember(silent = TRUE)
					qdel(eating)
					break

	if(output_turf)
		for(var/mtype in casting)
			var/ramt = REAGENT_VOLUME(reagents, mtype) || 0
			var/samt = FLOOR((ramt / REAGENT_UNITS_PER_MATERIAL_UNIT) / SHEET_MATERIAL_AMOUNT)
			if(samt > 0)
				SSmaterials.create_object(mtype, output_turf, samt)
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

	if(href_list["toggle_show_mats"])
		show_all_materials = !show_all_materials
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
	data["show_all_mats"] = show_all_materials
	var/list/materials = list()
	for(var/mtype in show_materials)
		var/decl/material/mat = GET_DECL(mtype)
		var/ramt = REAGENT_VOLUME(reagents, mtype) || 0
		if(ramt <= 0 && !show_all_materials && !(mtype in always_show_materials))
			continue
		var/samt = FLOOR((ramt / REAGENT_UNITS_PER_MATERIAL_UNIT) / SHEET_MATERIAL_AMOUNT)
		var/obj/item/stack/material/sheet = mat.default_solid_form
		materials += list(list("label" = "[mat.liquid_name]<br>[ramt]u ([samt] [samt == 1 ? initial(sheet.singular_name) : initial(sheet.plural_name)])", "casting" = (mtype in casting), "key" = "\ref[mat]"))
		data["materials"] = materials
	return data

#undef MAX_INTAKE_ORE_PER_TICK
