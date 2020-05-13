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
		MAT_STEEL =     SHEET_MATERIAL_AMOUNT * 100,
		MAT_ALUMINIUM = SHEET_MATERIAL_AMOUNT * 100,
		MAT_PLASTIC =   SHEET_MATERIAL_AMOUNT * 100,
		MAT_GLASS =     SHEET_MATERIAL_AMOUNT * 100,
		MAT_GOLD =      SHEET_MATERIAL_AMOUNT * 100,
		MAT_SILVER =    SHEET_MATERIAL_AMOUNT * 100,
		MAT_PHORON =    SHEET_MATERIAL_AMOUNT * 100,
		MAT_URANIUM =   SHEET_MATERIAL_AMOUNT * 100,
		MAT_DIAMOND =   SHEET_MATERIAL_AMOUNT * 100
	)