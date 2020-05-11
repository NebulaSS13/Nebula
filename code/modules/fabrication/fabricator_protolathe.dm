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