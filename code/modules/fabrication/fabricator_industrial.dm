/obj/machinery/fabricator/industrial
	name = "industrial fabricator"
	desc = "A hulking, powerful fabrication system for producing industrial machinery like exosuits."
	icon = 'icons/obj/machines/fabricators/industrial_fab.dmi'
	icon_state = "industrial"
	base_icon_state = "industrial"
	idle_power_usage = 20
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/industrial
	fabricator_class = FABRICATOR_CLASS_INDUSTRIAL
	base_storage_capacity = list(
		/decl/material/solid/metal/steel =      SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/osmium =     SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/aluminium =  SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/plastic =          SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/glass =            SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/gold =       SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/silver =     SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/uranium =    SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/gemstone/diamond = SHEET_MATERIAL_AMOUNT * 100
	)
	output_dir = EAST
