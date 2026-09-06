/decl/salvage_repair_option
	abstract_type = /decl/salvage_repair_option
	var/selection_prob = 0
	var/list/selection_types
	var/list/selection_materials
	var/selection_min_amount = 1
	var/selection_max_amount = 3

/decl/salvage_repair_option/validate()
	. = ..()
	if(!islist(selection_types) || !length(selection_types))
		. += "null, empty or malformed selection_types list"
	else
		for(var/selection_type in selection_types)
			if(!ispath(selection_type))
				. += "non-path selection type: '[selection_type]'"
			else if(ispath(selection_type, /obj/item/stack/material) && (!islist(selection_materials) || !length(selection_materials)))
				. += "material stack '[selection_type]' in selection_types, but selection_materials is empty/malformed"
	for(var/selection_material in selection_materials)
		if(!ispath(selection_material, /decl/material))
			. += "non-material path '[selection_material]' in selection_materials"

/decl/salvage_repair_option/proc/create_salvage_requirement()
	var/use_type = pick(selection_types)
	var/use_mat  = ispath(use_type, /obj/item/stack/material) ? pick(selection_materials) : null
	return new /datum/salvage_repair_requirement(use_type, use_mat, rand(selection_min_amount, selection_max_amount))

/decl/salvage_repair_option/component
	selection_prob = 30
	selection_types = list(
		/obj/item/stock_parts/manipulator
	)

/decl/salvage_repair_option/material_sheet
	selection_prob = 40
	abstract_type = /decl/salvage_repair_option/material_sheet

/decl/salvage_repair_option/material_sheet/plastic
	selection_types = list(
		/obj/item/stack/material/panel
	)
	selection_materials = list(
		/decl/material/solid/organic/plastic
	)

/decl/salvage_repair_option/material_sheet/glass
	selection_types = list(
		/obj/item/stack/material/pane
	)
	selection_materials = list(
		/decl/material/solid/glass
	)

/decl/salvage_repair_option/material_sheet/plasteel
	selection_types = list(
		/obj/item/stack/material/sheet/reinforced
	)
	selection_materials = list(
		/decl/material/solid/metal/plasteel
	)

/decl/salvage_repair_option/launcher
	selection_prob = 50
	selection_materials = list(
		/decl/material/solid/metal/steel
	)
	selection_types = list(
		/obj/item/stack/tape_roll,
		/obj/item/stack/material/rods,
		/obj/item/handcuffs/cable
	)
	selection_max_amount = 1

/decl/salvage_repair_option/energy
	selection_prob = 25
	selection_types = list(
		/obj/item/stack/cable_coil,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/capacitor
	)
	selection_max_amount = 1

/decl/salvage_repair_option/magnetic
	selection_prob = 70
	selection_types = list(
		/obj/item/stock_parts/smes_coil,
		/obj/item/assembly/prox_sensor,
		/obj/item/stock_parts/circuitboard/apc
	)
	selection_max_amount = 1
