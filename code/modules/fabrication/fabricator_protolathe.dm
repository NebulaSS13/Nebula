/obj/machinery/fabricator/protolathe
	name = "protolathe"
	desc = "An advanced rapid prototyping fabricator designed to produce highly specialized artifacts."
	icon = 'icons/obj/machines/fabricators/protolathe.dmi'
	icon_state = "protolathe"
	base_icon_state = "protolathe"
	idle_power_usage = 30
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/protolathe
	fabricator_class = FABRICATOR_CLASS_PROTOLATHE
	base_storage_capacity = list(
		/decl/material/solid/metal/steel =      SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/aluminium =  SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/plastic =          SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/glass =            SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/gold =       SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/silver =     SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/metal/uranium =    SHEET_MATERIAL_AMOUNT * 100,
		/decl/material/solid/gemstone/diamond = SHEET_MATERIAL_AMOUNT * 100
	)