/obj/machinery/fabricator/robotics
	name = "robotics fabricator"
	desc = "A complex and flexible nanofabrication system for producing electronics and robotics."
	icon = 'icons/obj/machines/fabricators/robotics.dmi'
	icon_state = "robotics"
	base_icon_state = "robotics"
	idle_power_usage = 20
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/robotics
	fabricator_class = FABRICATOR_CLASS_ROBOTICS
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