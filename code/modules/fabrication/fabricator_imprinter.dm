/obj/machinery/fabricator/imprinter
	name = "circuit imprinter"
	desc = "An advanced fabricator that etches circuits from various materials and acids."
	icon = 'icons/obj/machines/fabricators/imprinter.dmi'
	icon_state = "imprinter"
	base_icon_state = "imprinter"
	idle_power_usage = 30
	active_power_usage = 2500
	base_type = /obj/machinery/fabricator/imprinter
	fabricator_class = FABRICATOR_CLASS_IMPRINTER
	base_storage_capacity = list(
		MAT_GLASS =                        SHEET_MATERIAL_AMOUNT * 50,
		MAT_GOLD =                         SHEET_MATERIAL_AMOUNT * 50,
		MAT_SILVER =                       SHEET_MATERIAL_AMOUNT * 50,
		MAT_DIAMOND =                      SHEET_MATERIAL_AMOUNT * 50,
		/decl/reagent/acid =              120,
		/decl/reagent/acid/hydrochloric = 120,
		/decl/reagent/acid/polyacid =     120
	)